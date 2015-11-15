//
//  ChooseTimeRangeVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-9-27.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ChooseTimeRangeVC.h"

@interface ChooseTimeRangeVC ()

@end

@implementation ChooseTimeRangeVC
@synthesize delegate,theDP,theSP,segCtrl,segCtrlHidden;
#define CELL_HEADER_COLOR [UIColor colorWithRed:0.530f green:0.600f blue:0.738f alpha:1.000f]
#pragma mark - Private methods

- (void)makeSureTheRange:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *from = [dateFormatter stringFromDate:theSP.date];
    NSString *end = [dateFormatter stringFromDate:theDP.date];
    NSString *jclx = nil;
    int x = self.segCtrl.selectedSegmentIndex;
    if (x==0)
    {
        jclx = @"H";
    }
    else
    {
        jclx = @"D";
    }
    if (self.segCtrlHidden) {
        [delegate choosedFromTime:from andEndTime:end andType:jclx];
    }
    else{
        [delegate choosedFromTime:theSP.date andEndTime:theDP.date];
    }
}

- (void)cancelTheRange:(id)sender
{
    [delegate cancelSelectTimeRange];
}

#pragma mark - View life cycle

- (id)initWithStartDate:(NSDate *)startDate andEndDtate:(NSDate *)endDate andDatePickerMode:(UIDatePickerMode)datePickerMode
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.startDate = startDate;
        self.endDate = endDate;
        self.datePickerMode = datePickerMode;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentSizeForViewInPopover = CGSizeMake(288, 410);
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BGPortrait.png"]];
    background.frame = CGRectMake(0, 0, 288, 410);
    [self.view addSubview:background];
    
    UILabel *startMonthLbl = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 108, 21)];
    [startMonthLbl setBackgroundColor:[UIColor clearColor]];
    [startMonthLbl setTextColor:CELL_HEADER_COLOR];
    startMonthLbl.font = [UIFont boldSystemFontOfSize:20];
    startMonthLbl.textAlignment = UITextAlignmentCenter;
    startMonthLbl.text = @"开始日期";
    [self.view addSubview:startMonthLbl];
    
    UILabel *endMonthLbl = [[UILabel alloc] initWithFrame:CGRectMake(90, 205, 108, 21)];
    [endMonthLbl setBackgroundColor:[UIColor clearColor]];
    [endMonthLbl setTextColor:CELL_HEADER_COLOR];
    endMonthLbl.font = [UIFont boldSystemFontOfSize:20];
    endMonthLbl.textAlignment = UITextAlignmentCenter;
    endMonthLbl.text = @"截止日期";
    [self.view addSubview:endMonthLbl];
    

    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(20, 35, 248, 172)];
    datePicker.datePickerMode = self.datePickerMode;
    [self.view addSubview:datePicker];
    datePicker.date = self.startDate;
    self.theSP = datePicker;
    
    UIDatePicker *datePicker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(20, 230, 248, 172)];
    datePicker2.datePickerMode = self.datePickerMode;
    [self.view addSubview:datePicker2];
    datePicker2.date = self.endDate;
    self.theDP = datePicker2;
    
	//导航栏按钮设置
    UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelTheRange:)];
    self.navigationItem.leftBarButtonItem = aButtonItem;
    
	UIBarButtonItem *aButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(makeSureTheRange:)];
    
    self.segCtrl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"时均值",@"日均值", nil]];
    self.segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segCtrl.selectedSegmentIndex = 0;
    if (segCtrlHidden)
    {
        self.navigationItem.titleView = self.segCtrl;
    }
    
    self.navigationItem.rightBarButtonItem = aButtonItem2;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
