//
//  AddressBookViewController.h
//  BoandaProject
//
//  Created by Alex Jean on 13-7-8.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersHelper.h"
#import "MBProgressHUD.h"
#import "DataSyncManager.h"

@interface AddressBookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    
    UISearchDisplayController *mySearchController;
    UITableView *deptTableView;
    NSMutableArray *deptDataArray;
    UITableView *detailTableView;
    NSMutableArray *detailDataArray;
    NSMutableArray *searchResultArray;
    UsersHelper *usersHelper;
    NSString *parentButtonTitle;
    UIButton *parentButton;
    UILabel *titleLabel;
    int businessTag;
    MBProgressHUD *refreshHUD;
    
    int index;//标示推进几层
}

@property (nonatomic, strong) DataSyncManager *syncManager;

@end
