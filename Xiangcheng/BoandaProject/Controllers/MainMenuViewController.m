
//
//  MainMenuViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SystemConfigContext.h"
#import "MenuPageView.h"
#import "MenuControl.h"
#import "PDJsonkit.h"
#import "NSAppUpdateManager.h"
#import "NSExceptionSender.h"
#import "DataSyncManager.h"
#import "ServiceUrlString.h"
#import "LocationManager.h"
#import "MBProgressHUD.h"
#import "MainSiteViewController.h"
#import "MonitorListViewController.h"

@interface MainMenuViewController ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSAppUpdateManager *updater;
@property(nonatomic,strong)NSExceptionSender *exceptionSender;
@property(nonatomic,strong)DataSyncManager *syncManager;
@property(nonatomic,strong)NSMutableArray *pageViewAry;
@property(nonatomic,strong)NSURLConnHelper *webHelperYuan;
@property(nonatomic,strong)NSURLConnHelper *webHelperTing;
@property(nonatomic,strong)MBProgressHUD *HUD;
@property(nonatomic,strong)NSMutableArray *aryItems;

@end

@implementation MainMenuViewController

@synthesize scrollView,pageControl,updater,exceptionSender,dicBadgeInfo,syncManager,pageViewAry,webHelperYuan,webHelperTing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializfaation
    }
    return self;
}

-(void)toggleMenuControl:(MenuControl *)ctrl{
    NSDictionary *menuItemInfo = ctrl.menuInfo;
    NSString *classStr = [menuItemInfo objectForKey:@"ViewController"];
    if([classStr length] > 0){
        NSString *nibName = [menuItemInfo objectForKey:@"NibName"];
        NSString *menuType = [menuItemInfo objectForKey:@"MenuType"];
        NSString *title = [menuItemInfo objectForKey:@"MenuTitle"];
        UIViewController *controller = nil;
        if([nibName length] > 0){
            controller = (UIViewController*)[[NSClassFromString(classStr) alloc] initWithNibName:nibName bundle:nil];
        }else{
            controller = (UIViewController*)[[NSClassFromString(classStr) alloc] init];
        }
        if(controller){
            controller.title = title;
            if ([classStr isEqualToString:@"MainSiteViewController"]) {
                MainSiteViewController *siteVC = (MainSiteViewController *)controller;
                siteVC.isType = menuType;
                [self.navigationController pushViewController:siteVC animated:YES];
            }
            else if ([classStr isEqualToString:@"MonitorListViewController"]){
                MonitorListViewController *listVC = (MonitorListViewController *)controller;
                listVC.isType = menuType;
                [self.navigationController pushViewController:listVC animated:YES];
            }
            else{
                [self.navigationController pushViewController:controller    animated:YES];
            }
        }
    }
}

-(void)addUIViews{
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBg.png"]];
    bgImgView.frame = CGRectMake(0, 0, 768, 1004);
    [self.view addSubview:bgImgView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 768, 850)];
    scrollView.delegate = self;
	
//	[self.scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(284, 935, 200, 36)];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    NSArray *menuConfigs = [[SystemConfigContext sharedInstance] getMenuConfigs];
    int menuIndex = 0;
    self.pageViewAry = [NSMutableArray arrayWithCapacity:5];
    for(NSDictionary *menuPage in menuConfigs){
        MenuPageView *pageView = [[MenuPageView alloc] initWithFrame:CGRectMake(menuIndex*768, 0, 768, 850) andMenuPageInfo:menuPage andTarget:self andAction:@selector(toggleMenuControl:)];
        
        [scrollView addSubview:pageView];
        [pageViewAry addObject:pageView];
        menuIndex++;
    }
    if(menuIndex <=1)pageControl.hidden = YES;
    self.pageControl.numberOfPages = menuIndex;
	[scrollView setContentSize:CGSizeMake(menuIndex*768, 850)];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 971, 156, 21)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.text = [NSString stringWithFormat:@"当前版本：%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] ;
    [self.view addSubview:versionLabel];
}

