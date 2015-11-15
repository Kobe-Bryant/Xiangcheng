//
//  WRYRecomposeViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-3.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "WRYRecomposeViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"

@interface WRYRecomposeViewController ()
@property (nonatomic,strong)IBOutlet UITextField *wrymcFie;
@property (nonatomic,strong)IBOutlet UITextField *wrydzFie;
@property (nonatomic,strong)IBOutlet UITextField *frdbFie;
@property (nonatomic,strong)IBOutlet UIButton *cancelBtn;
@property (nonatomic,strong)IBOutlet UIButton *OKButton;

-(IBAction)cancelBtnClick;
-(IBAction)OKButtonClick;
@end

@implementation WRYRecomposeViewController
@synthesize infoDic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithDictory:(NSDictionary*)dic
{
    if ([super init])
    {
        self.infoDic = dic;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipe];
    // Do any additional setup after loading the view from its nib.
    self.wrymcFie.text = [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"WRYMC"]];
    self.wrydzFie.text = [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"DWDZ"]];
    self.frdbFie.text = [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"FRDB"]];
}

-(IBAction)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)OKButtonClick
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"MODIFY_WRY_INFO" forKey:@"service"];
    NSString *wrybh = [self.infoDic objectForKey:@"WRYBH"];
    [params setObject:wrybh forKey:@"wrybh"];
    [params setObject:self.wrymcFie.text forKey:@"wrymc"];
    [params setObject:self.wrydzFie.text forKey:@"wrydz"];
    [params setObject:self.frdbFie.text forKey:@"frdb"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];

}
#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    BOOL bParsedError = NO;
    NSDictionary *detailDict = [jsonStr objectFromJSONString];
    NSString *msg = nil;
    if (detailDict != nil)
    {
        msg = [detailDict objectForKey:@"message"];
        if ([msg isEqualToString:@"更新污染源信息成功"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更新污染源信息成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"更新污染源信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    else
    {
        bParsedError = YES;
    }

    
    if(bParsedError)
    {
        [self showAlertMessage:@"解析数据出错!"];
    }
    
    
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错!"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
