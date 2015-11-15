//
//  BaseLawsListViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "HBSCHelper.h"

@interface BaseLawsListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{

}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *aryItems;

@property (nonatomic, strong) NSString *viewTitle;


- (void) searchByFIDH:(id)strFIDH root:(id)rootMl;

@end