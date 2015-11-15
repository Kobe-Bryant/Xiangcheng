//
//  TongZhiGongGaoController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TongZhiGongGaoController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "NoticeDetailsViewController.h"
#import "SearchNoticeViewController.h"

@implementation TongZhiGongGaoController

@synthesize itemAry,pageCount,currentPage,tzgglx;
@synthesize isLoading,myTableView,readedSet;


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//修改导航栏
- (void)modifyNavigationBar
{
    self.title = @"通知公告";

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipe];
    
    [self modifyNavigationBar];
    
    self.tzgglx =  @"sytzgg";
    self.itemAry = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];

    [params setObject:@"QUERY_NOTICE_INFO" forKey:@"service"];
    NSString *departStr = [[NSUserDefaults standardUserDefaults]objectForKey:KUserDepartment];
    [params setObject:departStr  forKey:@"department"];
    [params setObject:@"FIND_LISR" forKey:@"ACTION_TYPE"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^^^^^%@",strUrl);
    
    //NSString *strUrl = @"http://222.92.101.82:8008/xcoa_test/invoke?version=1.0&imei=356242050024965&clientType=IPAD&userid=GF&password=1&P_PAGESIZE=25&service=QUERY_NOTICE_INFO&ACTION_TYPE=FIND_LIST&department=4";

    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [myTableView reloadData];
}

#pragma mark - Private methods and delegates

//搜索按钮点击事件处理方法
- (void)searchButtonPressed:(id)sender
{
    SearchNoticeViewController *childView = [[SearchNoticeViewController alloc] initWithNibName:@"SearchNoticeViewController" bundle:nil];
    childView.title = @"查询通知公告";
    [self.navigationController pushViewController:childView animated:YES];
}



//UISegmentControl点击处理
- (void)onTitleChangeClick:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        self.tzgglx =  @"sytzgg";
    }
    else if(sender.selectedSegmentIndex == 1)
    {
        self.tzgglx =  @"bztzgg";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setObject:@"QUERY_NOTICE_INFO" forKey:@"service"];
    NSString *departStr = [[NSUserDefaults standardUserDefaults]objectForKey:KUserDepartment];
    [params setObject:departStr  forKey:@"department"];
    [params setObject:@"FIND_LISR" forKey:@"ACTION_TYPE"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^^^^^%@",strUrl);

    //NSString *strUrl = @"http://222.92.101.82:8008/xcoa_test/invoke?version=1.0&imei=356242050024965&clientType=IPAD&userid=GF&password=1&P_PAGESIZE=25&service=QUERY_NOTICE_INFO&ACTION_TYPE=FIND_LIST&department=4";
    isLoading = YES;
    [itemAry removeAllObjects];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - 网络数据处理

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    BOOL bParseError = NO;
    if([webData length])
    {
    
        //解析JSON格式的数据
        NSMutableString *resultJSON = [[NSMutableString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
        
        NSLog(@"resultJSON ＝ %@",resultJSON);
        
        
        
        
      NSUInteger m =   [resultJSON replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultJSON.length)];
        
        NSLog(@"m = %d",m);
        
        
        NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
        
        NSLog(@"tmpParsedJsonAry = %@",tmpParsedJsonAry);
        
        
        if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
        {

        [itemAry addObjectsFromArray:tmpParsedJsonAry];
 
        }
        else{
            [self showAlertMessage:@"暂无通知"];
        }
    }
    else
    {
        bParseError = YES;
    }
    [self.myTableView reloadData];
    if(bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"提示"  message:@"获取数据出错。"  delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
    return;
}

#pragma mark - TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [itemAry count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    NSString *yxjStr = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"ngr"];
    if (!yxjStr)
    {
        yxjStr = @"";
    }
    NSString *fbdwStr = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"ZZJC"];
    if (!fbdwStr)
    {
        fbdwStr = @"";
    }
    NSString *fbsjStr = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"ngsj"];
    if (!fbsjStr)
    {
        fbsjStr = @"";
    }
    if(fbsjStr.length > 10) fbsjStr = [fbsjStr substringToIndex:10];
	cell.textLabel.text = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"TZBT"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"拟稿人：%@   发布单位：%@    拟稿时间：%@",yxjStr,fbdwStr,fbsjStr];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (readedSet ==nil)
    {
        readedSet = [[NSMutableSet alloc] initWithCapacity:5];
    }
    NoticeDetailsViewController *childView = [[NoticeDetailsViewController alloc] initWithNibName:@"NoticeDetailsViewController" bundle:nil];
    childView.tzbh = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"TZBH"];
    childView.title = [[itemAry objectAtIndex:indexPath.row] objectForKey:@"TZBT"];
    
    [self.navigationController pushViewController:childView animated:YES];
    [readedSet addObject:[NSNumber numberWithInt:indexPath.row]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (isLoading) return;
    if (currentPage == pageCount)
         return;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_TZGGLIST" forKey:@"service"];
        [params setObject:tzgglx forKey:@"lx"];
        [params setObject:[NSString stringWithFormat:@"%d", currentPage] forKey:@"P_CURRENT"];
        NSString *newStrUrl = [ServiceUrlString generateUrlByParameters:params];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:newStrUrl andParentView:self.view delegate:self];
    }
}

@end
