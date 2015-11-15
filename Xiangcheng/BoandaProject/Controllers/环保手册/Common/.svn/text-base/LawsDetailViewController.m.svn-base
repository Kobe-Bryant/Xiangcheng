//
//  LawsDetailViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LawsDetailViewController.h"
#import "ServiceUrlString.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface LawsDetailViewController ()
@property (nonatomic, strong) ASINetworkQueue * networkQueue ;
@property (nonatomic, strong)UIProgressView* downloadFileProgress;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSDictionary *fileItem;
@end

@implementation LawsDetailViewController
@synthesize networkQueue,downloadFileProgress,webView,fileItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString*)getFileLocalPath{
    //下载文件到默认文件夹
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileDir = [docPath stringByAppendingPathComponent:@"HBSCfiles"];
    NSFileManager *fm = [NSFileManager defaultManager ];
    BOOL isDir;
    if(![fm fileExistsAtPath:fileDir isDirectory:&isDir])
    {
        [fm createDirectoryAtPath:fileDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *fileName =[NSString stringWithFormat:@"%@%@",[fileItem objectForKey:@"FGBH"],[fileItem objectForKey:@"HZ"]];
    NSString *path=[fileDir stringByAppendingPathComponent:fileName];
    return path;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void)loadHBSCItem:(NSDictionary*)item
{
    if(item == nil)return;
    self.fileItem = item;
    self.title = [fileItem objectForKey:@"FGMC"];
    NSString *filePath = [self getFileLocalPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath])
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        [self.view addSubview:webView];
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [downloadFileProgress removeFromSuperview];
    }else
        [self downloadFile];
}

#pragma mark -  UIWebView Delegate Method

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"];
}

-(void)downloadFile
{
   
    NSString *path=[self getFileLocalPath];

    //如果文件存在先删除文件
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path])
    {
        [fm removeItemAtPath:path error:nil];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DOWN_OA_FILES" forKey:@"service"];
    [params setObject:@"HBSC" forKey:@"GLLX"];
    [params setObject:@"DOWN_FILE" forKey:@"ACTION_TYPE"];
    [params setObject:@"WZHBSC_Download" forKey:@"AccessPage"];
    [params setObject:[fileItem objectForKey:@"WJMC"] forKey:@"WJMC"];
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];

    NSLog(@"^^^^^%@",strURL);

    if(!self.networkQueue)
    {
        self.networkQueue = [[ASINetworkQueue alloc] init];
    }
    [networkQueue reset];// 队列清零
    [networkQueue setShowAccurateProgress:YES]; // 进度精确显示
    [networkQueue setDelegate:self ]; // 设置队列的代理对象
    downloadFileProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    downloadFileProgress.frame = CGRectMake(100, 400, 568, 30);
    [self.view addSubview:downloadFileProgress];
    
    ASIHTTPRequest *request;
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request setDownloadProgressDelegate:downloadFileProgress]; // 文件 1 的下载进度条
    [request setDownloadDestinationPath:path];
    [request setCompletionBlock :^( void ){
        
        // 使用 complete 块，在下载完时做一些事;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        [self.view addSubview:webView];
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [downloadFileProgress removeFromSuperview];
        
        
    }];
    [request setFailedBlock :^( void ){

        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        [webView loadHTMLString:@"下载文件失败！" baseURL:nil];
        [downloadFileProgress removeFromSuperview];
    }];
    [networkQueue addOperation :request];
    [networkQueue go]; // 队列任务开始
}

@end
