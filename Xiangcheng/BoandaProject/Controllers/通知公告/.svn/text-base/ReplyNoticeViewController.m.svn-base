//
//  ReplyNoticeViewController.m
//  GuangXiOA
//
//  Created by zhang on 12-9-26.
//
//

#import "ReplyNoticeViewController.h"
#import "NSURLConnHelper.h"
#import "PDJsonkit.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"

#define GETOPINION  1 //反馈前获取意见
#define SENDOPINION 2   //发送反馈意见

@interface ReplyNoticeViewController ()

@property(nonatomic,strong) NSURLConnHelper *webHelper;
@property(nonatomic,unsafe_unretained) NSInteger requestDataType;
@property(nonatomic,strong) NSString *TID;

@end

@implementation ReplyNoticeViewController

@synthesize  txtView,webHelper,tzbh,requestDataType,TID,showTingData;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_TZGGFk" forKey:@"service"];
    [params setObject:tzbh forKey:@"tzbh"];
    [params setObject:[[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"] forKey:@"yhid"];
    NSString *strUrl =@"";
    if(showTingData)
        strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    else
        strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    requestDataType = GETOPINION;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 按钮点击事件处理

-(IBAction)btnPressed:(id)sender
{
    if(txtView.text == nil || txtView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入反馈内容." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_TZGGFk" forKey:@"service"];
    [params setObject:TID forKey:@"tid"];
    [params setObject:txtView.text forKey:@"fknr"];
    NSString *strUrl =@"";
    if(showTingData)
        strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    else
        strUrl = [ServiceUrlString generateUrlByParameters:params];
    requestDataType = SENDOPINION;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    //NSLog(@"SENDOPINION_URL:%@", strUrl);
}

#pragma mark - 网络数据处理

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if(requestDataType == GETOPINION)
    {
        NSDictionary *dic = [resultJSON objectFromJSONString];
        if(dic)
        {
            self.TID = [dic objectForKey:@"TID"];
            NSString *fknr = [dic objectForKey:@"FKNR"];

            if([fknr length] > 0 && (![fknr isEqualToString:@"null"]))
            {
                txtView.text = fknr;
            }  
        }
    }
    else
    {
        NSDictionary *dic = [resultJSON objectFromJSONString];
        if(dic)
        {
            NSString *flag = [dic objectForKey:@"flag"];
            if([flag isEqualToString:@"true"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈信息提交成功." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"反馈信息提交失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
    return;
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"反馈信息提交成功."])
       [self.navigationController popViewControllerAnimated:YES];
}

@end
