//
//  MyFileViewController.m
//  Demo
//
//  Created by Alex Jean on 13-8-19.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "MyFileViewController.h"
#import "FolderViewController.h"
#import "DetailViewController.h"

@interface MyFileViewController ()

@end

@implementation MyFileViewController

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

    FolderViewController *masterController = [[FolderViewController alloc] initWithNibName:@"FolderViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:masterController];
    
    DetailViewController *detailController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:detailController];
    
    self.showsMasterInPortrait = YES;
    self.masterViewController = navController;
    self.detailViewController = navController1;
    
    detailController.mgSplitViewController = self;
    detailController.folderViewController = masterController;
    masterController.detailViewController = detailController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
