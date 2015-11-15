//
//  FinishActionController.m
//  TaskTransfer
//
//  Created by zhang on 12-11-15.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "FinishActionController.h"
#import "NSURLConnHelper.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"

@interface FinishActionController ()
@property(nonatomic,strong)NSURLConnHelper *webHelper;
@end

@implementation FinishActionController
@synthesize txtView,segCtrl,bzbh,webHelper,canSignature,signLabel,delegate;

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

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"结束" style:UIBarButtonItemStyleDone target:self action:@selector(finish:)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    self.processer = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
}


-(void)viewWillAppear:(BOOL)animated
{
    signLabel.hidden = !canSignature;
    segCtrl.hidden = !canSignature;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)finish:(id)sender
{
    //0表示WORKFLOW_FINISH_ACTION 1表示WORKFLOW_SINGLEFINISH_ACTION
    if(self.serviceType == 0)
    {
        [self requestFinishAction];
    }
    else if (self.serviceType == 1)
    {
        [self requestSingleFinishAction];
    }
}

- (void)requestSingleFinishAction
{
    NSString *opinion = [NSString stringWithFormat:@"%@",txtView.text];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_SINGLEFINISH_ACTION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"stepId"];
    [dicParams setObject:opinion forKey:@"opinion"];
    if (canSignature)
    {
        [dicParams setObject:[NSString stringWithFormat:@"%d",segCtrl.selectedSegmentIndex] forKey:@"signature"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)requestFinishAction
{
    NSString *opinion = [NSString stringWithFormat:@"%@",txtView.text];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_FINISH_ACTION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"stepId"];//当前步骤编号
    [dicParams setObject:self.processer forKey:@"processer"];//当前处理人
    [dicParams setObject:self.processType forKey:@"processType"];//当前步骤处理类型
    [dicParams setObject:opinion forKey:@"opinion"];//意见
    if (canSignature)
    {
        [dicParams setObject:[NSString stringWithFormat:@"%d",segCtrl.selectedSegmentIndex] forKey:@"signature"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData*)webData{
    
    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dicTmp = [resultJSON objectFromJSONString];
    
    if (dicTmp){
        if ([[dicTmp objectForKey:@"result"] boolValue]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"结束成功！"
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];

        }
        else{
            NSString *message = [dicTmp objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"错误"
                                  message:message
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else
        bParseError = YES;

    
    if (bParseError) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"获取数据出错。"
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];

        return;
    }
    
}

-(void)processError:(NSError *)error{
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"结束成功！"] ) {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    }
}



@end
