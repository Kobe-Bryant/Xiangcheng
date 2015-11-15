//
//  LockSystemVC.m
//  GuoToOA
//
//  Created by 张仁松 on 13-6-27.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "LockSystemVC.h"

@interface LockSystemVC ()

@end

@implementation LockSystemVC

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
    [self.view setBackgroundColor:[UIColor blackColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 768, 80)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"系统已被锁定，拒绝使用!";
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
