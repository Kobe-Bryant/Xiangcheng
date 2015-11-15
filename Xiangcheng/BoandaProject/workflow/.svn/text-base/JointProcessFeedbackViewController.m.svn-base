//
//  JointProcessFeedbackViewController.m
//  BoandaProject
//
//  Created by Alex Jean on 13-9-3.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "JointProcessFeedbackViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"

#define kWebService_WorkFlow 0
#define kWebService_Transfer 1
#define kSuccessMessage @"办理成功"

@interface JointProcessFeedbackViewController ()
@property (nonatomic, strong) NSURLConnHelper *webHelper;
@property (nonatomic, assign) NSInteger webServiceType; // 0请求流转步骤 1 流转命令
@property (nonatomic, strong) NSArray *aryFilteredUsers;
@property (nonatomic, strong) NSString *feedbackUserId;
@end

@implementation JointProcessFeedbackViewController

@synthesize webHelper, webServiceType;

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
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"会办返回" style:UIBarButtonItemStyleDone target:self action:@selector(btnTransferPressed:)];
    self.navigationItem.rightBarButtonItem = barItem;
    self.title = @"会办返回";
    
    [self requestWorkFlow];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestWorkFlow
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_JOINT_PROCESS_FEEDBACK" forKey:@"service"];
    [dicParams setObject:self.bzbh forKey:@"BZBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    self.webServiceType =  kWebService_WorkFlow;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if(self.webServiceType == kWebService_WorkFlow)
    {
        NSDictionary *parsedJSONDict = [resultJSON objectFromJSONString];
        if(parsedJSONDict != nil)
        {
            NSString *result = [parsedJSONDict objectForKey:@"result"];
            if([result isEqualToString:@"success"])
            {
                self.aryFilteredUsers = [parsedJSONDict objectForKey:@"users"];
                if(self.aryFilteredUsers.count == 1)
                {
                    self.feedbackUserId = [[self.aryFilteredUsers objectAtIndex:0] objectForKey:@"userId"];;
                }
                [self.usersTableView reloadData];
            }
            else
            {
                [self.usersTableView reloadData];
                [self showAlertMessage:[parsedJSONDict objectForKey:@"message"]];
            }
        }
        else
        {
            [self.usersTableView reloadData];
            [self showAlertMessage:@"获取数据出错."];
        }
    }
    else if (self.webServiceType == kWebService_Transfer)
    {
        NSDictionary *parsedJSONDict = [resultJSON objectFromJSONString];
        if(parsedJSONDict != nil)
        {
            NSString *result = [parsedJSONDict objectForKey:@"result"];
            if([result isEqualToString:@"true"])
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

- (void)viewDidUnload {
    [self setUsersTableView:nil];
    [self setOpinionTextView:nil];
    [super viewDidUnload];
}

-(IBAction)btnTransferPressed:(id)sender
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_JOINT_PROCESS_FEEDBACK_ACTION" forKey:@"service"];
    [dicParams setObject:self.bzbh forKey:@"BZBH"];//BZBH  (当前步骤编号)
    if(self.feedbackUserId.length == 0 || self.feedbackUserId == nil)
    {
        [self showAlertMessage:@"处理人员不能为空."];
        return;
    }
    if(self.opinionTextView.text.length == 0)
    {
        [self showAlertMessage:@"处理意见不能为空."];
        return;
    }
    [dicParams setObject:self.opinionTextView.text forKey:@"opinion"];//opinion (处理意见)
    [dicParams setObject:self.feedbackUserId forKey:@"feedbackUserId"];//feedbackUserId (返回人ID)
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    self.webServiceType =  kWebService_Transfer;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryFilteredUsers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    NSDictionary *tmpDic = [self.aryFilteredUsers objectAtIndex:indexPath.row];
    if([self.feedbackUserId isEqualToString:[tmpDic objectForKey:@"userId"]] || self.aryFilteredUsers.count == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [tmpDic objectForKey:@"userName"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.feedbackUserId = [[self.aryFilteredUsers objectAtIndex:indexPath.row] objectForKey:@"userId"];
    [self.usersTableView reloadData];
}

@end