-(void)showBageIcons{
    NSArray *aryKeys = [dicBadgeInfo allKeys];

    if([aryKeys count] <= 0)return;
    for(MenuPageView *aPageView in pageViewAry){
        NSArray *allChildViews = [aPageView subviews];
        for(UIView *aView in allChildViews){
            if([aView isKindOfClass:[MenuControl class]]){
                MenuControl* ctrl =  (MenuControl*)aView;
                NSDictionary *menuInfo = [ctrl menuInfo];
                NSString *title = [menuInfo objectForKey:@"MenuTitle"];
                if([aryKeys containsObject:title]){
                    [ctrl showIconBadge:[dicBadgeInfo objectForKey:title]];
                }
            }
        }
    }
    
}

-(void)requestSysDatas{
    //程序版本检查
    self.updater = [[NSAppUpdateManager alloc] init];
    [updater checkAndUpdate:UpdateUrl];
    //发送错误报告
    self.exceptionSender = [[NSExceptionSender alloc] init];
    [exceptionSender sendExceptions];
    //显示待办个数
    //[self getNumb];
    
    
    self.syncManager = [[DataSyncManager alloc] init];
    NSString *settingVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *saveVersion =[[NSUserDefaults standardUserDefaults] stringForKey:kLastVersion];
    //如果发布了新版本 那么就要同步所有数据
    if([saveVersion isEqualToString:settingVer])
    {
        [syncManager syncAllTables:NO];
    }
    else
    {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.labelText = @"正在同步数据，请稍候...";
        [self.HUD show:YES];
        [syncManager syncAllTables:YES];
        [[NSUserDefaults standardUserDefaults] setObject:settingVer forKey:kLastVersion];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFinished:) name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFailed:) name:kNotifyDataSyncFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.aryItems = [[NSMutableArray alloc]initWithCapacity:0];
    [self addUIViews];
    [self requestSysDatas];
    dicBadgeInfo = [[NSMutableDictionary alloc]init];
    //LocationManager *lm = [[LocationManager alloc] init];
    //[lm scheduledLocationWithTimeInterval:1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self getNumb];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [webHelperYuan cancel];
    [webHelperTing cancel];
}

//更新button上的数字
-(void)getNumb
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"QUERY_WAITTASK_TODO" forKey:@"service"];
    [dicParams setObject:@"FIND_LIST" forKey:@"ACTION_TYPE"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    NSLog(@"代办列表url=%@",strUrl);
    self.webHelperYuan = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self tipInfo:@"" tagID:2] ;
}
-(void)updateBadges{
    self.dicBadgeInfo = nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_INDEX" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelperYuan = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:nil delegate:self tagID:1];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBadges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
- (void)changePage:(id)sender
{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlIsChangingPage = YES;
}

-(void)processWebData:(NSData*)webData
{
    
}

-(void)processWebData:(NSData*)webData andTag:(NSInteger)tag
{
    if (tag == 2)
    {
        [self.aryItems removeAllObjects];
        NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
        
        NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
        if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
        {
            [self.aryItems addObjectsFromArray:tmpParsedJsonAry];
            
        }
        dicBadgeInfo = [[NSMutableDictionary alloc]init];
        NSString *numb = [NSString stringWithFormat:@"%d",[self.aryItems count] ];
        [dicBadgeInfo setObject:numb forKey:@"待办任务"];
        [self showBageIcons];

    }

}

-(void)processError:(NSError *)error{
    
}

#pragma mark - 数据同步完成后通知处理

- (void)dataSyncFinished:(NSNotificationCenter *)notification
{
    if(self.HUD)  [self.HUD hide:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFailed object:nil];
}

- (void)dataSyncFailed:(NSNotificationCenter *)notification
{
    if(self.HUD)  [self.HUD hide:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFinished:) name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFailed:) name:kNotifyDataSyncFailed object:nil];
}


@end
