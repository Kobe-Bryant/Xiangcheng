//
//  WRYInfoViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-3.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "WRYInfoViewController.h"
#import "ServiceUrlString.h"
#import "WRYRecomposeViewController.h"
#import "JSONKit.h"
#import "HtmlTableGenerator.h"

@interface WRYInfoViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,copy)NSString *serviceType;
@end

@implementation WRYInfoViewController
@synthesize wrybh,wrymc,infoDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)changeWRYMessage:(UIBarButtonItem *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (self.tableView.frame.origin.x == 528) {
       self.tableView.frame = CGRectMake(528+240, 0, 240, 960);
    }
    else{
        self.tableView.frame = CGRectMake(528, 0, 240, 960);
    }
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipe];
    // Do any additional setup after loading the view from its nib.
    
    //self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"污染源修改" style:UIBarButtonItemStyleBordered target:self action:@selector(changeWRYInfo)];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"详细信息" style:UIBarButtonItemStyleBordered target:self action:@selector(changeWRYMessage:)];
    
    self.array = [NSArray arrayWithObjects:@" 基本信息 ",@" 项目审批 ",nil];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0 ];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.title = [self.array objectAtIndex:indexPath.row];
    [self changeWRYMessage:nil];
    
    switch (indexPath.row) {
        case 0:
            self.serviceType = @"QUERY_WRY_INFO";
            break;
        case 1:
            self.serviceType = @"QUERY_WRY_XMSP";
            break;
//        case 2:
//            self.serviceType = @"QUERY_WRY_PWXKZ";//排污许可证
//            break;
//        case 3:
//            self.serviceType = @"QUERY_WRY_PWSF";//排污收费
//            break;
//        case 4:
//            self.serviceType = @"QUERY_WRY_XZCF";//行政处罚
//            break;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.serviceType forKey:@"service"];
    [params setObject:self.wrybh forKey:@"wrybh"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData *)webData{
    NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSString *htmlStr;
    NSArray *resultArr = [resultJSON objectFromJSONString];
    if(resultArr.count==0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:kNETDATA_ERROR_MESSAGE
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        self.infoDic = [resultArr objectAtIndex:0];
        htmlStr = [HtmlTableGenerator genContentWithTitle:wrymc andParaMeters:self.infoDic andType:self.serviceType];
    }
    self.myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
}

-(void)changeWRYInfo
{
    WRYRecomposeViewController *wryVC = [[WRYRecomposeViewController alloc]initWithDictory:self.infoDic];
    //wryVC.infoDic = self.infoDic;
    [self.navigationController pushViewController:wryVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyWebView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
