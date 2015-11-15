//
//  PersonViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-2.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "PersonViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "ChartItem.h"
#import "NTChartView.h"

@interface PersonViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)IBOutlet UILabel *qssjLab;
@property (nonatomic,strong)IBOutlet UILabel *jzsjLab;
@property (nonatomic,strong)IBOutlet UITextField *qssjFie;
@property (nonatomic,strong)IBOutlet UITextField *jzsjFie;
@property (nonatomic,strong)IBOutlet UIButton *searchBtn;
@property (nonatomic,strong)IBOutlet UIButton *hisgramBtn;
@property (nonatomic,strong)IBOutlet UIView *hisgramView;
@property (nonatomic,strong)IBOutlet UITableView *listTableView;
@property (nonatomic,strong)NSMutableArray *valueAry;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) UIScrollView *scrView;
@property (nonatomic,strong) UISegmentedControl *segCtrl;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign)BOOL isDisplay;//图表是否展示

@end

@implementation PersonViewController

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
    
    self.segCtrl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"  个人统计  ",@"  区域统计  ", nil]];
    self.segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segCtrl addTarget:self action:@selector(segctrlClicked:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segCtrl;
    self.segCtrl.selectedSegmentIndex = 0;
    
    self.valueAry = [[NSMutableArray alloc]init];
    
    [self.hisgramBtn addTarget:self action:@selector(hisgramBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self initDefaultData];
    [self requestData];
}
-(void)hisgramBtnClick
{
    if (self.isDisplay == NO)
    {
        [self openHistogram];
    }
    else
    {
        [self closeHistogram];
    }
    self.isDisplay = !self.isDisplay;
}
-(void)openHistogram
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.hisgramView.frame = CGRectMake(0, 500, 768, 460);
    self.listTableView.frame = CGRectMake(0, 85, 768, 835-420);
    [UIView commitAnimations];
    [self addChartView];
    
}
-(void)addChartView{
    if (self.scrView) {
        [self.scrView removeFromSuperview];
    }
    self.scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 768, 420)];
    [self.hisgramView addSubview:self.scrView];
    self.scrView.contentSize = CGSizeMake(768, 460);
    NTChartView *chartView = [[NTChartView alloc] initWithFrame:CGRectMake(0, 0, 768, self.hisgramView.frame.size.height)];
	[self.scrView addSubview:chartView];
    UILabel *unitLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    unitLab.text = @"单位：1";
    unitLab.backgroundColor = [UIColor clearColor];
    [self.scrView addSubview:unitLab];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    ChartItem *aItem;
    UIColor *aColor;
    
    for (int i=0; i<[self.valueAry count]; i++)
    {
        float value = 0;
        NSString *name = nil;
        aColor = [[ChartItem makeColorArray]objectAtIndex:(i+14)%14];
        NSMutableDictionary *itemDic = [self.valueAry objectAtIndex:i];
        if (self.segCtrl.selectedSegmentIndex == 0) {
            value = [[itemDic objectForKey:@"num"]floatValue];
            name = [itemDic objectForKey:@"ry"];
        }
        
        else{
            value = [[itemDic objectForKey:@"ywsls"]floatValue];
            name = [itemDic objectForKey:@"ssjd"];
        }
        aItem = [ChartItem itemWithValue:value Name:name Color:aColor.CGColor];
        [itemArray addObject:aItem];
                
    }
    
    [chartView addGroupArray:itemArray withGroupName:@"group"];
    [chartView setNeedsDisplay];
}

-(void)closeHistogram
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.hisgramView.frame = CGRectMake(0, 400+520, 768, 460);
    self.listTableView.frame = CGRectMake(0, 85, 768, 835);
    [UIView commitAnimations];
}

#pragma mark - 初始化
- (void)initDefaultData
{
    
    [self.qssjFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.jzsjFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	self.dateController.delegate = self;
	
	UINavigationController *navDate = [[UINavigationController alloc] initWithRootViewController:self.dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navDate];
	self.popController = popover;
    
    NSDate *nowDate = [NSDate date];
    NSDate *beforData = [NSDate dateWithTimeInterval:-60*60*24*30 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.jzsjFie.text = [dateFormatter stringFromDate:nowDate];
    self.qssjFie.text = [dateFormatter stringFromDate:beforData];
    
    
}
-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.segCtrl.selectedSegmentIndex==0)
    {
        [params setObject:@"QUERY_GRZFTJ_IPAD" forKey:@"service"];
        [params setObject:self.qssjFie.text forKey:@"startdate"];
        [params setObject:self.jzsjFie.text forKey:@"enddate"];
    }
    else
    {
        [params setObject:@"QUERY_XZQHZFTJ_IPAD" forKey:@"service"];
        [params setObject:self.qssjFie.text forKey:@"startdate"];
        [params setObject:self.jzsjFie.text forKey:@"enddate"];
    }
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^^^^^%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}

