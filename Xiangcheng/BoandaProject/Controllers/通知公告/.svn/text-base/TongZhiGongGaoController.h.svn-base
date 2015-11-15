//
//  TongZhiGongGaoController.h
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "BaseViewController.h"

@interface TongZhiGongGaoController : BaseViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,NSURLConnHelperDelegate>
{

}

@property (nonatomic,strong) NSMutableArray *itemAry;
@property (nonatomic,strong) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSString *tzgglx;//通知公告类型
@property (nonatomic,unsafe_unretained) NSInteger pageCount;
@property (nonatomic,unsafe_unretained) NSInteger currentPage;
@property (nonatomic,unsafe_unretained) BOOL isLoading;
@property (nonatomic,strong) NSMutableSet *readedSet;

@end
