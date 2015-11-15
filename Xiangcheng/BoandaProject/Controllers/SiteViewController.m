//
//  SiteViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-3-20.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "SiteViewController.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "S7GraphView.h"
#import "ChooseTimeRangeVC.h"

@interface SiteViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,S7GraphViewDataSource,ChooseTimeRangeDelegate>
@property (nonatomic,strong) WebServiceHelper *serviceHelper;
@property (nonatomic,strong) S7GraphView *graphView;
@property (nonatomic,strong) UIWebView *resultWebView;
@property (nonatomic,strong) UITableView *dataTableView;
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (nonatomic,strong) UILabel *graphTitle;
@property (nonatomic,strong) NSArray *resultDataAry;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *numberArray;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSDate *selectTime;
@property (nonatomic,strong) NSDate *beforeTime;
@property (nonatomic,copy) NSString *dataFreshStatus;
@property (nonatomic,strong) NSMutableString *html;
@property (nonatomic,copy) NSString *showKey;
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,copy) NSString *unit;;
@end

@implementation SiteViewController
@synthesize ASCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dateTextFieldTouchDown:(UIBarButtonItem *)sender{
    if (self.poverController) {
        [self.poverController dismissPopoverAnimated:YES];
    }
    [self.poverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)segmentedPress:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.dataFreshStatus = @"Real";
            break;
        case 1:
            self.dataFreshStatus = @"Hour";
            break;
        case 2:
            self.dataFreshStatus = @"Day";
            break;
    }
    [self requestData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.serviceHelper) {
        [self.serviceHelper cancel];
    }
    [self.poverController dismissPopoverAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *timeBar = [[UIBarButtonItem alloc]initWithTitle:@"选择日期" style:UIBarButtonItemStyleBordered target:self action:@selector(dateTextFieldTouchDown:)];
    self.navigationItem.rightBarButtonItem = timeBar;
    
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@" 实时数据 " ,@"  小时数据 ",@" 日数据 "]];
    self.segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segment addTarget:self action:@selector(segmentedPress:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segment;
    
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 508, 289, 421) style:UITableViewStyleGrouped];
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    [self.view addSubview:self.dataTableView];
    self.resultWebView = [[UIWebView alloc] initWithFrame:CGRectMake(305, 504, 452, 421)];
    [self.view addSubview:self.resultWebView];
    self.graphTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 700, 21)];
    self.graphTitle.backgroundColor = [UIColor clearColor];
    self.graphTitle.textAlignment = NSTextAlignmentCenter;
    self.graphTitle.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.graphTitle];
    
    self.graphView = [[S7GraphView alloc] initWithFrame:CGRectMake(10, 45, 740, 430)];
	self.graphView.dataSource = self;
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:1];
	[numberFormatter setMaximumFractionDigits:1];
	self.graphView.yValuesFormatter = numberFormatter;
	self.graphView.backgroundColor = [UIColor whiteColor];
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	self.graphView.xValuesColor = [UIColor blackColor];
	self.graphView.yValuesColor = [UIColor blackColor];
	self.graphView.gridXColor = [UIColor blackColor];
	self.graphView.gridYColor = [UIColor blackColor];
	self.graphView.drawInfo = YES;
	self.graphView.infoColor = [UIColor blackColor];
    [self.view addSubview:self.graphView];
    
    self.unit = @"";
    self.showKey = @"w01001";
    self.dataFreshStatus = @"Real";
    self.selectTime = [NSDate date];
    self.beforeTime = [NSDate dateWithTimeInterval:-60*60*24*15 sinceDate:self.selectTime];
    
    ChooseTimeRangeVC *chooseTime = [[ChooseTimeRangeVC alloc]initWithStartDate:self.beforeTime andEndDtate:self.selectTime andDatePickerMode:UIDatePickerModeDateAndTime];
    chooseTime.delegate = self;
    UINavigationController *dateNav = [[UINavigationController alloc]initWithRootViewController:chooseTime];
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:dateNav];
    
    self.valueArray = [[NSMutableArray alloc]init];
    self.timeArray = [[NSMutableArray alloc]init];
