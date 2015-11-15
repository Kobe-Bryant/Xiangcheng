//
//  NoticeDetailsViewController.h
//  GuangXiOA
//
//  Created by sz apple on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
@interface NoticeDetailsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnHelperDelegate,UIWebViewDelegate>

@property (nonatomic,strong) NSDictionary *baseInfoDic;
@property (nonatomic,strong) NSArray *attachmentInfoAry;
@property (nonatomic,strong) NSArray *baseKeyAry;
@property (nonatomic,strong) NSArray *baseTitleAry;
@property (nonatomic,strong) NSString *tzbh;
@property (nonatomic,strong) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) IBOutlet UIWebView *myWebView;
@property (nonatomic,assign) BOOL showTingData;

@end
