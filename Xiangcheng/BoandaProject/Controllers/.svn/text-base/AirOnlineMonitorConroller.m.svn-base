//
//  AirOnlineMonitorConroller.m
//  BoandaProject
//
//  Created by PowerData on 14-3-25.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "AirOnlineMonitorConroller.h"
#import "WebDataParserHelper.h"
#import "WebServiceHelper.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "JSONKit.h"
#import "ChooseTimeRangeVC.h"

@interface AirOnlineMonitorConroller ()<ChooseTimeRangeDelegate>
@property (nonatomic,strong) WebServiceHelper *serviceHelper;
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (nonatomic,strong) UILabel *graphTitle;
@property (nonatomic,strong) NSDate *beforeTime;
@property (nonatomic,copy) NSDate *selectTime;
@property (nonatomic,copy) NSString *showKey;
@property (nonatomic,copy) NSString *showName;
@property (nonatomic,copy) NSString *dataType;
@end

@implementation AirOnlineMonitorConroller
@synthesize dataTableView,dataArray,resultDataAry;
@synthesize graphView,unit;
@synthesize resultWebView;
@synthesize html,valueAry,timeAry;

#pragma mark - Private methods

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

- (void)dateTextFieldTouchDown:(UIBarButtonItem *)sender {
    if (self.poverController) {
        [self.poverController dismissPopoverAnimated:YES];
    }
    [self.poverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)segmentedPress:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.dataType = @"Hour";
            break;
        case 1:
            self.dataType = @"Day";
            break;
    }
    [self requestData];
}

