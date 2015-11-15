//
//  EndorseForSeriesActionController.m
//  加签（串行情况）
//
//  Created by Alex Jean on 13-9-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "EndorseForSeriesActionController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"

#define kWebService_Before_Endorse   0
#define kWebService_Endorse_Action   1

@interface EndorseForSeriesActionController ()

@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令
@property (nonatomic,strong) NSArray *aryUserShortCut;
@property (nonatomic,strong) NSArray *aryStepShortCut;
@property (nonatomic,copy) NSString *nextProcessor;
@property (nonatomic,copy) NSString *nextProcessorName;

@end

@implementation EndorseForSeriesActionController

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
    
    self.title = @"流转";
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"流转" style:UIBarButtonItemStyleDone target:self action:@selector(endorse:)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self requestWorkFlow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.wordsPopoverController)
    {
        [self.wordsPopoverController dismissPopoverAnimated:YES];
    }
    if(self.webHelper)
    {
        [self.webHelper cancel];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

#pragma mark - Network Handler Method

-(void)requestWorkFlow
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_ENDORSE" forKey:@"service"];
    [dicParams setObject: self.bzbh forKey:@"BZBH"];
    [dicParams setObject:@"false" forKey:@"showDepartments"];
    [dicParams setObject:@"false" forKey:@"showUserGroups"];
    [dicParams setObject:@"false" forKey:@"showDepartmentRoles"];
    [dicParams setObject:@"true" forKey:@"showUserShortCut"];
    [dicParams setObject:@"true" forKey:@"showStepShortCut"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    self.webServiceType =  kWebService_Before_Endorse;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if (self.webServiceType == kWebService_Endorse_Action)
    {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp){
            if ([[dicTmp objectForKey:@"result"] boolValue]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"加签成功！"
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
    else
    {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        if (dicTmp && [[dicTmp objectForKey:@"result"] isEqualToString:@"success"])
        {
            self.nextProcessor = [dicTmp objectForKey:@"nextProcessor"];
            self.nextProcessorName = [dicTmp objectForKey:@"nextProcessorName"];
            self.nextStepTasker.text = self.nextProcessorName;
            //个人常用意见
            NSDictionary *dicUsrShortCut = [dicTmp objectForKey:@"userShortCut"];
            if(dicUsrShortCut)
            {
                NSArray * aryTmpUserShortCut = [dicUsrShortCut objectForKey:@"dmList"];
                NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                for(NSDictionary *dic in aryTmpUserShortCut)
                    [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                self.aryUserShortCut = aryTmp;
            }
            //步骤常用意见
            NSDictionary *dicStepShortCut = [dicTmp objectForKey:@"stepShortCut:"];
            if(dicStepShortCut)
            {
                self.aryStepShortCut = [dicStepShortCut objectForKey:@"dmList"];
            }
        }
        else
            bParseError = YES;
        
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

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"获取数据出错。"
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    
    return;
}

#pragma mark - CommenWordsViewController Delegate Method

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    self.opinionView.text = words;
    [self.wordsPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"加签成功！"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate HandleGWResult:TRUE];
    }
}

#pragma mark - Event Handler Method

-(IBAction)endorse:(id)sender
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_ENDORSE_ACTION" forKey:@"service"];
    [dicParams setObject:self.bzbh forKey:@"BZBH"];
    if(self.opinionView.text == nil || self.opinionView.text.length ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入处理意见!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [dicParams setObject:self.opinionView.text forKey:@"opinion"];
    [dicParams setObject:@"FINISH" forKey:@"status"];//流转后当前步骤结束
    [dicParams setObject:@"ALL" forKey:@"activePoint"];//等待所有人完成
    if(self.nextProcessor == nil || self.nextProcessor.length ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下一步骤处理人员不能为空!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [dicParams setObject:self.nextProcessor forKey:@"selectUsers"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    self.webServiceType = kWebService_Endorse_Action;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)btnPersonShortCutPressed:(id)sender
{
    if(self.wordsPopoverController == nil)
    {
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 300);
        tmpController.delegate = self;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.wordsSelectViewController = tmpController;
        self.wordsPopoverController = tmppopover;
    }
    UIButton *btn = (UIButton*)sender;
    self.wordsSelectViewController.wordsAry = self.aryUserShortCut;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
    
}

-(IBAction)btnStepShortCutPressed:(id)sender
{
    if(self.wordsPopoverController == nil)
    {
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 300);
        tmpController.delegate = self;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.wordsSelectViewController = tmpController;
        self.wordsPopoverController = tmppopover;
        
    }
    UIButton *btn = (UIButton*)sender;
    self.wordsSelectViewController.wordsAry = self.aryStepShortCut;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

@end
