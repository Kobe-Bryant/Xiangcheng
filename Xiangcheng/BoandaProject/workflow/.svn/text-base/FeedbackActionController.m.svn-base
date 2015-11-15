//
//  FeedbackActionController.m
//  TaskTransfer
//
//  Created by zhang on 12-11-15.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "FeedbackActionController.h"

#import "PDJsonkit.h"
#import "ServiceUrlString.h"

#define kWebService_Before_FeedBack   0
#define kWebService_FeedBack_Action   1

@interface FeedbackActionController ()
@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令

@property(nonatomic,strong)NSURLConnHelper *webHelper;
@property(nonatomic,copy)NSString * countersignOpinion;
@end

@implementation FeedbackActionController
@synthesize personalOpinionTxtView,sumOpinionTxtView;
@synthesize webHelper,webServiceType,countersignOpinion,bzbh,canSignature,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)processWebData:(NSData*)webData{
    
    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if (webServiceType == kWebService_FeedBack_Action) {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp){
            if ([[dicTmp objectForKey:@"result"] boolValue]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"反馈成功！"
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
            return;
        }
        else{
            bParseError = YES;
        }
    }
    else{
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp) {
            //步骤
            if ([[dicTmp objectForKey:@"result"] isEqualToString:@"success"]) {
                self.countersignOpinion = [dicTmp objectForKey:@"countersignOpinion"];
                sumOpinionTxtView.text = countersignOpinion;
            }
            else
                bParseError = YES;
            
        }
        else
            bParseError = YES;
        if (bParseError == NO) {

            
        }
    }
    
    
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

#pragma mark - View lifecycle

-(void)requestWorkFlow{
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_FEEDBACK" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    webServiceType =  kWebService_Before_FeedBack;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"反馈成功！"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    }
}

-(IBAction)feedBack:(id)sender{
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_FEEDBACK_ACTION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    [dicParams setObject:personalOpinionTxtView.text forKey:@"opinion"];
    [dicParams setObject:sumOpinionTxtView.text forKey:@"countersignOpinion"];
    if([sumOpinionTxtView.text isEqualToString:countersignOpinion])
        [dicParams setObject:@"false" forKey:@"isUpdate"];
    else
        [dicParams setObject:@"true" forKey:@"isUpdate"];
    
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    webServiceType = kWebService_FeedBack_Action;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)modify:(id)sender{
    sumOpinionTxtView.editable = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sumOpinionTxtView.editable = NO;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(feedBack:)];
    self.navigationItem.rightBarButtonItem = barItem;

    
    [self requestWorkFlow];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
