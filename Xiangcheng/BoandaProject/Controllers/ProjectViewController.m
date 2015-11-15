//
//  ProjectViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-3-4.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "ProjectViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "ProjectInfoViewController.h"
#import "CommenWordsViewController.h"
#import "FPPopoverController.h"

@interface ProjectViewController ()<UITextFieldDelegate,WordsDelegate>
@property (nonatomic,strong) FPPopoverController *popover;
@property (nonatomic,strong) NSMutableArray *yearArray;
@property (nonatomic,copy) NSString *pageCount;
@end

@implementation ProjectViewController

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
    [self.view addGestureRecognizer:self.swipe];
    // Do any additional setup after loading the view from its nib.
    self.title = @"项目审批查询";
    self.valueAry = [[NSMutableArray alloc]init];
    [self.qsrqFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.jzrqFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	self.dateController.delegate = self;
	
	UINavigationController *navDate = [[UINavigationController alloc] initWithRootViewController:self.dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navDate];
	self.popController = popover;
    self.currentPage = 1;
    
    self.yearArray = [[NSMutableArray alloc]init];
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy"];
    NSString *nowYear = [matter stringFromDate:[NSDate date]];
    for (int i=0; i< 20; i++) {
        NSString *year = [NSString stringWithFormat:@"%d",[nowYear intValue]-i];
        [self.yearArray addObject:year];
    }
    
    [self requestData];
}
-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"XMSP_DATA_LIST" forKey:@"service"];
    [params setObject:self.qsrqFie.text forKey:@"spsj_start"];
    [params setObject:self.jzrqFie.text forKey:@"spsj_end"];
    [params setObject:self.xmmcFie.text forKey:@"xmmc"];
    [params setObject:self.lxdzFie.text forKey:@"lxdz"];
    [params setObject:self.jsdwFie.text forKey:@"jsdw"];
    [params setObject:self.spwhFie.text forKey:@"spwh"];
    [params setObject:self.spnfFie.text forKey:@"spy"];
    [params setObject:self.spszFie.text forKey:@"sph"];
    [params setObject:[NSString stringWithFormat:@"%d",ONE_PAGE_SIZE] forKey:@"pagesize"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"current"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^%@",strUrl);
    self.pageCount = @"0";
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}
- (IBAction)touchFromDate:(UITextField *)sender {
    sender.text = @"";
    self.currentTag = sender.tag;
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    if (self.currentTag == 1) {
        NSDate *data = [matter dateFromString:self.qsrqFie.text];
        self.dateController.date = data;
    }
    else if (self.currentTag == 2){
        NSDate *data = [matter dateFromString:self.jzrqFie.text];
        self.dateController.date = data;
    }
    else{
        CommenWordsViewController *wordsViewController = [[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain];
        wordsViewController.title = @"请选择年份";
        wordsViewController.delegate = self;
        wordsViewController.wordsAry = self.yearArray;
        self.popover = [[FPPopoverController alloc] initWithViewController:wordsViewController];
        self.popover.contentSize = CGSizeMake(130, 300);
        self.popover.tint = FPPopoverLightGrayTint;
        self.popover.arrowDirection = FPPopoverArrowDirectionAny;
        [self.popover presentPopoverFromView:sender];
        return;
    }
	[self.popController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)searchBtnPressed:(id)sender
{
    self.currentPage = 1;
    self.isEnd = NO;
    for (UIView* vi in [self.view subviews])
    {
        if ([vi isKindOfClass:[UITextField class]])
        {
            UITextField* tv = (UITextField*)vi;
            [tv resignFirstResponder];
        }
    }
    [self.valueAry removeAllObjects];
    [self requestData];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
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

#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    BOOL bParsedError = NO;
    if(webData.length > 0)
    {
        NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSArray *ary = [jsonStr componentsSeparatedByString:@"data"];
        NSString *str = [ary objectAtIndex:1];
        jsonStr = [NSString stringWithFormat:@"{\"data\"%@",str];
        NSDictionary *detailDict = [jsonStr objectFromJSONString];
        NSArray *dataArray = [detailDict objectForKey:@"data"];
        NSString *countStr = [ary objectAtIndex:0];
        NSArray *countAry = [countStr componentsSeparatedByString:@"ZS:"];
        countStr = [countAry objectAtIndex:1];
        self.pageCount = [countStr substringToIndex:countStr.length-2];
        if (self.currentPage == 1) {
            [self.valueAry removeAllObjects];
        }
        if (dataArray.count < ONE_PAGE_SIZE) {
            self.isEnd = YES;
        }
        if (dataArray && dataArray.count) {
        
        [self.valueAry addObjectsFromArray:dataArray];
        }
        else
        {
            bParsedError = YES;
        }
    }
    
    if(bParsedError)
    {
        [self showAlertMessage:@"查询不到数据"];
    }
    
    [self.listTableView reloadData];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错!"];
}

#pragma mark - Choose Date delegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
        if (self.currentTag == 1)
        {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [matter stringFromDate:date];
            NSDate *jzsjDate = [matter dateFromString:self.jzrqFie.text];
            NSTimeInterval qssj = [date timeIntervalSince1970];
            NSTimeInterval jzsj = [jzsjDate timeIntervalSince1970];
            if (jzsj>qssj || ![self.jzrqFie.text length]) {
                self.qsrqFie.text = dateString;
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
            NSDate *qssjDate = [matter dateFromString:self.qsrqFie.text];
            NSTimeInterval jzsj = [date timeIntervalSince1970];
            NSTimeInterval qssj = [qssjDate timeIntervalSince1970];
            if (jzsj>qssj || ![self.qsrqFie.text length]) {
                self.jzrqFie.text = dateString;
            }
            else{
                [self showAlertMessage:@"截止时间不能早于起始时间"];
            }
        }
    }
}

#pragma mark - Words Date delegate

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    self.spnfFie.text = words;
    [self.popover dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.valueAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *tmpDic = [self.valueAry objectAtIndex:indexPath.row];
    //现场检查人  询问人
    
    NSString *person = [NSString stringWithFormat:@"建设单位：%@",[tmpDic objectForKey:@"JSDW"]];
    NSString *sftg = @"是否通过审批：";
    int x = [[tmpDic objectForKey:@"SFTGSP"]integerValue];
    if (x==1)
    {
        sftg = [NSString stringWithFormat:@"%@是",sftg];
    }
    else
    {
        sftg = [NSString stringWithFormat:@"%@否",sftg];
    }
    
    NSString *dwdz = [tmpDic objectForKey:@"LXDZ"];
    
    cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"XMMC"] andSubvalue1:[NSString stringWithFormat:@"建设地址：%@",dwdz] andSubvalue2:person andSubvalue3:sftg andSubvalue4:@"" andNoteCount:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"查询结果%@条",self.pageCount];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [self.valueAry objectAtIndex:indexPath.row];
    ProjectInfoViewController *infoVC = [[ProjectInfoViewController alloc]init];
    infoVC.xmbh = [tmpDic objectForKey:@"XMBH"];
    infoVC.xmmc = [tmpDic objectForKey:@"XMMC"];
    
    [self.navigationController pushViewController:infoVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)viewDidUnload {
    [self setSpwhFie:nil];
    [self setSpnfFie:nil];
    [self setSpszFie:nil];
    [self setJsdwFie:nil];
    [super viewDidUnload];
}
@end