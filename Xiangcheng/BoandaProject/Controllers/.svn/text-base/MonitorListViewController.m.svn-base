//
//  MonitorListViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-3-27.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "MonitorListViewController.h"
#import "WebDataParserHelper.h"
#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "WryOnlineMonitorConroller.h"
#import "JSONKit.h"

@interface MonitorListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,WebDataParserDelegate>
@property (nonatomic,strong) WebServiceHelper *serviceHelper;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,copy) NSString *enterprisePolluteTypeCode;
@property (nonatomic,copy) NSString *saveWrymc;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,assign) BOOL isEnd;
@end

@implementation MonitorListViewController

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
    
    self.currentPage = 1;
    self.valueArray = [[NSMutableArray alloc]init];
    
    [self requestData];
}

-(void)requestData{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%d",ONE_PAGE_SIZE] forKey:@"PageSize"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"PageNow"];
    [params setObject:self.isType forKey:@"EnterpriseStatisticType"];
    if ([self.isType isEqualToString:@"Metal"]) {
        [params setObject:@"06" forKey:@"EnterprisePolluteTypeCode"];
    }
    else if ([self.isType isEqualToString:@"SewageTreatmentPlant"]){
        [params setObject:@"04" forKey:@"EnterprisePolluteTypeCode"];
    }
    if ([self.searchBar.text length]) {
        [params setObject:self.self.searchBar.text forKey:@"Keyword"];
    }
    
    NSString *paramsStr = [WebServiceHelper createParametersWithParams:params];
    self.serviceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://222.92.101.82:8080/XC_service_BasicInfo/main.asmx" method:@"Page__EnterpriseListForJson" nameSpace:@"http://tempuri.org/" parameters:paramsStr delegate:self];
    [self.serviceHelper runAndShowWaitingView:self.view];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
	searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews]){
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"搜索"  forState:UIControlStateNormal];
        }
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBarSearchButtonClicked:searchBar];
	[searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self requestData];
}

-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    if ([webData length]<=0) {
        [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
    }
    NSString *fieldName = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    if (tag == 1) {
        fieldName = @"Search__GasMonitorSiteListForJsonResult";
    }
    else if (tag == 2){
        fieldName = @"Search__LiquidMonitorSiteListForJsonResult";
    }
    else{
        fieldName = @"Page__EnterpriseListForJsonResult";
    }
    WebDataParserHelper *parserHelper = [[WebDataParserHelper alloc]initWithFieldName:fieldName andWithJSONDelegate:self andTag:tag];
    [parserHelper parseXMLData:webData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:kNETWORK_ERROR_MESSAGE];
}

-(void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag{
    if (tag == 1 || tag == 2) {
        NSDictionary *dataDic = [jsonStr objectFromJSONString];
        NSArray *dataArray = [dataDic objectForKey:@"Data"];
        if (dataArray && dataArray.count) {
            WryOnlineMonitorConroller *monitor = [[WryOnlineMonitorConroller alloc]init];
            if (tag == 1) {
                monitor.method = @"Page__GasMonitorDataForJson";
                monitor.result = @"Page__GasMonitorDataForJsonResult";
            }
            else{
                monitor.method = @"Page__LiquidMonitorDataForJson";
                monitor.result = @"Page__LiquidMonitorDataForJsonResult";
            }
            monitor.type = @"monitor";
            monitor.pkArray = dataArray;
            monitor.title = self.saveWrymc;
            monitor.scType = self.isType;
            [self.navigationController pushViewController:monitor animated:YES];
        }
        else{
            [self showAlertMessage:@"查询不到排口信息"];
        }
    }
    else{
        NSDictionary *jsonDic = [jsonStr objectFromJSONString];
        if (self.currentPage == 1) {
            [self.valueArray removeAllObjects];
        }
        if (jsonDic &&jsonDic.count) {
            NSDictionary *dataDic = [jsonDic objectForKey:@"Data"];
            if (![dataDic isEqual:[NSNull null]]) {
                NSArray *dataArray = [dataDic objectForKey:@"EntityList"];
                if (dataArray.count < ONE_PAGE_SIZE) {
                    self.isEnd = YES;
                }
                [self.valueArray addObjectsFromArray:dataArray];
            }
        }
        [self.tableView reloadData];
        if(!self.valueArray.count)
        {
            [self showAlertMessage:kNETDATA_ERROR_MESSAGE];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.valueArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [self.valueArray objectAtIndex:indexPath.row];
    NSString *value1 = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"EnterpriseName"]];
    NSString *vocationName = [dataDic objectForKey:@"VocationName"];
    if ([vocationName isEqual:[NSNull null]]) {
        vocationName = @"";
    }
    NSString *value2 = [NSString stringWithFormat:@"单位地址：%@",[dataDic objectForKey:@"EnterpriseAddress"]];
    NSString *value3 = [NSString stringWithFormat:@"行业名称：%@",vocationName];
    NSString *value4 = [NSString stringWithFormat:@"注册类型：%@",[dataDic objectForKey:@"Registration"]];
    NSString *value5 = [NSString stringWithFormat:@"监管级别：%@",[dataDic objectForKey:@"AttentionDegree"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:value1 andSubvalue1:value2 andSubvalue2:value3 andSubvalue3:value4 andSubvalue4:value5 andNoteCount:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"查询结果";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.valueArray objectAtIndex:indexPath.row];
    NSInteger tag = 0;
    NSString *method = @"";
    if ([self.isType isEqualToString:@"Enterprise_Gas"]) {
        tag = 1;
        method = @"Search__GasMonitorSiteListForJson";
    }
    else {
        tag = 2;
        method = @"Search__LiquidMonitorSiteListForJson";
    }
    self.saveWrymc = [dic objectForKey:@"EnterpriseName"];
    NSString *paramsStr = [WebServiceHelper createParametersWithKey:@"EnterpriseCode" value:[dic objectForKey:@"EnterpriseCode"],nil];
    self.serviceHelper = [[WebServiceHelper alloc]initWithUrl:@"http://222.92.101.82:8080/XC_service_BasicInfo/main.asmx" method:method nameSpace:@"http://tempuri.org/" parameters:paramsStr delegate:self];
    [self.serviceHelper runAndShowWaitingView:self.view andTag:tag];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        if (!self.isEnd) {
            self.currentPage++;
            [self requestData];
        }
        else{
            return;
        }
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
