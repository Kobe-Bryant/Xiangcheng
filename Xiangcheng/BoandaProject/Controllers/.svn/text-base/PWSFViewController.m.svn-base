//
//  PWSFViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-3.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "PWSFViewController.h"
#import "ServiceUrlString.h"

@interface PWSFViewController ()
@property (nonatomic,strong) UISegmentedControl *segCtrl;
@property (nonatomic,strong)IBOutlet UIWebView *myWebView;
@property (nonatomic,strong)IBOutlet UITextField *qsrqFie;
@property (nonatomic,strong)IBOutlet UITextField *jzrqFie;
@property (nonatomic,strong)IBOutlet UIButton *searchBtn;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,assign) int currentTag;

- (IBAction)searchBtnPressed:(id)sender;
@end

@implementation PWSFViewController

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
    
    self.segCtrl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@" 发票汇总清单 ",@" 缴费情况查询 " ,nil]];
    self.segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segCtrl addTarget:self action:@selector(segctrlClicked:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segCtrl;
    self.segCtrl.selectedSegmentIndex = 0;
    
    [self.qsrqFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.jzrqFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	self.dateController.delegate = self;
	
	UINavigationController *navDate = [[UINavigationController alloc] initWithRootViewController:self.dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navDate];
	self.popController = popover;
    
    
    [self requestData];

}
-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.segCtrl.selectedSegmentIndex == 0)
    {
        [params setObject:@"QUERY_PWSF_FPHZQD" forKey:@"service"];
    }
    if (self.segCtrl.selectedSegmentIndex == 1)
    {
        [params setObject:@"QUERY_PWSF_JFQKCX" forKey:@"service"];
    }
    
    [params setObject:self.qsrqFie.text forKey:@"KSSJ"];
    [params setObject:self.jzrqFie.text forKey:@"JSSJ"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^^^^^%@",strUrl);
    NSURL *url = [[NSURL alloc]initWithString:strUrl];
    
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}
-(void)segctrlClicked:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    self.segCtrl.selectedSegmentIndex = seg.selectedSegmentIndex;

    [self requestData];
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
- (void)touchFromDate:(id)sender
{
    UITextField *tfd =(UITextField*)sender;
    self.currentTag = tfd.tag;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (self.currentTag == 1)
    {
        self.qsrqFie.text = @"";
    }
    if (self.currentTag == 2)
    {
        self.jzrqFie.text = @"";
    }
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Choose Date delegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
        
        if (self.currentTag == 1)
        {
            self.qsrqFie.text = dateString;
        }
        if (self.currentTag == 2)
        {
            self.jzrqFie.text = dateString;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
