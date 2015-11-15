//
//  FaWenChaXunController.h
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FaWenChaXunController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic,strong) NSArray *itemAry;
@property (nonatomic,strong) NSArray *typeAry;

@end
