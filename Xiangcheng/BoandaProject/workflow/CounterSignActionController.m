//
//  CounterSignActionController.m
//  TaskTransfer
//
//  Created by zhang on 12-11-15.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "CounterSignActionController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "UsersHelper.h"
#import "SystemConfigContext.h"

#define kWebService_Before_CounterSign   0
#define kWebService_CounterSign_Action   1
#define kTag_Step_ShortCut 1 //步骤常用意见
#define kTag_User_ShortCut 2 //个人常用意见
#define kTag_Collect_Person 3 //意见汇总人

@interface CounterSignActionController ()

@property(nonatomic,strong)NSURLConnHelper *webHelper;
@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令
@property(nonatomic,strong)NSArray *aryUserShortCut;
@property(nonatomic,strong)NSArray *aryStepShortCut;
@property(nonatomic,strong)NSArray *aryBZUsers; //会签步骤的人员
@property(nonatomic,strong)NSMutableArray *arySelectedUsers;
@property(nonatomic,strong)NSMutableArray *arySelectedUserIDs;

@property (nonatomic, retain) UIPopoverController* wordsPopoverController;
@property (nonatomic, retain) CommenWordsViewController* wordsSelectViewController;
@property(nonatomic, copy)NSDictionary *collectPersonDic;
@property(nonatomic, assign) int currentClickButton;
@property(nonatomic, copy) NSString* collectionPersonId;
@property(nonatomic, copy) NSString* collectionPersonName;

@end

@implementation CounterSignActionController
@synthesize bzbh,usrTableView,shortcutTableView, opinionView,selUsersTxtView;
@synthesize nextStepSegCtrl,sumOpinionSegCtrl,arySelectedUsers,nameLabel;
@synthesize webHelper,webServiceType,aryStepShortCut,aryUserShortCut,aryBZUsers;
@synthesize wordsPopoverController,canSignature, wordsSelectViewController,counterSignTypeSegCtrl,delegate;

#pragma mark - View lifecycle

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
    
    [self requestWorkFlow];
    
    self.collectButton.tag = kTag_Collect_Person;
    self.userShortCutButton.tag = kTag_User_ShortCut;
    self.stepShortCutButton.tag = kTag_Step_ShortCut;
    [self.counterSignTypeSegCtrl addTarget:self action:@selector(counterSignTypeClick:) forControlEvents:UIControlEventValueChanged];
    
    [self.collectButton addTarget:self action:@selector(chooseCollectPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.collectPersonDic = [[SystemConfigContext sharedInstance] getUserInfo];
    self.collectionPersonId = [self.collectPersonDic objectForKey:@"userId"];
    [self.collectButton setTitle:[self.collectPersonDic objectForKey:@"uname"] forState:UIControlStateNormal];
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
	tmpController.contentSizeForViewInPopover = CGSizeMake(200, 300);
	tmpController.delegate = self;
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;

}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.signLabel.hidden = !canSignature;
     self.signSegCtrl.hidden = !canSignature;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)counterSignTypeClick:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        //并行
        self.sumOpinionSegCtrl.enabled = YES;
    }
    else
    {
        //串行
        self.sumOpinionSegCtrl.selectedSegmentIndex = 0;
        self.sumOpinionSegCtrl.enabled = NO;
    }
}

