//
//  RecordDetailsViewController.m
//  BoandaProject
//
//  Created by BOBO on 13-12-30.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "RecordDetailsViewController.h"
#import "ServiceUrlString.h"
#import "RelatedrecordsViewController.h"


@interface RecordDetailsViewController ()

@property (nonatomic,strong) NSString *xczfbh;
@property (nonatomic,strong) IBOutlet UIWebView *myWebView;
@property (nonatomic,strong) NSArray *relatedAry;
@property (nonatomic,strong) NSArray *serviceAry;
@end

@implementation RecordDetailsViewController
@synthesize dataDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipe];
    // Do any additional setup after loading the view from its nib.
    self.title = [self.dataDic objectForKey:@"DWMC"];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:@"相关记录" style:UIBarButtonItemStyleBordered target:self action:@selector(Relatedrecords)];
    
    self.relatedAry = [[NSArray alloc]initWithObjects:@"现场检查笔录",@"现场采样记录",@"行政处理",@"询问笔录",@"附件管理",@"约见通知单",@"行政建议书",@"行政提示书",@"行政警示书",@"行政纠错书",@"处罚案件回访表",@"行政警示回访表",@"环境监察意见书",@"重点项目行政辅导书",@"挂牌督办",@"环境违法行为立案审批表",@"行政处罚意见书", nil];
    self.serviceAry = [[NSArray alloc]initWithObjects:@"QUERY_XCZF_TZ_XCJCBL",@"QUERY_XCZF_TZ_XCCYJL",@"QUERY_XCZF_TZ_XZCL",@"QUERY_XCZF_TZ_XWBL",@"QUERY_XCZF_TZ_FJ",@"QUERY_XCZF_TZ_YJTZD",@"QUERY_XCZF_TZ_XZJYS",@"QUERY_XCZF_TZ_XZTSS",@"QUERY_XCZF_TZ_XZJSS",@"QUERY_XCZF_TZ_XZJCS",@"QUERY_XCZF_TZ_CFAJHFB",@"QUERY_XCZF_TZ_XZJSHFB",@"QUERY_XCZF_TZ_HJJCYJS",@"QUERY_XCZF_TZ_ZDXMXZFDS",@"QUERY_XCZF_TZ_GPDB",@"QUERY_XCZF_TZ_WFLASP",@"QUERY_XCZF_TZ_XZCFYJS", nil];
    
    self.xczfbh = [self.dataDic objectForKey:@"XCZFBH"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_XCZF_TZ_BASE" forKey:@"service"];
    [params setObject:self.xczfbh forKey:@"XCZFBH"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSURL *url = [[NSURL alloc]initWithString:strUrl];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
}
-(void)Relatedrecords
{
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.relatedAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.textLabel.text = [self.relatedAry objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *serviceStr = [self.serviceAry objectAtIndex:indexPath.row];
    RelatedrecordsViewController* rdVC = [[RelatedrecordsViewController alloc]init];
    rdVC.serviceStr = serviceStr;
    rdVC.xczfbh = self.xczfbh;
    rdVC.title = self.title;
    [self.navigationController pushViewController:rdVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