//    self.titleArray = [NSArray arrayWithObjects:@"pH值", @"浊度", @"溶解氧", @"水温", @"电导率", @"高锰酸盐指数", @"总有机碳", @"总氮", @"氨氮", @"总磷",@"挥发酚秒", @"非金属无机物", nil];
//    self.numberArray = [NSArray arrayWithObjects:@"w01001", @"w01003", @"w01009", @"w01010", @"w01014", @"w01019", @"w01020",@"w21001", @"w21003", @"w21011", @"w23002", @"w21000",nil];
    self.titleArray = [NSArray arrayWithObjects:@"pH值", @"浊度", @"溶解氧", @"水温", @"电导率", @"总氮", @"氨氮", @"总磷", nil];
    self.numberArray = [NSArray arrayWithObjects:@"w01001", @"w01003", @"w01009", @"w01010", @"w01014",@"w21001", @"w21003", @"w21011",nil];
    [self.dataTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.dataTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    self.itemName = [self.titleArray objectAtIndex:indexPath.row];
    
    [self requestData];
}

- (void)addView:(UIView *)view type:(NSString *)type subType:(NSString *)subType
{
    if(view.superview !=nil)
        [view removeFromSuperview];
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    [self.view addSubview:view];
    [[view layer] addAnimation:transition forKey:@"ADD"];
    
    
}

-(void)requestData{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%d",50] forKey:@"PageSize"];
    [params setObject:@"1" forKey:@"PageNow"];
    [params setObject:self.ASCode forKey:@"StationCode"];
    [params setObject:self.dataFreshStatus forKey:@"DataFreshStatus"];
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *selectTime = [matter stringFromDate:self.selectTime] ;
    NSString *beforeTime = [matter stringFromDate:self.beforeTime];
    [params setObject:[beforeTime stringByReplacingOccurrencesOfString:@" " withString:@"T"] forKey:@"DateTimeFrom"];
    [params setObject:[selectTime stringByReplacingOccurrencesOfString:@" " withString:@"T"] forKey:@"DateTimeTo"];
    NSString *paramStr = [WebServiceHelper createParametersWithParams:params];
    if (self.serviceHelper.bConnected) {
        [self.serviceHelper cancel];
    }
    self.serviceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://222.92.101.82:8080/XC_Service_Water/main.asmx" method:@"Search__SectionMonitorData" nameSpace:@"http://tempuri.org/" parameters:paramStr delegate:self];
    [self.serviceHelper runAndShowWaitingView:self.view];
}

