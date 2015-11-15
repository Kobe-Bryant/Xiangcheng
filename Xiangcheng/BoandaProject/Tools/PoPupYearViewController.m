//
//  PoPupYearViewController.m
//  GuangXiOA
//
//  Created by apple on 13-1-10.
//
//

#import "PoPupYearViewController.h"

@interface PoPupYearViewController ()

- (void)initDataDefault;
- (NSInteger)currentYear;
- (void)loadSubViews;
- (void)addBarItems;
- (void)saveButtonClick:(id)sender;
- (void)cancelButtonClick:(id)sender;
@end

@implementation PoPupYearViewController
@synthesize yearString,yearArray;

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
    [self initDataDefault];
	[self loadSubViews];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- self私有
- (void)initDataDefault{ 
    self.yearArray = [[NSMutableArray alloc] init];
    for (int i=0; i<20; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d年",[self currentYear]-i]];
    }
}
- (NSInteger)currentYear {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps year];
}
- (void)loadSubViews{
    
    self.contentSizeForViewInPopover = CGSizeMake(180, 140);
	_pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 170, 134)];
    [self.view addSubview:_pickView];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.showsSelectionIndicator = YES;
    [_pickView selectRow:1 inComponent:0 animated:NO];
    
    [self addBarItems];
}
- (void)addBarItems{
   /* UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                    style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClick:)];
    
    self.navigationItem.leftBarButtonItem = aButtonItem;
	[aButtonItem release];*/
	UIBarButtonItem *aButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered
																	target:self action:@selector(saveButtonClick:)];
    
    self.navigationItem.rightBarButtonItem = aButtonItem2;


}
- (void)saveButtonClick:(id)sender{
    int row = [_pickView selectedRowInComponent:0];
    self.yearString = [yearArray objectAtIndex:row];
    [_delegate PopupYearController:self Saved:YES selectedString:yearString];
}
- (void)cancelButtonClick:(id)sender{
    [_delegate PopupYearController:self Saved:NO selectedString:@""];
}

#pragma mark- UIPickView代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return yearArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [yearArray objectAtIndex:row];
}


@end
