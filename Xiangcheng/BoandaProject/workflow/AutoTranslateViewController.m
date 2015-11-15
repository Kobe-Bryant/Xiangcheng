//
//  AutoTranslateViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-9-10.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "AutoTranslateViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "UsersHelper.h"

@interface AutoTranslateViewController ()

@end

@implementation AutoTranslateViewController

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
    self.processer = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    
    self.title = @"自动流转";
    
    //NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setDateFormat:@"yyyy-MM-dd"];
    //NSString *dateStr = [df stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //self.opinionView.font = [UIFont systemFontOfSize:20.0f];
    //NSString *name = [[[UsersHelper alloc] init] queryUserNameByID:self.processer];
    //self.opinionView.text = [NSString stringWithFormat:@"已阅，%@。%@", name, dateStr];
    
    [self transferButtonClick:nil];
    //[self.sendButton addTarget:self action:@selector(transferButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.opinionView.hidden = YES;
    self.sendButton.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.webHelper)
    {
        [self.webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)transferButtonClick:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"WORKFLOW_TRANSITION_AUTO" forKey:@"service"];
    [params setObject:self.LCLXBH forKey:@"LCBH"];
    [params setObject:self.BZDYBH forKey:@"BZDYBH"];
    [params setObject:self.BZBH forKey:@"BZBH"];
    [params setObject:self.LCSLBH forKey:@"LCSLBH"];
    [params setObject:self.processer forKey:@"processer"];
    [params setObject:self.processType forKey:@"processType"];
    if ([self.opinionView.text isEqualToString:@""]) {
        self.opinionView.text = @"已阅";
        [params setObject:self.opinionView.text forKey:@"opinion"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - Network Handler

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@", resultJSON];
    [str replaceOccurrencesOfString:@"'" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
    NSDictionary *parsedJSONDict = [str objectFromJSONString];
    if(parsedJSONDict != nil)
    {
        NSString *result = [NSString stringWithFormat:@"%@", [parsedJSONDict objectForKey:@"result"]];
        if([result isEqualToString:@"1"])
        {
            [self showAlertMessage:@"办理成功"];
        }
        else
        {
            [self showAlertMessage:[parsedJSONDict objectForKey:@"message"]];
        }
    }
    else
    {
        [self showAlertMessage:@"获取数据出错."];
    }
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错."];
    return;
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"办理成功"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate HandleGWResult:TRUE];
    }
}

#pragma mark - 私有方法

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
    [alert show];
}

- (IBAction)sendButton:(id)sender {
}
@end
