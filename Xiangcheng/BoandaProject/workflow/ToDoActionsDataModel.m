//
//  ToDoDetailDataModel.m
//  HNYDZF
//
//  Created by zhang on 12-12-8.
//
//

#import "ToDoActionsDataModel.h"
#import "PDJsonkit.h"
#import "NSURLConnHelper.h"
#import "ServiceUrlString.h"
#import "AutoTranslateViewController.h"
#import "CopyActionViewController.h"
#import "FinishActionController.h"
#import "TransitionActionControllerNew.h"
#import "CounterSignActionController.h"
#import "FeedbackActionController.h"
#import "EndorseActionController.h"
#import "ReturnBackViewController.h"
#import "JointProcessFeedbackViewController.h"
#import "JointProcessTransitionViewController.h"
#import "LaunchJointProcessViewController.h"
#import "EndorseForSeriesActionController.h"
#import "FaWenBanliController.h"

#define kServiceType_XF 1
#define kServiceType_GW 2

#define kWORKFLOW_FINISH_ACTION 0
#define kWORKFLOW_SINGLEFINISH_ACTION 1

@interface ToDoActionsDataModel()
@property (nonatomic,retain) NSURLConnHelper *webHelper;
@property (nonatomic,retain) UIView *parentView;
@property (nonatomic,retain) TaskActionBaseViewController* target;
@property (nonatomic,copy) NSString *resultHtml;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSString *typeStr;
@property (nonatomic,strong) NSArray *aryAttachFiles;//附件
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,copy) NSDictionary *params;
@property (nonatomic,strong) NSDictionary *dicActionInfo;

@end

@implementation ToDoActionsDataModel
@synthesize webHelper,parentView,target,resultHtml,title,typeStr,aryAttachFiles,params,dicActionInfo,isLoading;

-(id)initWithTarget:(TaskActionBaseViewController*)atarget andParentView:(UIView*)inView{
    self = [super init];
    if(self){
        self.parentView = inView;
        self.target = atarget;
    }
    return self;
}

