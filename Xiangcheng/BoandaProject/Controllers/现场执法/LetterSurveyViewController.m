//
//  LetterSurveyViewController.m
//  BoandaProject
//
//  Created by PowerData on 14-5-26.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "LetterSurveyViewController.h"
#import "ServiceUrlString.h"
#import "HtmlTableGenerator.h"
#import "JSONKit.h"

@interface LetterSurveyViewController ()

@end

@implementation LetterSurveyViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"调处详情";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"HJXF_QUERY_MEDIATION" forKey:@"service"];
    [params setObject:self.xfbh forKey:@"XFBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
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
        NSDictionary *infoDic = [resultArr objectAtIndex:0];
        htmlStr = [HtmlTableGenerator genContentWithTitle:self.wrymc andParaMeters:infoDic andType:@"HJXF_QUERY_MEDIATION"];
    }
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
