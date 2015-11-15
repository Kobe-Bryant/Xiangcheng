//
//  RelatedrecordsViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-2-12.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "RelatedrecordsViewController.h"
#import "ServiceUrlString.h"
#import "HtmlTableGenerator.h"
#import "JSONKit.h"
#import "CommenWordsViewController.h"

@interface RelatedrecordsViewController ()<UIAlertViewDelegate,WordsDelegate>
@property (nonatomic,strong) CommenWordsViewController *wordsViewController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) NSArray *infoArray;
@property (nonatomic,strong) NSMutableArray *cybhArray;
@end

@implementation RelatedrecordsViewController
@synthesize xczfbh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)rightBarButtonItem:(UIBarButtonItem *)sender{
    self.wordsViewController.wordsAry = self.cybhArray;
    [self.popController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.popController) {
        [self.popController dismissPopoverAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"采样编号" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.cybhArray = [[NSMutableArray alloc]init];
    
    self.wordsViewController = [[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain];
    self.wordsViewController.delegate = self;
    self.wordsViewController.contentSizeForViewInPopover = CGSizeMake(200, 250);
    self.popController = [[UIPopoverController alloc]initWithContentViewController:self.wordsViewController];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.serviceType forKey:@"service"];
    [params setObject:self.xczfbh forKey:@"XCZFBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData *)webData{
    NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSDictionary *result = [resultJSON objectFromJSONString];
    NSArray *resultArr = [result objectForKey:@"data"];
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
        if ([self.serviceType isEqualToString:@"QUERY_XCZF_TZ_XCCYJL"]) {
            self.infoArray = [result objectForKey:@"Info"];
            for (NSDictionary *dic in self.infoArray) {
                [self.cybhArray addObject:[dic objectForKey:@"YPBH"]];
            }
        }
        self.infoDic = [NSDictionary dictionaryWithDictionary:[resultArr objectAtIndex:0] ];
        [self webViewLoadDataWithIndex:0];
    }
}

-(void)webViewLoadDataWithIndex:(NSInteger)index{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:self.infoDic];
    if (self.infoArray && self.infoArray.count) {
        [dataDic addEntriesFromDictionary:[self.infoArray objectAtIndex:index]];
        NSString *cymd = [dataDic objectForKey:@"CYMD"];
        if ([cymd isEqualToString:@"0"]) {
            [dataDic setObject:@"执法检查" forKey:@"CYMD"];
        }
        else if ([cymd isEqualToString:@"1"]) {
            [dataDic setObject:@"日常检查" forKey:@"CYMD"];
        }
        else if ([cymd isEqualToString:@"2"]){
            [dataDic setObject:@"委托项目" forKey:@"CYMD"];
        }
    }
    NSString *htmlStr = [HtmlTableGenerator genContentWithTitle:self.wrymc andParaMeters:dataDic andType:self.serviceType];
    self.myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WordsDelegate

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    [self webViewLoadDataWithIndex:row];
    [self.popController dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyWebView:nil];
    [super viewDidUnload];
}
@end
