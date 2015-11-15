//
//  NoticeTaskDetailVC.h
//  BoandaProject
//
//  Created by 张仁松 on 13-8-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
// 待办任务里面的通知公告详细信息

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "TaskActionBaseViewController.h"
@interface NoticeTaskDetailVC : TaskActionBaseViewController<NSURLConnHelperDelegate>
@property(nonatomic,copy)NSDictionary *itemParams;

@property (nonatomic,assign) BOOL isHandle;

- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi;
@end
