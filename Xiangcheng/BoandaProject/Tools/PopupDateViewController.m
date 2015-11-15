    //
//  PopupDateViewController.m
//  EPad
//
//  Created by chen on 11-4-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PopupDateViewController.h"     

@implementation PopupDateViewController
@synthesize delegate,myPicker,datePickerMode;


-(id)initWithPickerMode:(UIDatePickerMode) mode{
	if((self = [super init])){
		datePickerMode = mode;
	}
	return self;
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
-(IBAction)saveDate:(id)sender{
	[delegate PopupDateController:self Saved:YES selectedDate:myPicker.date];
}

-(IBAction)cancelDate:(id)sender{
	[delegate PopupDateController:self Saved:NO selectedDate:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
    
	self.contentSizeForViewInPopover = CGSizeMake(248, 172);
	UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 248, 162)];
	picker.datePickerMode = datePickerMode;
	[self.view addSubview:picker];
	self.myPicker = picker;
	
    
	UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
									style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDate:)];
    
    self.navigationItem.leftBarButtonItem = aButtonItem;

	UIBarButtonItem *aButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered 
																	target:self action:@selector(saveDate:)];
    
    self.navigationItem.rightBarButtonItem = aButtonItem2;
    

}

-(void)viewWillAppear:(BOOL)animated{
    if (self.date == nil) {
        myPicker.date = [NSDate date];
    }
    else{
        myPicker.date = self.date;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}




@end