-(void)displayData{
    
    if ([valueAry count] > 0)
        [self.valueAry removeAllObjects];
    if ([timeAry count] > 0)
        [self.timeAry removeAllObjects];
    
    for (int i = [resultDataAry count]-1 ; i>=0 ; i--) {
        NSDictionary *tmpDic = [resultDataAry objectAtIndex:i];
        NSString *time = [tmpDic objectForKey:@"MonitorDate"];
        NSString *count = @"";
        if ([self.showKey isEqualToString:@"AQI"]) {
            count = [tmpDic objectForKey:self.showKey];
        }
        else{
            NSString *value = [tmpDic objectForKey:self.showKey];
            if ([value isEqual:[NSNull null]]) {
                count = [NSString stringWithFormat:@"%d",0];
            }
            else if ([self.showKey isEqualToString:@"CO"]){
                double valueDou = [value doubleValue];
                count = [NSString stringWithFormat:@"%.3f",valueDou];
            }
            else{
                double valueDou = [value doubleValue];
                count = [NSString stringWithFormat:@"%.1f",valueDou*1000];
            }
        }
        
        NSString *timeStr = [time substringWithRange:NSMakeRange(6, 13)];
        double timeDou = [timeStr doubleValue]/1000;
        NSDateFormatter *matter = [[NSDateFormatter alloc]init];
        if (self.segment.selectedSegmentIndex == 1) {
            [matter setDateFormat:@"yyyy-MM-dd"];
        }
        else{
            [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeDou];
        time = [matter stringFromDate:date];
        [valueAry addObject:count];
        [timeAry addObject:time];
        
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
    if (self.valueAry.count <= 1) {
        self.graphTitle.text = @"";
        self.resultDataAry = nil;
        [self.valueAry removeAllObjects];
        [self.timeAry removeAllObjects];
    }
    else{
        self.graphTitle.text = [NSString stringWithFormat:@"%@%@至%@监测数据",self.title,self.beforeSave,self.selectSave];
    }
    self.graphView.info = unit;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    NSString *width = nil;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
        width = @"672px";
    else
        width = @"452px";
    
    self.html = [NSMutableString string];
    [self.html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th></tr>",width,self.showName,width];
    
    BOOL boolColor = true;
    for (int i= self.resultDataAry.count-1; i>=0; i--) {
        [self.html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
        boolColor = !boolColor;
        [self.html appendFormat:@"<td align=center>%@</td><td align=center>%@</td>",[self.timeAry objectAtIndex:i],[NSString stringWithFormat:@"%@%@",[self.valueAry objectAtIndex:i],unit]];
        [self.html appendString:@"</tr>"];
    }
    
    [self.html appendString:@"</table></body></html>"];
    
    [self.graphView reloadData];
    [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
    [self.resultWebView loadHTMLString:html baseURL:nil];
    [self addView:self.resultWebView type:@"pageCurl" subType:kCATransitionFromRight];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.serviceHelper) {
        [self.serviceHelper cancel];
    }
    [self.poverController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *timeBar = [[UIBarButtonItem alloc]initWithTitle:@"选择日期" style:UIBarButtonItemStyleBordered target:self action:@selector(dateTextFieldTouchDown:)];

    self.navigationItem.rightBarButtonItem = timeBar;
    
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@" 小时数据 ",@" 日数据 "]];
    self.segment.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segment addTarget:self action:@selector(segmentedPress:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segment;
    
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 503, 289, 421) style:UITableViewStyleGrouped];
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    [self.view addSubview:dataTableView];
    
    self.resultWebView = [[UIWebView alloc] initWithFrame:CGRectMake(305, 504, 452, 421)];
    [self.view addSubview:resultWebView];
    
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
    
    [self.view addSubview:graphView];
    
    self.dataType = @"Hour";
    self.unit = @"";
    self.selectTime = [NSDate date];
    self.beforeTime = [NSDate dateWithTimeInterval:-60*60*24*15 sinceDate:self.selectTime];
    
    ChooseTimeRangeVC *chooseTimeRange = [[ChooseTimeRangeVC alloc]initWithStartDate:self.beforeTime andEndDtate:self.selectTime andDatePickerMode:UIDatePickerModeDateAndTime];
    chooseTimeRange.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chooseTimeRange];
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:nav];
    
    self.resultDataAry = [[NSMutableArray alloc]init];
    
    self.keyArray = [NSMutableArray arrayWithObjects: @"AQI",@"SO2", @"TSP", @"PM10", @"PM2D5", @"NOx", @"NO2", @"CO", @"O3", @"Pb", @"BP", @"Fx",@"CO2", @"OXO" , nil];
    self.dataArray = [NSMutableArray arrayWithObjects:@"AQI", @"二氧化硫浓度", @"总悬浮颗粒物浓度", @"可吸入颗粒物", @"PM2.5浓度", @"氮氧化物浓度", @"二氧化氮浓度", @"一氧化碳浓度",@"臭氧浓度", @"铅浓度", @"苯并比浓度", @"氟化物浓度", @"二氧化碳浓度", @"含氧量", nil];
    [self.dataTableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.dataTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    self.valueAry = [NSMutableArray array];
    self.timeAry = [NSMutableArray array];
    
    self.showKey = [self.keyArray objectAtIndex:indexPath.row];
    self.showName = [self.dataArray objectAtIndex:indexPath.row];
    
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

-(void)requestData{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%d",50] forKey:@"PageSize"];
    [params setObject:@"1" forKey:@"PageNow"];
    [params setObject:self.dataType forKey:@"DataType"];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *selectTime = [matter stringFromDate:self.selectTime] ;
    NSString *beforeTime = [matter stringFromDate:self.beforeTime];
    [params setObject:[beforeTime stringByReplacingOccurrencesOfString:@" " withString:@"T"] forKey:@"DateTimeFrom"];
    [params setObject:[selectTime stringByReplacingOccurrencesOfString:@" " withString:@"T"] forKey:@"DateTimeTo"];
    [params setObject:@"Real" forKey:@"DataFreshStatus"];
    
    NSString *paramsStr = [WebServiceHelper createParametersWithParams:params];
    if (self.serviceHelper.bConnected) {
        [self.serviceHelper cancel];
    }
    self.serviceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://222.92.101.82:8080/XC_Service_Air/main.asmx" method:@"AirDataStation_PageSearch" nameSpace:@"http://tempuri.org/" parameters:paramsStr delegate:self];
    [self.serviceHelper runAndShowWaitingView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)processWebData:(NSData *)webData{
    if ([webData length]<=0) {
        [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
    }
    WebDataParserHelper *parserHelper = [[WebDataParserHelper alloc]initWithFieldName:@"AirDataStation_PageSearchResult" andWithJSONDelegate:self];
    [parserHelper parseXMLData:webData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
}

-(void)parseJSONString:(NSString *)jsonStr{
    [self.resultDataAry removeAllObjects];
    NSDictionary *jsonDic = [jsonStr objectFromJSONString];
    if (jsonDic &&jsonDic.count) {
        NSDictionary *dataDic = [jsonDic objectForKey:@"Data"];
        if (![dataDic isEqual:[NSNull null]]) {
            NSArray *array = [dataDic objectForKey:@"EntityList"];
            for (NSDictionary *dic in array) {
                if ([[dic objectForKey:@"SiteName"] isEqualToString:self.title]) {
                    [self.resultDataAry addObject:dic];
                }
            }
        }
    }
    [self displayData];
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
	if (valueAry == nil || 0 == [valueAry count]) {
		return 0;//还未取到数据
	}
	return 1;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
    
	
	int xCount = [timeAry count];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:xCount];
	for ( int i = 0 ; i < xCount ; i ++ ) {
		NSString *str =[timeAry objectAtIndex:i];
        if ([self.dataType isEqualToString:@"Day"]) {
            [array addObject:[str substringToIndex:10]];
        }
		else{
            [array addObject:[str substringFromIndex:11]];
        }
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
    
	NSMutableArray* ary = [[NSMutableArray alloc] initWithCapacity:10];
	for (NSString *value in valueAry) {
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
    return self.dataArray.count;  
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"因子名称";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"];
    
    
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    NSString *name = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.showKey = [self.keyArray objectAtIndex:indexPath.row];
    self.showName = [self.dataArray objectAtIndex:indexPath.row];
    [self displayData];
}
@end
