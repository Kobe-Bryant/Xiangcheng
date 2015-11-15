//
//  TaskActionBaseViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-8-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "TaskActionBaseViewController.h"

@interface TaskActionBaseViewController ()

@end

@implementation TaskActionBaseViewController

@synthesize bOKFromTransfer;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.bOKFromTransfer) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [super viewDidAppear:animated];
}

-(void)HandleGWResult:(BOOL)eOK{
    
    bOKFromTransfer = eOK;
    
}


@end
