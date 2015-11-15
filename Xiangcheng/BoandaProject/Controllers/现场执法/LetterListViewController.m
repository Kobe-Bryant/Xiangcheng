//
//  LetterListViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-5-23.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "LetterListViewController.h"
#import "UITableViewCell+Custom.h"
#import "PopupDateViewController.h"
#import "LetterDetailsViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"

@interface LetterListViewController ()<UITextFieldDelegate,PopupDateDelegate>
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger currentTag;
@property (nonatomic,assign) NSInteger isEnd;
@end

@implementation LetterListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.valueArray = [[NSMutableArray alloc]init];
    self.currentPage = 1;
    [self requestData];
}

-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"HJXF_QUERY_LIST" forKey:@"service"];
    if (self.lwbhTextFile.text && [self.lwbhTextFile.text length]) {
       [params setObject:self.lwbhTextFile.text forKey:@"LWBH"];
    }
    if (self.tsnrTextField.text && [self.tsnrTextField.text length]) {
        [params setObject:self.tsnrTextField.text forKey:@"TSNR"];
    }
    if (self.startTextField.text && [self.startTextField.text length]) {
        [params setObject:self.startTextField.text forKey:@"STARTTSSJ"];
    }
    if (self.endTxetField.text && [self.endTxetField.text length]) {
        [params setObject:self.endTxetField.text forKey:@"ENDTSSJ"];
    }
    [params setObject:[NSString stringWithFormat:@"%d",ONE_PAGE_SIZE] forKey:@"PAGESIZE"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"CURRENT"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (IBAction)searchButtonPress:(UIButton *)sender {
    NSArray *array = [self.view subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
        }
    }
    self.isEnd = NO;
    self.currentPage = 1;
    [self.valueArray removeAllObjects];
    [self requestData];
}

- (IBAction)textFieldTouchDonw:(UITextField *)sender {
    self.currentTag = sender.tag;
    sender.text = @"";
    PopupDateViewController *dateViewController = [[PopupDateViewController alloc]initWithPickerMode:UIDatePickerModeDate];
    dateViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dateViewController];
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:nav];
    [self.poverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        
        if (!self.isEnd) {
            self.currentPage++;
            [self requestData];
        }
		else{
            [self showText:kNETLAST_MESSAGE];
        }
    }
}

#pragma mark PopupDateDelegate

-(void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date{
    [self.poverController dismissPopoverAnimated:YES];
	if (bSaved) {
        if (self.currentTag == 1)
        {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [matter stringFromDate:date];
            NSDate *jzsjDate = [matter dateFromString:self.endTxetField.text];
            NSTimeInterval qssj = [date timeIntervalSince1970];
            NSTimeInterval jzsj = [jzsjDate timeIntervalSince1970];
            if (jzsj > qssj || [self.endTxetField.text isEqualToString:@""]) {
                self.startTextField.text = dateString;
            }
            else{
                [self showAlertMessage:@"起始时间不能晚于截止时间"];
            }
        }
        else if (self.currentTag == 2)
        {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [matter stringFromDate:date];
            NSDate *qssjDate = [matter dateFromString:self.startTextField.text];
            NSTimeInterval jzsj = [date timeIntervalSince1970];
            NSTimeInterval qssj = [qssjDate timeIntervalSince1970];
            if (jzsj > qssj || [self.startTextField.text isEqualToString:@""]) {
                self.endTxetField.text = dateString;
            }
            else{
                [self showAlertMessage:@"截止时间不能早于起始时间"];
            }
        }
    }
}

-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    NSString *jsonStr = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [jsonStr objectFromJSONString];
    NSArray *array = [jsonDic objectForKey:@"data"];
    if (array.count < ONE_PAGE_SIZE) {
        self.isEnd = YES;
    
    }
    if (array && array.count) {
        [self.valueArray addObjectsFromArray:array];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.valueArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *valueDic = [self.valueArray objectAtIndex:indexPath.row];
    NSString *title = [valueDic objectForKey:@"XFZT"];
    NSString *value1 = [NSString stringWithFormat:@"所属街道：%@",[valueDic objectForKey:@"XZQH"]];
    NSString *value2 = [NSString stringWithFormat:@"投诉时间：%@",[valueDic objectForKey:@"TSSJ"]];
    NSString *value3 = [NSString stringWithFormat:@"投诉人：%@",[valueDic objectForKey:@"TSR"]];
    NSString *value4 = [NSString stringWithFormat:@"是否调查：%@",[valueDic objectForKey:@"SFCL"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:title andSubvalue1:value1 andSubvalue2:value2 andSubvalue3:value3 andSubvalue4:value4 andNoteCount:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UItextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *valueDic = [self.valueArray objectAtIndex:indexPath.row];
    LetterDetailsViewController *detailsVC = [[LetterDetailsViewController alloc]init];
    detailsVC.wrymc = [valueDic objectForKey:@"XFZT"];
    detailsVC.xfbh = [valueDic objectForKey:@"XFBH"];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setStartTextField:nil];
    [self setEndTxetField:nil];
    [self setSearchButton:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
