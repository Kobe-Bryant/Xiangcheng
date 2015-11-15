//
//  AirOnlineMonitorConroller.h
//  BoandaProject
//
//  Created by PowerData on 14-3-25.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "S7GraphView.h"

@interface AirOnlineMonitorConroller : BaseViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,S7GraphViewDataSource>

@property (nonatomic,retain) UITableView *dataTableView;
@property (nonatomic,retain) UIWebView *resultWebView;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,strong) S7GraphView *graphView;
@property (nonatomic,strong) NSMutableArray *valueAry;
@property (nonatomic,strong) NSMutableArray *timeAry;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *keyArray;
@property (nonatomic,strong) NSMutableArray *resultDataAry;
@property (nonatomic,strong) NSMutableString *html;
@property (nonatomic,copy) NSString *beforeSave;
@property (nonatomic,copy) NSString *selectSave;

@end
