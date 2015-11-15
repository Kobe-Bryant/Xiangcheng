//
//  WRYInfoViewController.h
//  BoandaProject
//
//  Created by BOBO on 14-1-3.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WRYInfoViewController : BaseViewController

@property (nonatomic,strong) NSString *wrybh;
@property (nonatomic,strong) NSString *wrymc;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