//结束流程
-(void)finishAction:(id)sender
{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_FINISH_ACTION;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//结束步骤
-(void)singleFinishAction:(id)sender
{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_SINGLEFINISH_ACTION;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//流转
-(void)transitionAction:(id)sender
{
    TransitionActionControllerNew *controller = [[TransitionActionControllerNew alloc] initWithNibName:@"TransitionActionControllerNew" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    
    BOOL isCanJointProcess = [[dicActionInfo objectForKey:@"isCanJointProcess"] isEqualToString:@"true"];
    if(isCanJointProcess){
        //保存会办步骤编号
        NSArray *aryNextSteps = [dicActionInfo objectForKey:@"nextSteps"];
        for(NSDictionary *item in aryNextSteps)
        {
            if([[item objectForKey:@"isJointProcessStep"] isEqualToString:@"true"])
                controller.hbbzbh = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
    
}

//发起会签
-(void)countersignAction:(id)sender
{
    CounterSignActionController *controller = [[CounterSignActionController alloc] initWithNibName:@"CounterSignActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    NSArray *aryNextSteps = [dicActionInfo objectForKey:@"nextSteps"];
    if(aryNextSteps == nil || aryNextSteps.count == 0)
    {
        [self showAlertWarningMessage:@"没有可选的下一步操作,无法正常流转."];
        return;
    }
    for(NSDictionary *item in aryNextSteps)
    {
        if([[item objectForKey:@"isCountersignStep"] isEqualToString:@"true"])
        {
            controller.nextStepId = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//退回
-(void)sendBackAction:(id)sender
{
    ReturnBackViewController *controller = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//反馈
-(void)feedbackAction:(id)sender
{
    FeedbackActionController *controller = [[FeedbackActionController alloc] initWithNibName:@"FeedbackActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//加签
-(void)endorseAction:(id)sender
{
    //"countersignType":"SERIAL"
    NSString *countersignType = [dicActionInfo objectForKey:@"countersignType"];
    if([countersignType isEqualToString:@"SERIAL"])
    {
        //串行
        EndorseForSeriesActionController *controller = [[EndorseForSeriesActionController alloc] initWithNibName:@"EndorseForSeriesActionController" bundle:nil];
        controller.bzbh = [params objectForKey:@"BZBH"];
        //controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = self.target;
        [target.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        EndorseActionController *controller = [[EndorseActionController alloc] initWithNibName:@"EndorseActionController" bundle:nil];
        controller.bzbh = [params objectForKey:@"BZBH"];
        controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = self.target;
        [target.navigationController pushViewController:controller animated:YES];
    }
}

//会办返回
-(void)jointProcessFeedbackAction:(id)sender
{
    JointProcessFeedbackViewController *controller = [[JointProcessFeedbackViewController alloc] initWithNibName:@"JointProcessFeedbackViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    controller.delegate = self.target;
}

//会办流转
-(void)jointProcessTransitionAction:(id)sender
{
    JointProcessTransitionViewController *controller = [[JointProcessTransitionViewController alloc] initWithNibName:@"JointProcessTransitionViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    controller.delegate = self.target;
}

//抄送
-(void)copyAction:(id)sender
{
    CopyActionViewController *controller = [[CopyActionViewController alloc] initWithNibName:@"CopyActionViewController" bundle:nil];
    controller.LCLXBH = [params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [params objectForKey:@"BZDYBH"];
    controller.BZBH = [params objectForKey:@"BZBH"];
    controller.LCSLBH = [params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//已阅 
-(void)autotranslateAction:(id)sender
{
    AutoTranslateViewController *controller = [[AutoTranslateViewController alloc] initWithNibName:@"AutoTranslateViewController" bundle:nil];
    controller.LCLXBH = [params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [params objectForKey:@"BZDYBH"];
    controller.BZBH = [params objectForKey:@"BZBH"];
    controller.LCSLBH = [params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//发起会签
-(void)jointProcessAction:(id)sender
{
    LaunchJointProcessViewController *controller = [[LaunchJointProcessViewController alloc] initWithNibName:@"LaunchJointProcessViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    BOOL isCanJointProcess = [[dicActionInfo objectForKey:@"isCanJointProcess"] isEqualToString:@"true"];
    if(isCanJointProcess)
    {
        //保存会办步骤编号
        NSArray *aryNextSteps = [dicActionInfo objectForKey:@"nextSteps"];
        if(aryNextSteps == nil || aryNextSteps.count == 0)
        {
            [self showAlertWarningMessage:@"没有可选的下一步操作,无法正常流转."];
            return;
        }
        for(NSDictionary *item in aryNextSteps){
            if([[item objectForKey:@"isJointProcessStep"] isEqualToString:@"true"])
                controller.hbbzbh = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    self.dicActionInfo = [resultJSON objectFromJSONString];
    BOOL resultFailed = NO;
    if (dicActionInfo == nil)
    {
        resultFailed = YES;
    }
    else
    {
        NSString *tmp = [dicActionInfo objectForKey:@"result"];
        if(![tmp isEqualToString:@"success"])
        {
            resultFailed = YES;
        }
    }
    if(resultFailed)
    {
        [self showAlertWarningMessage:@"获取数据出错."];
        return;
    }
    

    NSMutableArray *aryBarItems = [NSMutableArray arrayWithCapacity:5];
    //UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //[aryBarItems addObject:flexItem];
    
    NSString *isFirstStep = [dicActionInfo objectForKey:@"isFirstStep"];
    NSString *canFinish = [dicActionInfo objectForKey:@"canFinish"];
    //结束流程
    if([canFinish isEqualToString:@"true"]){
        if(![isFirstStep isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"结束流程" style:UIBarButtonItemStyleBordered target:self action:@selector(finishAction:)];
            [aryBarItems addObject:aBarItem];
        }
    }
    //结束步骤 canSingleFinish
    NSString *canSingleFinish = [dicActionInfo objectForKey:@"canFinishUserDef"];
    NSString *processType = [dicActionInfo objectForKey:@"processType"];
    if([canSingleFinish isEqualToString:@"true"] && ![processType isEqualToString:@"READER"]){
        if(![isFirstStep isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   结  束   " style:UIBarButtonItemStyleBordered target:self action:@selector(singleFinishAction:)];
            [aryBarItems addObject:aBarItem];
        }
    }
    
    NSString *canTransition = [dicActionInfo objectForKey:@"canTransition"];
    if([canTransition isEqualToString:@"true"]){
        //transitionAction
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   流  转   " style:UIBarButtonItemStyleBordered target:self action:@selector(transitionAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    
    NSString *canSendback = [dicActionInfo objectForKey:@"canSendback"];
    if([canSendback isEqualToString:@"true"]){
        if(![isFirstStep isEqualToString:@"true"])
        {
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   退  回   " style:UIBarButtonItemStyleBordered target:self action:@selector(sendBackAction:)];
            [aryBarItems addObject:aBarItem];
        }
    }
    
    NSString *canCountersign = [dicActionInfo objectForKey:@"canCountersign"];
    if([canCountersign isEqualToString:@"true"]){
         UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"发起会签" style:UIBarButtonItemStyleBordered target:self action:@selector(countersignAction:)];
         [aryBarItems addObject:aBarItem];
        
    }
    
    NSString *isCanFeedback = [dicActionInfo objectForKey:@"isCanFeedback"];
    if([isCanFeedback isEqualToString:@"true"]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   反  馈   " style:UIBarButtonItemStyleBordered target:self action:@selector(feedbackAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    
    NSString *isCanEndorse = [dicActionInfo objectForKey:@"isCanEndorse"];
    if([isCanEndorse isEqualToString:@"true"]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   加  签   " style:UIBarButtonItemStyleBordered target:self action:@selector(endorseAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    
    //"isCanJointProcess":"false",//是否能发起会办
    NSString *isCanJointProcess = [dicActionInfo objectForKey:@"isCanJointProcess"];
    if([isCanJointProcess isEqualToString:@"true"]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"发起会办" style:UIBarButtonItemStyleBordered target:self action:@selector(jointProcessAction:)];
        [aryBarItems addObject:aBarItem];
    }
    
    //"isCanJointProcessFeedback":"false",//是否可以会办步骤返回
    NSString *isCanJointProcessFeedback = [dicActionInfo objectForKey:@"isCanJointProcessFeedback"];
    if([isCanJointProcessFeedback isEqualToString:@"true"]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"会办返回" style:UIBarButtonItemStyleBordered target:self action:@selector(jointProcessFeedbackAction:)];
        [aryBarItems addObject:aBarItem];
    }
    
    //"isCanJointProcessTransition":"false",//是否可以会办步骤流转
    NSString *isCanJointProcessTransition = [dicActionInfo objectForKey:@"isCanJointProcessTransition"];
    if([isCanJointProcessTransition isEqualToString:@"true"]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"会办流转" style:UIBarButtonItemStyleBordered target:self action:@selector(jointProcessTransitionAction:)];
        [aryBarItems addObject:aBarItem];
    }
    
    if([processType isEqualToString:@"READER"]){
        UIBarButtonItem *aBarItemRead = [[UIBarButtonItem  alloc] initWithTitle:@"来文已阅" style:UIBarButtonItemStyleBordered target:self action:@selector(autotranslateAction:)];
        [aryBarItems addObject:aBarItemRead];
    }
    
    //UIBarButtonItem *aBarItemCopy = [[UIBarButtonItem  alloc] initWithTitle:@"传阅" style:UIBarButtonItemStyleBordered target:self action:@selector(copyAction:)];
    //[aryBarItems addObject:aBarItemCopy];
    
    //[self.view addSubview:toolBar];
    target.navigationItem.rightBarButtonItems =aryBarItems;
    
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    [self showAlertWarningMessage:@"请求数据失败."];
    return;
}

-(void)requestActionDatasByParams:(NSDictionary *)info
{
    self.params = info;
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"QUERY_TASK_STATE" forKey:@"service"];
    [dicParams setObject:[params objectForKey:@"BZBH"] forKey:@"bzbh"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    isLoading = YES;
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:parentView delegate:self];
    NSLog(@"%@", strUrl);
}

-(void)cancelRequest
{
    [webHelper cancel];
}

- (void)showAlertWarningMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

@end
