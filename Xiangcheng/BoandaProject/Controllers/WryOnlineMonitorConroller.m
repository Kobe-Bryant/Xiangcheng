//
//  WryOnlineMonitorConroller.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WryOnlineMonitorConroller.h"
#import "JSONKit.h"

#define kRequestZhiBiao 1 //指标
#define kRequestPfData  2 //排放数据

@implementation WryOnlineMonitorConroller

@synthesize dataTableView,dataArray,resultDataAry,itemName;
@synthesize graphView,unit;
@synthesize wrymc,resultWebView;
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

-(void)requestData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%d",50] forKey:@"PageSize"];
    [params setObject:@"1" forKey:@"PageNow"];
    [params setObject:self.monitorSiteCode forKey:@"MonitorSiteCode"];
    [params setObject:self.enterpriseCode forKey:@"EnterpriseCode"];
    [params setObject:self.pollutionFactorCode forKey:@"PollutionFactorCode"];
    [params setObject:self.scType forKey:@"SCType"];
    [params setObject:self.dataType forKey:@"MonitorDataType"];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *selectTime = [matter stringFromDate:self.selectTime] ;
    NSString *beforeTime = [matter stringFromDate:self.beforeTime];
    [params setObject:[beforeTime stringByReplacingOccurrencesOfString:@" " withString:@"T"] forKey:@"DateTimeFrom"];
    [params setObject:[selectTime stringByReplacingOccurrencesOfString:@" " withString:@"T"] forKey:@"DateTimeTo"];
    [params setObject:@"1" forKey:@"ThanValue"];
    [params setObject:@"1000" forKey:@"LessValue"];
    
    NSString *paramsStr = [WebServiceHelper createParametersWithParams:params];
    if (self.serviceHelper.bConnected) {
        [self.serviceHelper cancel];
    }
    self.serviceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://222.92.101.82:8080/XC_Service_AutoMonitor/main.asmx" method:self.method nameSpace:@"http://tempuri.org/" parameters:paramsStr delegate:self];
    [self.serviceHelper runAndShowWaitingView:self.view];
}

