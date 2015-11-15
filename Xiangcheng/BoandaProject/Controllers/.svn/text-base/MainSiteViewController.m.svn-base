//
//  MainSiteViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-4-28.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "MainSiteViewController.h"
#import "SystemConfigContext.h"
#import "MenuControl.h"
#import "WebServiceHelper.h"
#import "WebDataParserHelper.h"
#import "JSONKit.h"
#import "AirOnlineMonitorConroller.h"
#import "SiteViewController.h"
#import "XFTJViewController.h"

@interface MainSiteViewController ()
@property (nonatomic,strong) WebServiceHelper *serviceHelper;
@property (nonatomic,strong) NSMutableArray *valueArray;
@end

@implementation MainSiteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.serviceHelper) {
        [self.serviceHelper cancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBg.png"]];
    bgImgView.frame = CGRectMake(0, 0, 768, 1004);
    [self.view addSubview:bgImgView];
    
    self.valueArray = [NSMutableArray array];
    
    if ([self.isType isEqualToString:@"Water"]) {
       [self requestData]; 
    }
    else if ([self.isType isEqualToString:@"Letter"]){
        NSMutableDictionary *jdDic = [NSMutableDictionary dictionary];
        [jdDic setObject:@"按街道统计" forKey:@"MenuTitle"];
        [jdDic setObject:@"mc_1_6.png" forKey:@"MenuIcon"];
        NSMutableDictionary *szDic = [NSMutableDictionary dictionary];
        [szDic setObject:@"按数据来源统计" forKey:@"MenuTitle"];
        [szDic setObject:@"mc_1_6.png" forKey:@"MenuIcon"];
        NSMutableDictionary *xzDic = [NSMutableDictionary dictionary];
        [xzDic setObject:@"按投诉性质统计" forKey:@"MenuTitle"];
        [xzDic setObject:@"mc_1_6.png" forKey:@"MenuIcon"];
        [self.valueArray addObject:jdDic];
        [self.valueArray addObject:szDic];
        [self.valueArray addObject:xzDic];
        [self displayWithArray:self.valueArray];
    }
    else{
        NSMutableDictionary *szDic = [NSMutableDictionary dictionary];
        [szDic setObject:@"苏州市" forKey:@"MenuTitle"];
        [szDic setObject:@"环境质量气站.png" forKey:@"MenuIcon"];
        NSMutableDictionary *xcDic = [NSMutableDictionary dictionary];
        [xcDic setObject:@"相城区" forKey:@"MenuTitle"];
        [xcDic setObject:@"环境质量气站.png" forKey:@"MenuIcon"];
        [self.valueArray addObject:szDic];
        [self.valueArray addObject:xcDic];
        [self displayWithArray:self.valueArray];
    }
}

-(void)toggleMenuControl:(MenuControl *)ctrl{
    NSDictionary *menuItemInfo = ctrl.menuInfo;
    if ([self.isType isEqualToString:@"Water"]) {
        SiteViewController *viewVC = [[SiteViewController alloc]init];
        viewVC.title = [menuItemInfo objectForKey:@"MenuTitle"];
        viewVC.ASCode = [menuItemInfo objectForKey:@"ASCode"];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
    else if ([self.isType isEqualToString:@"Letter"]){
        XFTJViewController *viewVC = [[XFTJViewController alloc]init];
        viewVC.title = [menuItemInfo objectForKey:@"MenuTitle"];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
    else{
        AirOnlineMonitorConroller *viewVC = [[AirOnlineMonitorConroller alloc]init];
        viewVC.title = [menuItemInfo objectForKey:@"MenuTitle"];
        [self.navigationController pushViewController:viewVC animated:YES];
    }
}

-(void)requestData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%d",ONE_PAGE_SIZE] forKey:@"PageSize"];
    [params setObject:@"1" forKey:@"PageNow"];
    
    NSString *paramsStr = [WebServiceHelper createParametersWithParams:params];
    self.serviceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://222.92.101.82:8080/XC_Service_Water/main.asmx" method:@"T_Bas_WQA_Station__PageSearch" nameSpace:@"http://tempuri.org/" parameters:paramsStr delegate:self];
    [self.serviceHelper runAndShowWaitingView:self.view];
}

-(void)processWebData:(NSData *)webData{
    if ([webData length]<=0) {
        [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
    }
    WebDataParserHelper *parserHelper = [[WebDataParserHelper alloc]initWithFieldName:@"T_Bas_WQA_Station__PageSearchResult" andWithJSONDelegate:self];
    [parserHelper parseXMLData:webData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
}

-(void)parseJSONString:(NSString *)jsonStr{
    NSDictionary *jsonDic = [jsonStr objectFromJSONString];
    if (jsonDic &&jsonDic.count) {
        NSDictionary *dataDic = [jsonDic objectForKey:@"Data"];
        if (![dataDic isEqual:[NSNull null]]) {
            NSArray *array = [dataDic objectForKey:@"EntityList"];
            for (NSDictionary *dic in array) {
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
                [dataDic setObject:[dic objectForKey:@"ASCode"] forKey:@"ASCode"];
                [dataDic setObject:[dic objectForKey:@"StationName"] forKey:@"MenuTitle"];
                [dataDic setObject:@"环境质量水站.png" forKey:@"MenuIcon"];
                [self.valueArray addObject:dataDic];
            }
        }
    }
    [self displayWithArray:self.valueArray];
}

-(void)displayWithArray:(NSArray *)array{
    int w = 120, h =130;
    int n = 4;
    int span = (768 - n * w) / (n + 1);
    int count = [array count];
    for (int i = 0; i < count; i++) {
        NSDictionary *menuItem = [array objectAtIndex:i];
        MenuControl *control = [[MenuControl alloc] initWithFrame:
                                CGRectMake(span + (span + w) * (i % n),
                                           span + (span + h) * (i / n)+50, w, h) andMenuInfo:menuItem];
        [control addTarget:self action:@selector(toggleMenuControl:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:control];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
