//
//  LawsViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LawsListViewController.h"

@interface LawsListViewController ()

@end

@implementation LawsListViewController

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
    
    self.title = @"法律法规";
    [self searchByFIDH:@"f9162afa-2ea2-4521-9525-b74ef16806f7" root:@"法律法规"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