-(IBAction)counterSign:(id)sender
{
    if(self.arySelectedUserIDs == nil || self.arySelectedUserIDs.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择处理人." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(self.opinionView.text == nil || self.opinionView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入处理意见." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_COUNTERSIGN_ACTION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];//步骤编号
    [dicParams setObject:self.opinionView.text forKey:@"opinion"];//意见
    [dicParams setObject:self.nextStepId forKey:@"selectSteps"];//会签步骤编号
    
    [dicParams setObject:@"" forKey:@"attributes"];//其他参数
    //处理人
    NSMutableString *strUsers = [NSMutableString stringWithCapacity:20];
    for(NSString *userID in self.arySelectedUserIDs)
    {
        [strUsers appendFormat:@"%@#",userID];
    }
    [dicParams setObject:strUsers forKey:@"selectUsers"];
    //处理类型
    if(self.counterSignTypeSegCtrl.selectedSegmentIndex == 0)
    {
        [dicParams setObject:@"PARALLEL" forKey:@"type"];//处理类型 并行
    }
    else
    {
        [dicParams setObject:@"SERIAL" forKey:@"type"];//处理类型 串行
    }
    //状态
    if(nextStepSegCtrl.selectedSegmentIndex == 0)
    {
        [dicParams setObject:@"WAIT" forKey:@"status"];
    }
    else
    {
        [dicParams setObject:@"FINISH" forKey:@"status"];
    }
    //流转后当前步骤激活时机
    if(sumOpinionSegCtrl.selectedSegmentIndex == 0)
    {
        [dicParams setObject:@"ALL" forKey:@"activePoint"];
    }
    else
    {
        [dicParams setObject:@"SINGLE" forKey:@"activePoint"];
    }
    //意见汇总人
    [dicParams setObject:self.collectionPersonId forKey:@"opinionProcessor"];
    if (canSignature) {
        [dicParams setObject:[NSString stringWithFormat:@"%d",self.signSegCtrl.selectedSegmentIndex] forKey:@"signature"];
    }
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    webServiceType = kWebService_CounterSign_Action;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Handler Method

-(IBAction)chooseCollectPersonClick:(id)sender
{
    if(wordsPopoverController == nil){
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 300);
        tmpController.delegate = self;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.wordsSelectViewController = tmpController;
        self.wordsPopoverController = tmppopover;
        
    }
    UsersHelper *uh = [[UsersHelper alloc] init];
    NSArray *tmpAllUsers = [uh queryAllUsers];
    NSMutableArray *userNameAry = [[NSMutableArray alloc] init];
    for(NSDictionary *tmpUser in tmpAllUsers)
    {
        [userNameAry addObject:[tmpUser objectForKey:@"YHMC"]];
    }
    UIButton *btn = (UIButton*)sender;
    self.currentClickButton = btn.tag;
    wordsSelectViewController.wordsAry = userNameAry;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

-(IBAction)btnPersonShortCutPressed:(id)sender
{
    if(wordsPopoverController == nil){
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 300);
        tmpController.delegate = self;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.wordsSelectViewController = tmpController;
        self.wordsPopoverController = tmppopover;
        
    }
    
    UIButton *btn = (UIButton*)sender;
     self.currentClickButton = btn.tag;
    wordsSelectViewController.wordsAry = aryUserShortCut;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

-(IBAction)btnStepShortCutPressed:(id)sender
{
    if(wordsPopoverController == nil)
    {
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  initWithStyle:UITableViewStylePlain];
        tmpController.contentSizeForViewInPopover = CGSizeMake(200, 300);
        tmpController.delegate = self;
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.wordsSelectViewController = tmpController;
        self.wordsPopoverController = tmppopover;
    }
    UIButton *btn = (UIButton*)sender;
    self.currentClickButton = btn.tag;
    wordsSelectViewController.wordsAry = aryStepShortCut;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = @"  处理人选择";
    return headerView ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:231.0/255 green:240.0/255 blue:236.0/255 alpha:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryBZUsers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WryXmspListCellIdentifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.detailTextLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    NSDictionary *dic = [aryBZUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]];
    if([arySelectedUsers containsObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [aryBZUsers objectAtIndex:indexPath.row];
    if(arySelectedUsers == nil)
    {
        self.arySelectedUsers = [NSMutableArray arrayWithCapacity:3];
        self.arySelectedUserIDs = [NSMutableArray arrayWithCapacity:3];
    }
    if([arySelectedUsers containsObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]]])
    {
        [self.arySelectedUsers removeObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]]];
        [self.arySelectedUserIDs removeObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]]];
    }
    else
    {
        [arySelectedUsers addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]]];
        [self.arySelectedUserIDs addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]]];
    }
    [self.usrTableView reloadData];
    NSMutableString *strUsers = [NSMutableString stringWithCapacity:20];
    
    for(NSString *name in arySelectedUsers)
        [strUsers appendFormat:@"%@  ",name];
    selUsersTxtView.text = strUsers;
}

#pragma mark - Network Handler Method

