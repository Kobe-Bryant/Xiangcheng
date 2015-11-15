//
//  WryOnlineMonitorConroller.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 污染源在线监测排放数据

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "S7GraphView.h"
#import "BaseViewController.h"
#import "CommenWordsViewController.h"
#import "PopupDateViewController.h"
#import "ChooseTimeRangeVC.h"

@interface WryOnlineMonitorConroller : BaseViewController
<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,S7GraphViewDataSource,WebDataParserDelegate,ChooseTimeRangeDelegate>

@property (nonatomic,strong) UITableView *dataTableView;
@property (nonatomic,strong) UIWebView *resultWebView;
@property (nonatomic,strong) UIPopoverController *poverController;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,copy) NSString *wrymc;
@property (nonatomic,strong) S7GraphView *graphView;
@property (nonatomic,strong) NSMutableArray *valueAry;
@property (nonatomic,strong) NSMutableArray *timeAry;
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) NSDictionary *valueDic;
@property (nonatomic,strong) NSArray *pkArray;
@property (nonatomic,strong) NSArray *resultDataAry;
@property (nonatomic,strong) NSMutableString *html;
@property (nonatomic,strong) UISegmentedControl *segmented;
@property (nonatomic,strong) UILabel *graphTitle;
@property (nonatomic,copy) NSString *dataType;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,copy) NSString *enterpriseCode;
@property (nonatomic,copy) NSString *monitorSiteCode;
@property (nonatomic,copy) NSString *pollutionFactorCode;
@property (nonatomic,copy) NSString *method;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *scType;
@property (nonatomic,copy) NSString *cantonCode;
@property (nonatomic,strong) NSDate *beforeTime;
@property (nonatomic,strong) NSDate *selectTime;
@property (nonatomic,copy) NSString *beforeSave;
@property (nonatomic,copy) NSString *selectSave;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,strong) WebDataParserHelper *dataParserHelper;

@property (nonatomic,strong) WebServiceHelper *serviceHelper;

@end