-(void)processWebData:(NSData *)webData{
    if ([webData length] <= 0) {
        [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
    }
    self.dataParserHelper = [[WebDataParserHelper alloc]initWithFieldName:self.result andWithJSONDelegate:self];
    [self.dataParserHelper parseXMLData:webData];
}

-(void)parseJSONString:(NSString *)jsonStr{
    self.resultDataAry = nil;
    NSDictionary *dataDic = [jsonStr objectFromJSONString];
    NSDictionary *dic = [dataDic objectForKey:@"Data"];
    if (![dic isEqual:[NSNull null]]) {
        NSArray *array = [dic objectForKey:@"EntityList"];
        if (array && array.count) {
            self.resultDataAry = [NSArray arrayWithArray:array];
            
        }
    }
    if (!self.resultDataAry.count) {
        self.graphTitle.text = @"";
    }
    [self displayData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
}

-(void)displayData{
    
    if ([self.valueAry count] > 0)
        [self.valueAry removeAllObjects];
    if ([self.timeAry count] > 0)
        [self.timeAry removeAllObjects];
    
    for (int i=[self.resultDataAry count]-1; i>=0; i--) {
        NSDictionary *tmpDic = [self.resultDataAry objectAtIndex:i];
        NSString *time = [tmpDic objectForKey:@"MonitorDateTime"];
        NSString *count = [tmpDic objectForKey:@"MonitorValue"];
        NSString *value = [NSString stringWithFormat:@"%.2f",[count floatValue]];
        NSString *timeStr = [time substringWithRange:NSMakeRange(6, 13)];
        double timeDou = [timeStr doubleValue]/1000;
        NSDateFormatter *matter = [[NSDateFormatter alloc]init];
        [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeDou];
        time = [matter stringFromDate:date];
        [self.valueAry addObject:value];
        [self.timeAry addObject:time];
        self.unit = [tmpDic objectForKey:@"UnitName"];
        
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
    }else{
        self.graphTitle.text = [NSString stringWithFormat:@"%@%@至%@监测数据",self.title,self.beforeSave,self.selectSave];
    }

    if([unit isEqual:[NSNull null]] || unit == nil)
    {
        self.graphView.info = @"";
    }
    else
    {
        self.graphView.info = unit;
    }
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    NSString *width = nil;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
        width = @"672px";
    else
        width = @"452px";
    
    self.html = [NSMutableString string];
    [self.html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th></tr>",width,itemName,width];
    
    BOOL boolColor = true;
    for (int i=[self.resultDataAry count]-1; i>=0; i--) {
        [self.html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
        boolColor = !boolColor;
        [self.html appendFormat:@"<td align=center>%@</td><td align=center>%@</td>",[self.timeAry objectAtIndex:i],[NSString stringWithFormat:@"%@%@",[self.valueAry objectAtIndex:i],self.unit]];
        [self.html appendString:@"</tr>"];
    }
    
    [self.html appendString:@"</table></body></html>"];
    
    [self.graphView reloadData];
    
    [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
    [self.resultWebView loadHTMLString:self.self.html baseURL:nil];
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

-(void)choosedFromTime:(NSDate *)fromTime andEndTime:(NSDate *)endTime{
    NSTimeInterval beforeTimeInterval = [fromTime timeIntervalSince1970];
    NSTimeInterval selectTimeInterval = [endTime timeIntervalSince1970];
    if (beforeTimeInterval >= selectTimeInterval) {
        [self showAlertMessage:@"截止时间不能早于开始时间"];
    }
    else{
        self.beforeTime = fromTime;
        self.selectTime = endTime;
        [self requestData];
    }
    [self.poverController dismissPopoverAnimated:YES];
}

- (void)dateTextFieldTouchDown:(UIBarButtonItem *)sender {
    if (self.poverController) {
        [self.poverController dismissPopoverAnimated:YES];
    }
    [self.poverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)cancelSelectTimeRange{
    [self.poverController dismissPopoverAnimated:YES];
}

-(void)segmentedValueChanged:(UISegmentedControl *)segmented{
    switch (self.segmented.selectedSegmentIndex) {
        case 0:
            self.dataType = @"Real";
            break;
        case 1:
            self.dataType = @"TenMin";
            break;
        case 2:
            self.dataType = @"Hour";
            break;
        default:
            self.dataType = @"day";
            break;
    }
    [self requestData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *timeBar = [[UIBarButtonItem alloc]initWithTitle:@"选择日期" style:UIBarButtonItemStyleBordered target:self action:@selector(dateTextFieldTouchDown:)];
    self.navigationItem.rightBarButtonItem = timeBar;
    
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 508, 289, 421) style:UITableViewStyleGrouped];
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
    
    self.dataArray = [NSMutableArray array];
    self.valueAry = [NSMutableArray array];
    self.timeAry = [NSMutableArray array];
    self.nameArray = [NSMutableArray array];
    
    for (NSDictionary *dataDic in self.pkArray) {
        [self.nameArray addObject:[dataDic objectForKey:@"MonitorSiteName"]];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[dataDic objectForKey:@"MonitorFactorInfoList"]];
        if ([self.scType isEqualToString:@"Enterprise_Liquid"]|| [self.scType isEqualToString:@"Enterprise_Gas"]) {
            if (array && array.count) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
                [dic setObject:@"B01" forKey:@"PollutionFactorCode"];
                [dic setObject:@"流量" forKey:@"PollutionFactorName"];
                [array addObject:dic];
            }
            [self.dataArray addObject:array];
        }
        else if ([self.scType isEqualToString:@"Metal"]){
            NSMutableArray *nameArray = [NSMutableArray arrayWithObjects:@"COD",@"氨氮",@"总磷",@"总铜",@"总镍",@"总铬", nil];
            NSMutableArray *pxArray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                NSString *str = [dic objectForKey:@"PollutionFactorName"];
                if (![nameArray containsObject:str]) {
                    [nameArray addObject:str];
                }
            }
            for (NSString *str in nameArray) {
                for (NSDictionary *yzDic in array) {
                    NSString *yzName = [yzDic objectForKey:@"PollutionFactorName"];
                    if ([str isEqualToString:yzName]) {
                        [pxArray addObject:yzDic];
                    }
                }
            }
            [self.dataArray addObject:pxArray];
        }
        else{
            [self.dataArray addObject:array];
        }
    }
    
    self.dataType = @"Real";
    self.unit = @"";
    self.itemName = @"";
    self.selectTime = [NSDate date];
    if ([self.scType isEqualToString:@"Enterprise_Liquid"]|| [self.scType isEqualToString:@"Enterprise_Gas"]) {
        self.beforeTime = [NSDate dateWithTimeInterval:-60*60*24*3 sinceDate:self.selectTime];
    }
    else{
        self.beforeTime = [NSDate dateWithTimeInterval:-60*60*24*5 sinceDate:self.selectTime];
    }
    self.segmented = [[UISegmentedControl alloc]initWithItems:@[@"  实时数据  ",@"  十分数据  ",@"  小时数据  ",@"  日数据  "]];
    self.segmented.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmented.selectedSegmentIndex = 0;
    [self.segmented addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmented;
    
    if ([self.scType isEqualToString:@"Metal"]) {
        self.scType = @"Enterprise_Liquid";
    }
    
    [self.dataTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.dataTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    ChooseTimeRangeVC *chooseTimeRange = [[ChooseTimeRangeVC alloc]initWithStartDate:self.beforeTime andEndDtate:self.selectTime andDatePickerMode:UIDatePickerModeDateAndTime];
    chooseTimeRange.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chooseTimeRange];
    self.poverController = [[UIPopoverController alloc]initWithContentViewController:nav];
    
    NSDictionary *dataDic = [[self.dataArray objectAtIndex:0]objectAtIndex:0];
    self.itemName = [dataDic objectForKey:@"PollutionFactorName"];
    self.enterpriseCode = [dataDic objectForKey:@"EnterpriseCode"];
    self.monitorSiteCode = [dataDic objectForKey:@"MonitorSiteCode"];
    self.pollutionFactorCode = [dataDic objectForKey:@"PollutionFactorCode"];
    [self requestData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.serviceHelper) {
        [self.serviceHelper cancel];
    }
    [self.poverController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	if (self.valueAry == nil || 0 == [self.valueAry count]) {
		return 0;//还未取到数据
	}
	return 1;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
    
	
	int xCount = [self.timeAry count];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:xCount];
	for ( int i = 0 ; i < xCount ; i ++ ) {
		NSString *str =[self.timeAry objectAtIndex:i];
		[array addObject:[str substringFromIndex:5]];
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
    
	NSMutableArray* ary = [[NSMutableArray alloc] initWithCapacity:10];
	for (NSString *value in self.valueAry) {
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *array = [self.dataArray objectAtIndex:section];
    return array.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.nameArray objectAtIndex:section];
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
    NSArray *array = [self.dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [[array objectAtIndex:indexPath.row]objectForKey:@"PollutionFactorName"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.dataArray objectAtIndex:indexPath.section];
    NSDictionary *dataDic = [array objectAtIndex:indexPath.row];
    self.itemName = [dataDic objectForKey:@"PollutionFactorName"];
    self.monitorSiteCode = [dataDic objectForKey:@"MonitorSiteCode"];
    self.pollutionFactorCode = [dataDic objectForKey:@"PollutionFactorCode"];
    [self requestData];
}
@end