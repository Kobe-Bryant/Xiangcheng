//
//  BanLiDetailController.h
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
// 来文办理

#import <UIKit/UIKit.h>

#import "NSURLConnHelper.h"
#import "ToDoActionsDataModel.h"
#import "TaskActionBaseViewController.h"
@interface BanLiDetailController : TaskActionBaseViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,UIWebViewDelegate>

@property (nonatomic,copy) NSDictionary *itemParams;
@property (nonatomic,strong) NSMutableDictionary *infoDic; //来文信息
@property (nonatomic,strong) NSArray *toDisplayKey;//来文信息所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property (nonatomic,strong) NSMutableArray *toDisplayHeightAry;

@property (nonatomic,strong) NSArray *stepAry;      //来文步骤
@property (nonatomic,strong) NSArray *stepHeightAry;      //来文步骤的高度

@property (nonatomic,strong) NSArray *attachmentAry; //来文附件

//@property (nonatomic,strong) NSArray *selInfoAry; //领导快捷键信息
@property (nonatomic,assign) BOOL isHandle; 

@property (nonatomic,strong) IBOutlet UITableView *resTableView;
@property (nonatomic,strong) ToDoActionsDataModel *actionsModel;
@property (nonatomic,strong) NSURLConnHelper *webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi;
@end