#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    BOOL bParseError = NO;
    if(webData.length > 0)
    {
        
        NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSArray *detailAry = [[jsonStr objectFromJSONString]objectForKey:@"data"];
        if (self.valueAry.count >0)
        {
            [self.valueAry removeAllObjects];
        }
        if (detailAry != nil && detailAry.count)
        {
            
            [self.valueAry addObjectsFromArray:detailAry];
            
            if (self.segCtrl.selectedSegmentIndex == 0) {
                int sub = 0;
                NSMutableDictionary *hjDic = [[NSMutableDictionary alloc]init];
                for (NSDictionary *dic in detailAry) {
                    NSNumber *num = [dic objectForKey:@"num"];
                    sub += [num intValue];
                }
                [hjDic setObject:[NSNumber numberWithInt:sub] forKey:@"num"];
                [hjDic setObject:@"合计" forKey:@"ry"];
                [self.valueAry addObject:hjDic];
            }
        }
        else{
            bParseError = YES;
        }
    }
    else
    {
        bParseError = YES;
    }
    if (bParseError) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"查询不到数据"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.listTableView reloadData];
    self.isDisplay = YES;
    [self openHistogram];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错!"];
}

-(void)segctrlClicked:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    self.segCtrl.selectedSegmentIndex = seg.selectedSegmentIndex;
    [self requestData];
}
- (void)touchFromDate:(id)sender
{
    UITextField *tfd =(UITextField*)sender;
    self.currentTag = tfd.tag;
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    if (self.currentTag == 1) {
        NSDate *data = [matter dateFromString:self.qssjFie.text];
        self.dateController.date = data;
    }
    else if (self.currentTag == 2){
        NSDate *data = [matter dateFromString:self.jzsjFie.text];
        self.dateController.date = data;
    }
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)searchBtnPressed:(id)sender
{
    for (UIView* vi in [self.view subviews])
    {
        if ([vi isKindOfClass:[UITextField class]])
        {
            UITextField* tv = (UITextField*)vi;
            [tv resignFirstResponder];
        }
    }
    
    [self requestData];
    
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
            NSDate *jzsjDate = [matter dateFromString:self.jzsjFie.text];
            NSTimeInterval qssj = [date timeIntervalSince1970];
            NSTimeInterval jzsj = [jzsjDate timeIntervalSince1970];
            if (jzsj>qssj) {
                self.qssjFie.text = dateString;
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
            NSDate *qssjDate = [matter dateFromString:self.qssjFie.text];
            NSTimeInterval jzsj = [date timeIntervalSince1970];
            NSTimeInterval qssj = [qssjDate timeIntervalSince1970];
            if (jzsj>qssj) {
                self.jzsjFie.text = dateString;
            }
            else{
                [self showAlertMessage:@"截止时间不能早于起始时间"];
            }
        }
    }
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
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonCell" owner:self options:nil]lastObject];
    }
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    
    if (self.valueAry.count>0)
    {
        if (self.segCtrl.selectedSegmentIndex == 0) {
    
            NSDictionary *dic = [self.valueAry objectAtIndex:indexPath.row];
            NSString *name = [dic objectForKey:@"ry"];
            NSString *numb= [NSString stringWithFormat:@"%d",[[dic objectForKey:@"num"] integerValue]];
            
            label1.text = name;
            label2.text = numb;
        }
        else{
            NSDictionary *dic = [self.valueAry objectAtIndex:indexPath.row];
            NSString *name = [dic objectForKey:@"ssjd"];
            NSString *numb= [NSString stringWithFormat:@"%d",[[dic objectForKey:@"ywsls"] integerValue]];
            
            label1.text = name;
            label2.text = numb;
        }
    }
    
    cell.userInteractionEnabled = NO;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

@end
