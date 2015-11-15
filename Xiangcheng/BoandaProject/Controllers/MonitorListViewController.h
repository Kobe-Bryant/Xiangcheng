//
//  MonitorListViewController.h
//  BoandaProject
//
//  Created by PowerData on 14-3-27.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MonitorListViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,copy) NSString *isType;

@end
