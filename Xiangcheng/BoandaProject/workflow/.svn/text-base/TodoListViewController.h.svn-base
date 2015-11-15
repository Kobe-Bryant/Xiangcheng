//
//  TodoListViewController.h
//  TaskTransfer
//
//  Created by zhang on 12-11-14.
//  Copyright (c) 2012年 zhang. All rights reserved.

//  待办任务列表
/*  服务名称：QUERY_TODO_TASK_LIST
    请求参数：
        userid   用户id     		查询该用户的待办任务
        type     流程类型编号列表	过滤流程类型，格式如：'9390293999209302'  或      '9390293999209302','9390293999209303'
        dwmc	 任务名称			通过任务名称进行过滤
        kssj	 任务开始时间	    过滤任务开始时间大于改该时间的任务
        jssj	 任务结束时间	    过滤任务结束时间小于改该间的任务
 
 */
//流程类型编号
#define kLCLXBH_LW @"43000000002"
#define kLCLXBH_FW @"44030300004"
#define kLCLXBH_DBRW @"44030300001"
#define kLCLXBH_WBFW @"44030300008"
#define kLCLXBH_WNWZ @"44170000001"

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"
#import "BaseViewController.h"

@interface TodoListViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,PopupDateDelegate,
UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *titleLbl;
@property (nonatomic,strong) IBOutlet UILabel *typeLbl;
@property (nonatomic,strong) IBOutlet UILabel *startDateLbl;
@property (nonatomic,strong) IBOutlet UILabel *endDateLbl;
@property (nonatomic,strong) IBOutlet UITextField *titleField;
@property (nonatomic,strong) IBOutlet UITextField *typeField;
@property (nonatomic,strong) IBOutlet UITextField *startDateField;
@property (nonatomic,strong) IBOutlet UITextField *endDateField;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;

@property (nonatomic,strong) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSString *typeStr; //传入流程类型，如果希望菜单分开的话
@property(nonatomic,assign)NSNumber *index;
@property (nonatomic,strong) NSMutableArray *aryItems;

- (IBAction)searchBtnPressed:(id)sender;

-(void)getFirstListData;

@end
