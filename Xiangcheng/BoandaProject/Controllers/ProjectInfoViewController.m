//
//  ProjectInfoViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-3.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "ProjectInfoViewController.h"
#import "ServiceUrlString.h"
#import "HtmlTableGenerator.h"
#import "JSONKit.h"

@interface ProjectInfoViewController ()
@property (nonatomic,strong) IBOutlet UIWebView *myWebView;
@end

@implementation ProjectInfoViewController
@synthesize xmbh,xmmc;
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
    self.title = @"详细信息";
    
    [self requestData];
}
-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"XMSP_DATA_DETAIL" forKey:@"service"];
    [params setObject:self.xmbh forKey:@"xmbh"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^^^^^%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSString *htmlStr;
    NSDictionary *jsonDic = [resultJSON objectFromJSONString];
    NSArray *resultArr = [[jsonDic objectForKey:@"data"] objectForKey:@"rows"];
    if(resultArr.count == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:kNETDATA_ERROR_MESSAGE
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:[resultArr objectAtIndex:0]];
        NSString *XMZTZ = [infoDic objectForKey:@"XMZTZ_RMB"];
        NSString *HBZTZ_RMB = [infoDic objectForKey:@"HBZTZ_RMB"];;
        [infoDic setObject:[NSString stringWithFormat:@"%@万元",XMZTZ] forKey:@"XMZTZ_RMB"];
        [infoDic setObject:[NSString stringWithFormat:@"%@万元",HBZTZ_RMB] forKey:@"HBZTZ_RMB"]; 
        htmlStr = [HtmlTableGenerator genContentWithTitle:self.xmmc andParaMeters:infoDic andType:@"XMSP_DATA_DETAIL"];
    }
    self.myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