-(void)processWebData:(NSData *)webData{
    if ([webData length]<=0) {
        [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
    }
    WebDataParserHelper *parserHelper = [[WebDataParserHelper alloc]initWithFieldName:@"Search__SectionMonitorDataResult" andWithJSONDelegate:self];
    [parserHelper parseXMLData:webData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
}

-(void)parseJSONString:(NSString *)jsonStr{
    self.resultDataAry = nil;
    NSDictionary *jsonDic = [jsonStr objectFromJSONString];
    NSArray *dataArray = [jsonDic objectForKey:@"Data"];
    if (dataArray != nil || ![dataArray isEqual:[NSNull null]] || dataArray .count) {
        self.resultDataAry = [NSArray arrayWithArray:dataArray];
    }
    
    [self displayData];
}

-(void)displayData{
    
    if ([self.valueArray count] > 0)
        [self.valueArray removeAllObjects];
    if ([self.timeArray count] > 0)
        [self.timeArray removeAllObjects];
    
    self.graphView.info = self.unit;
    
    for (int i= self.resultDataAry.count-1; i>=0; i--) {
        NSDictionary *dataDic = nil;
        NSDictionary *tmpDic = [self.resultDataAry objectAtIndex:i];
        NSArray *array = [tmpDic objectForKey:@"EntityList"];
        for (NSDictionary *numDic in array) {
            NSString *numStr = [numDic objectForKey:@"MonitorFactorCode"];
            if ([self.showKey isEqualToString:numStr]) {
                dataDic = numDic;
            }
        }
        
        NSString *time = [dataDic objectForKey:@"MonitorTime"];
        NSString *count = [dataDic objectForKey:@"MonitorValue"];
        NSString *value = [NSString stringWithFormat:@"%.2f",[count floatValue]];
        NSString *timeStr = [time substringWithRange:NSMakeRange(6, 13)];
        double timeDou = [timeStr doubleValue]/1000;
        NSDateFormatter *matter = [[NSDateFormatter alloc]init];
        if (self.segment.selectedSegmentIndex == 2) {
            [matter setDateFormat:@"yyyy-MM-dd"];
        }
        else if (self.segment.selectedSegmentIndex == 1){
            [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
        else{
            [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeDou];
        time = [matter stringFromDate:date];
        [self.valueArray addObject:value];
        [self.timeArray addObject:time];
        
        if (i == [self.resultDataAry count]-1) {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            self.beforeSave = [matter stringFromDate:date];
        }
        else if (i == 0){
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            self.selectSave = [matter stringFromDate:date];
        }
    }
    
    if (self.valueArray.count <= 1) {
        self.graphTitle.text = @"";
        self.resultDataAry = nil;
        [self.valueArray removeAllObjects];
        [self.timeArray removeAllObjects];
    }
    else{
        self.graphTitle.text = [NSString stringWithFormat:@"%@%@至%@监测数据",self.title,self.beforeSave,self.selectSave];
    }

    NSString *width = @"452px";
    
    self.html = [NSMutableString string];
    [self.html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th></tr>",width,self.itemName,width];
    
    BOOL boolColor = true;
    for (int i= self.resultDataAry.count-1; i>=0; i--) {
        [self.html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
        boolColor = !boolColor;
        [self.html appendFormat:@"<td align=center>%@</td><td align=center>%@</td>",[self.timeArray objectAtIndex:i],[NSString stringWithFormat:@"%@%@",[self.valueArray objectAtIndex:i],self.unit]];
        [self.html appendString:@"</tr>"];
    }
    
    [self.html appendString:@"</table></body></html>"];
    [self.graphView reloadData];
    [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
    [self.resultWebView loadHTMLString:self.html baseURL:nil];
    [self addView:self.resultWebView type:@"pageCurl" subType:kCATransitionFromRight];
}

-(void)choosedFromTime:(NSDate *)fromTime andEndTime:(NSDate *)endTime{
    NSTimeInterval beforeTimeInterval = [self.beforeTime timeIntervalSince1970];
    NSTimeInterval selectTimeInterval = [self.selectTime timeIntervalSince1970];
    if (beforeTimeInterval > selectTimeInterval) {
        [self showAlertMessage:@"截止时间不能早于开始时间"];
    }
    else{
        self.beforeTime = fromTime;
        self.selectTime = endTime;
        [self requestData];
    }
    [self.poverController dismissPopoverAnimated:YES];
}

-(void)cancelSelectTimeRange{
    [self.poverController dismissPopoverAnimated:YES];
}

#pragma mark - protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	if (self.valueArray == nil || 0 == [self.valueArray count]) {
		return 0;//还未取到数据
	}
	return 1;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
    
	
	int xCount = [self.timeArray count];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:xCount];
	for ( int i = 0 ; i < xCount ; i ++ ) {
		NSString *str =[self.timeArray objectAtIndex:i];
		[array addObject:[str substringFromIndex:5]];
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
    
	NSMutableArray* ary = [[NSMutableArray alloc] initWithCapacity:10];
	for (NSString *value in self.valueArray) {
		[ary addObject:[NSNumber numberWithFloat:[value floatValue]]];
	}
	return ary;
}

-(BOOL)graphViewIfSumValues:(S7GraphView *)graphView{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.titleArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"监测因子";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"];
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.showKey = [self.numberArray objectAtIndex:indexPath.row];
    self.itemName = [self.titleArray objectAtIndex:indexPath.row];
    [self displayData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
