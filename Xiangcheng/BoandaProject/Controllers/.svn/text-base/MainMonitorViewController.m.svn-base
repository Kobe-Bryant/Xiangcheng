//
//  MainMonitorViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-4-9.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "MainMonitorViewController.h"
#import "MonitorListViewController.h"
#import "AirOnlineMonitorConroller.h"
#import "SystemConfigContext.h"
#import "MenuControl.h"
#import "MainSiteViewController.h"

@interface MainMonitorViewController ()

@end

@implementation MainMonitorViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBg.png"]];
    bgImgView.frame = CGRectMake(0, 0, 768, 1004);
    [self.view addSubview:bgImgView];
    
    NSDictionary *pageInfo = [[SystemConfigContext sharedInstance] getNextItems];
    self.title = [pageInfo objectForKey:@"PageTitle"];
    NSArray *menuItems = [pageInfo objectForKey:@"Menus"];
    int w = 120, h =130;
    int n = 4;
    int span = (768 - n * w) / (n + 1);
    int count = [menuItems count];
    for (int i = 0; i < count; i++) {
        NSDictionary *menuItem = [menuItems objectAtIndex:i];
        MenuControl *control = [[MenuControl alloc] initWithFrame:
                                CGRectMake(span + (span + w) * (i % n),
                                           span + (span + h) * (i / n)+50, w, h) andMenuInfo:menuItem];
        [control addTarget:self action:@selector(toggleMenuControl:) forControlEvents:UIControlEventTouchUpInside];
        control.tag = i;
        [self.view addSubview:control];
    }
}

-(void)toggleMenuControl:(MenuControl *)ctrl{
    NSDictionary *menuItemInfo = ctrl.menuInfo;
    NSString *classStr = [menuItemInfo objectForKey:@"ViewController"];
    if([classStr length] > 0){
        NSString *nibName = [menuItemInfo objectForKey:@"NibName"];
        NSString *menuType = [menuItemInfo objectForKey:@"MenuType"];
        NSString *title = [menuItemInfo objectForKey:@"MenuTitle"];
        UIViewController *controller = nil;
        if([nibName length] > 0){
            controller = (UIViewController*)[[NSClassFromString(classStr) alloc] initWithNibName:nibName bundle:nil];
        }else{
            controller = (UIViewController*)[[NSClassFromString(classStr) alloc] init];
        }
        if(controller){
            controller.title = title;
            if ([classStr isEqualToString:@"MainSiteViewController"]) {
              MainSiteViewController *siteVC = (MainSiteViewController *)controller;
                siteVC.isType = menuType;
                [self.navigationController pushViewController:siteVC animated:YES];
            }
            else if ([classStr isEqualToString:@"MonitorListViewController"]){
                MonitorListViewController *listVC = (MonitorListViewController *)controller;
                listVC.isType = menuType;
                [self.navigationController pushViewController:listVC animated:YES];
            }
            else{
                [self.navigationController pushViewController:controller    animated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
