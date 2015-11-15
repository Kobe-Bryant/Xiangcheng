//
//  FaWenBanliController.h
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

#import "TaskActionBaseViewController.h"
#import "ToDoActionsDataModel.h"

@interface FaWenBanliController : TaskActionBaseViewController<NSURLConnHelperDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSDictionary *itemParams;
@property (nonatomic,strong) NSMutableDictionary *infoDic; //发文信息
@property (nonatomic,strong) NSArray *toDisplayKey;//发文信息所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property(nonatomic,strong) NSMutableArray *toDisplayHeightAry;

@property (nonatomic,strong) NSArray *stepAry;      //发文步骤
@property (nonatomic,strong) NSArray *stepHeightAry;      //步骤的高度
@property (nonatomic,strong) NSArray *attachmentAry; //发文附件
@property (nonatomic,strong) NSArray *gwInfoAry; //正式公文信息


@property (nonatomic,assign) BOOL isHandle; 
@property (nonatomic,strong) IBOutlet UITableView *resTableView;

@property(nonatomic,strong)NSURLConnHelper *webHelper;
@property(nonatomic,strong)ToDoActionsDataModel *actionsModel;
- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi;
@end