-(void)requestWorkFlow
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_COUNTERSIGN" forKey:@"service"];
    [dicParams setObject:self.bzbh forKey:@"BZBH"];//(当前步骤编号),
    [dicParams setObject:self.nextStepId forKey:@"selectSteps"];//(选择流转的下一步的步骤编号,不能为空)
	[dicParams setObject:@"false" forKey:@"showDepartments"];//控制返回结果中是否包括departments节点,true表示返回，其他不返回。
	[dicParams setObject:@"false" forKey:@"showUserGroups"];//控制返回结果中是否包括userGroups节点
	[dicParams setObject:@"false" forKey:@"showDepartmentRoles"];//控制返回结果中是否包括departmentRoles节点
	[dicParams setObject:@"true" forKey:@"showUserShortCut"];//控制返回结果中是否包括userShortCut节点
	[dicParams setObject:@"true" forKey:@"showStepShortCut"];//控制返回结果中是否包括stepShortCut节点
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    webServiceType =  kWebService_Before_CounterSign;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if (webServiceType == kWebService_CounterSign_Action)
    {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        if(dicTmp)
        {
            if ([[dicTmp objectForKey:@"result"] boolValue])
            {
                [self showAlertMessage:@"办理成功"];
            }
            else
            {
                NSString *message = [dicTmp objectForKey:@"message"];
                [self showAlertMessage:message];
            }
            return;
        }
        else
        {
            bParseError = YES;
        }
    }
    else
    {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        if (dicTmp && [[dicTmp objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSArray *arySteps = [dicTmp objectForKey:@"steps"];
            if([arySteps count] > 0){
                NSDictionary *dicInStep = [arySteps objectAtIndex:0];
                self.aryBZUsers = [dicInStep objectForKey:@"users"];
                
            }
            //个人常用意见
            NSDictionary *dicUsrShortCut = [dicTmp objectForKey:@"userShortCut"];
            if(dicUsrShortCut){
                NSArray * aryTmpUserShortCut = [dicUsrShortCut objectForKey:@"dmList"];
                NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                for(NSDictionary *dic in aryTmpUserShortCut)
                    [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                self.aryUserShortCut = aryTmp;
            }
            //步骤常用意见
            NSDictionary *dicStepShortCut = [dicTmp objectForKey:@"stepShortCut"];
            if(dicStepShortCut){
                NSArray * aryTmpStepShortCut = [dicStepShortCut objectForKey:@"dmList"];
                NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                for(NSDictionary *dic in aryTmpStepShortCut)
                    [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                self.aryStepShortCut = aryTmp;
            }
            
            [usrTableView reloadData];
        }
        else
            bParseError = YES;
        
    }
    if (bParseError)
    {
        return;
    }
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错."];
}

#pragma mark - Private Methods

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"办理成功"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    }
}

#pragma mark - CommonWords Selected Delegate Method

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    if(self.currentClickButton == kTag_Step_ShortCut || self.currentClickButton == kTag_User_ShortCut)
    {
        opinionView.text = words;
    }
    else if(self.currentClickButton == kTag_Collect_Person)
    {
        NSDictionary *tmpDict = [[[[UsersHelper alloc] init] queryAllUsers] objectAtIndex:row];
        self.collectionPersonId = [tmpDict objectForKey:@"YHID"];
        self.collectionPersonName = words;
        if(self.collectionPersonName == nil || self.collectionPersonId == nil)
        {
            NSDictionary *usrInfo = [[SystemConfigContext sharedInstance] getUserInfo];
            NSString *cnName = [usrInfo objectForKey:@"uname"];
            NSString *usrid = [usrInfo objectForKey:@"userId"];
            self.collectPersonDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cnName, usrid,nil] forKeys:[NSArray arrayWithObjects:@"userName", @"userId",nil]];
        }
        else
        {
            self.collectPersonDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.collectionPersonName, self.collectionPersonId,nil] forKeys:[NSArray arrayWithObjects:@"userName", @"userId",nil]];
        }
        [self.collectButton setTitle:words forState:UIControlStateNormal];
        //如果当前选择的汇总人不是当前的任务办理人的话，当前步骤流转后只能选择结束
        NSDictionary *currentTaskerInfo = [[SystemConfigContext sharedInstance] getUserInfo];
        NSString *currentTasker = [currentTaskerInfo objectForKey:@"userId"];
        if(![self.collectionPersonId isEqualToString:currentTasker])
        {
            self.nextStepSegCtrl.selectedSegmentIndex = 1;
            self.nextStepSegCtrl.enabled = NO;
        }
        else
        {
            self.nextStepSegCtrl.enabled = YES;
        }
    }
    [wordsPopoverController dismissPopoverAnimated:YES];
}

@end
