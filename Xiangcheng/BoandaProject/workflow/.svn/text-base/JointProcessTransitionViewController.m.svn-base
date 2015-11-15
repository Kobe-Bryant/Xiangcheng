//
//  JointProcessTransitionViewController.m
//  BoandaProject
//
//  Created by Alex Jean on 13-9-3.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "JointProcessTransitionViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

#define kWebService_WorkFlow 0
#define kWebService_Transfer 1
#define NOT_SELECTED -1

#define TableView_Step 1
#define TableView_Usr  2

#define SINGLE_MASTER 1
#define MULTI_MASTER  2
#define HELPER  3
#define READER  4
#define MIXTURE 5

@interface JointProcessTransitionViewController ()

@property (nonatomic, strong) NSArray *arySteps;
@property (nonatomic, strong) NSURLConnHelper *webHelper;

@property (nonatomic, assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令
@property (nonatomic, assign) NSInteger processTypeIntValue;
@property (nonatomic, strong) SelectedPersonItem *selPersonItem;

@property (nonatomic, strong) NSDictionary* selectStep;

@property (nonatomic, strong) UIPopoverController* wordsPopoverController;
@property (nonatomic, strong) CommenWordsViewController* wordsSelectViewController;
@property (nonatomic, strong) NSArray *aryUserShortCut;
@property (nonatomic, strong) NSArray *aryStepShortCut;
@property (nonatomic, strong) UIPopoverController* personPopoverController;
@property (nonatomic, strong) UISelectPersonVC* personSelectViewController;

@end

@implementation JointProcessTransitionViewController
@synthesize bzbh;
@synthesize arySteps,selectStep;
@synthesize usrTableView,opinionView;
@synthesize delegate,webServiceType;
@synthesize webHelper,canSignature,processType,processTypeIntValue,selPersonItem;
@synthesize wordsPopoverController, wordsSelectViewController,personPopoverController,personSelectViewController;
@synthesize aryStepShortCut,aryUserShortCut;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"会办流转" style:UIBarButtonItemStyleDone target:self action:@selector(btnTransferPressed:)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    self.title = @"会办流转";
    
    self.selPersonItem = [[SelectedPersonItem alloc] init];
    selPersonItem.multiMuster = NO;
    selPersonItem.showHelper = NO;
    selPersonItem.showReader = NO;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Network Handler

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    if (webServiceType == kWebService_Transfer)
    {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        if (dicTmp)
        {
            if ([[dicTmp objectForKey:@"result"] isEqualToString:@"true"])
            {
                [self showAlertViewWithTitle:@"提示" andWithMessage:@"办理成功"];
            }
            else
            {
                NSString *message = [dicTmp objectForKey:@"message"];
                [self showAlertViewWithTitle:@"提示" andWithMessage:message];
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
            //步骤
            self.arySteps = [dicTmp objectForKey:@"steps"];
            if ([arySteps count] > 0) {
                self.selectStep = [arySteps objectAtIndex:0];
                [self updateSelectStep];
            }
            //用户快捷语句
            NSDictionary *dicUsrShortCut = [dicTmp objectForKey:@"userShortCut"];
            if(dicUsrShortCut)
            {
                NSArray * aryTmpUserShortCut = [dicUsrShortCut objectForKey:@"dmList"];
                NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                for(NSDictionary *dic in aryTmpUserShortCut)
                {
                    [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                }
                self.aryUserShortCut = aryTmp;
            }
            //步骤快捷语句
            NSDictionary *dicStepShortCut = [dicTmp objectForKey:@"stepShortCut"];
            if(dicStepShortCut)
            {
                NSArray * aryTmpStepShortCut = [dicStepShortCut objectForKey:@"dmList"];
                NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                for(NSDictionary *dic in aryTmpStepShortCut)
                    [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                self.aryStepShortCut = aryTmp;
            }
        }
        else
        {
            bParseError = YES;
        }
    }
    
    if (bParseError)
    {
        [self showAlertViewWithTitle:@"提示" andWithMessage:@"获取数据出错."];
        return;
    }
    
}

-(void)processError:(NSError *)error
{
    [self showAlertViewWithTitle:@"提示" andWithMessage:@"获取数据出错."];
    return;
}

-(void)requestWorkFlow
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_JOINT_PROCESS_TRANSITION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];//当前步骤编号,不能为空
    [dicParams setObject:@"true" forKey:@"showUserShortCut"];
    [dicParams setObject:@"true" forKey:@"showStepShortCut"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    webServiceType =  kWebService_WorkFlow;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"办理成功"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    }
}

//流转
-(void)transferToNextStep
{
    if([selPersonItem.arySelectedMainUsers count] <=0 )
    {
        [self showAlertViewWithTitle:@"提示" andWithMessage:@"请选择处理人."];
        return;
    }
    if([opinionView.text length] <=0 )
    {
        [self showAlertViewWithTitle:@"提示" andWithMessage:@"请输入办理意见."];
        return;
    }
    
    NSMutableString *selectUsers = [NSMutableString stringWithCapacity:100];
    NSMutableString *selectHelpers = [NSMutableString stringWithCapacity:100];
    NSMutableString *selectReaders = [NSMutableString stringWithCapacity:100];
    //主办人员
    BOOL firstUsr=YES;
    for (NSDictionary *dic in selPersonItem.arySelectedMainUsers)
    {
        if(firstUsr)
        {
            [selectUsers appendFormat:@"%@",[dic objectForKey:@"userId"]];
            firstUsr = NO;
        }
        else
        {
            [selectUsers appendFormat:@"#%@",[dic objectForKey:@"userId"]];
        }
    }
    //协办人员
    firstUsr=YES;
    for (NSDictionary *dic in selPersonItem.arySelectedHelperUsers)
    {
        if(firstUsr)
        {
            [selectHelpers appendFormat:@"%@",[dic objectForKey:@"userId"]];
            firstUsr = NO;
        }
        else
        {
            [selectHelpers appendFormat:@"#%@",[dic objectForKey:@"userId"]];
        }
    }
    //传阅人员
    firstUsr=YES;
    for (NSDictionary *dic in selPersonItem.arySelectedReaderUsers)
    {
        if(firstUsr)
        {
            [selectReaders appendFormat:@"%@",[dic objectForKey:@"userId"]];
            firstUsr = NO;
        }
        else
        {
            [selectReaders appendFormat:@"#%@",[dic objectForKey:@"userId"]];
        }
    }
    //处理意见
    NSString *opinion = [NSString stringWithFormat:@"%@",opinionView.text];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_JOINT_PROCESS_TRANSITION_ACTION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    [dicParams setObject:opinion forKey:@"opinion"];
    [dicParams setObject:selectUsers forKey:@"selectUsers"];
    [dicParams setObject:selectHelpers forKey:@"selectHelpers"];
    [dicParams setObject:selectReaders forKey:@"selectReaders"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    webServiceType = kWebService_Transfer;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)btnTransferPressed:(id)sender
{
    [self transferToNextStep];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    opinionView.text = words;
    [wordsPopoverController dismissPopoverAnimated:YES];
}

-(IBAction)btnPersonShortCutPressed:(id)sender
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
    wordsSelectViewController.wordsAry = aryStepShortCut;
	[wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:btn.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

#pragma mark
#pragma mark UISelPeronViewDelegate

-(void)returnSelectedPersons:(NSArray*)ary andPersonType:(NSInteger)personType
{
    if (personType == kPersonType_Master)
    {
        selPersonItem.arySelectedMainUsers = ary;
    }
    else if(personType == kPersonType_Reader)
    {
        selPersonItem.arySelectedReaderUsers = ary;
    }
    else if(personType == kPersonType_Helper)
    {
        selPersonItem.arySelectedHelperUsers = ary;
    }
    [usrTableView reloadData];
    [personPopoverController dismissPopoverAnimated:YES];
}

-(void)selectPerson:(id)sender
{
    if(personPopoverController == nil)
    {
        UISelectPersonVC *tmpController = [[UISelectPersonVC alloc] initWithNibName:@"UISelectPersonVC" bundle:nil];
        tmpController.contentSizeForViewInPopover = CGSizeMake(320, 480);
        tmpController.delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tmpController];
        
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:nav];
        
        self.personSelectViewController = tmpController;
        self.personPopoverController = tmppopover;
    }
    
    UIButton *btn = (UIButton*)sender;
    personSelectViewController.toSelPersonType = btn.tag;
    
    personSelectViewController.aryWorkflowUsrs = [selectStep objectForKey:@"users"];
    personSelectViewController.multiUsr = selPersonItem.multiMuster;
	[personSelectViewController.myTableView reloadData];
	[self.personPopoverController presentPopoverFromRect:usrTableView.frame
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionLeft
                                                animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == TableView_Step)
    {
        return 1;
    }
    else
    {
        if (processTypeIntValue == SINGLE_MASTER || processTypeIntValue == MULTI_MASTER)
        {
            return 1;
        }
        else if(processTypeIntValue == READER || processTypeIntValue == HELPER)
        {
            return 2;
        }
        else
        {
            return 3;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == TableView_Step)
    {
        return nil;
    }
    else
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 291, 40)];
        titleView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255  blue:242.0/255  alpha:1];
        titleView.textColor = [UIColor blackColor];
        [headerView addSubview:titleView];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btnAdd.frame = CGRectMake(255, 5, 31, 31);
        [headerView addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(selectPerson:) forControlEvents:UIControlEventTouchUpInside];
        
        if(section == 0)
        {
            if(selPersonItem.multiMuster)
            {
                titleView.text = [NSString stringWithFormat:@"   主办人员(可多选)"];
            }
            else
            {
                titleView.text = [NSString stringWithFormat:@"   主办人员(单选)"];
            }
            btnAdd.tag = kPersonType_Master;
        }
        else if(section == 1)
        {
            if(processTypeIntValue == READER)
            {
                titleView.text = [NSString stringWithFormat:@"   传阅人员"];
                btnAdd.tag = kPersonType_Reader;
            }
            else
            {
                titleView.text = [NSString stringWithFormat:@"   协办人员"];
                btnAdd.tag = kPersonType_Helper;
            }  
        }
        else
        {
            titleView.text = [NSString stringWithFormat:@"   传阅人员"];
            btnAdd.tag = kPersonType_Reader;
        }
        return headerView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == TableView_Step)
    {
        return [arySteps count];
    }
    else
    {
        if(section == 0)
        {
            return [selPersonItem.arySelectedMainUsers count];
        }
        else if(section == 1)
        {
            if(processTypeIntValue == READER)
            {
                return [selPersonItem.arySelectedReaderUsers count];
            }
            else
            {
                return [selPersonItem.arySelectedHelperUsers count];
            }
        }
        else
        {
            return [selPersonItem.arySelectedReaderUsers count];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255  blue:242.0/255  alpha:1];
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
    if(tableView.tag == TableView_Step)
    {
        NSDictionary *tmpDic = [arySteps objectAtIndex:indexPath.row];
        cell.textLabel.text = [tmpDic objectForKey:@"stepDesc"];
        if ([tmpDic isEqual:selectStep])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if(indexPath.section == 0)
        {
            NSDictionary *tmpDic = [selPersonItem.arySelectedMainUsers objectAtIndex:indexPath.row];
            cell.textLabel.text = [tmpDic objectForKey:@"userName"];
        }
        else if(indexPath.section == 1)
        {
            if(processTypeIntValue == READER)
            {
                NSDictionary *tmpDic = [selPersonItem.arySelectedReaderUsers objectAtIndex:indexPath.row];
                cell.textLabel.text = [tmpDic objectForKey:@"userName"];
            }
            else
            {
                NSDictionary *tmpDic = [selPersonItem.arySelectedHelperUsers objectAtIndex:indexPath.row];
                cell.textLabel.text = [tmpDic objectForKey:@"userName"];
            }
        }
        else
        {
            NSDictionary *tmpDic = [selPersonItem.arySelectedReaderUsers objectAtIndex:indexPath.row];
            cell.textLabel.text = [tmpDic objectForKey:@"userName"];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(void)updateSelectStep
{
    self.processType = [selectStep objectForKey:@"processType"];
    
    if([processType isEqualToString:@"SINGLE_MASTER"])
    {
        processTypeIntValue = SINGLE_MASTER;
        selPersonItem.multiMuster = NO;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = NO;
    }
    else if([processType isEqualToString:@"MULTI_MASTER"])
    {
        processTypeIntValue = MULTI_MASTER;
        selPersonItem.multiMuster = YES;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = NO;
    }
    else if([processType isEqualToString:@"HELPER"] )
    {
        processTypeIntValue = HELPER;
        selPersonItem.showHelper = YES;
        selPersonItem.showReader = NO;
        selPersonItem.multiMuster = NO;
    }
    else if([processType isEqualToString:@"READER"])
    {
        processTypeIntValue = READER;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = YES;
        selPersonItem.multiMuster = NO;
    }
    else if([processType isEqualToString:@"MIXTURE"] )
    {
        processTypeIntValue = MIXTURE;
        selPersonItem.showHelper = YES;
        selPersonItem.showReader = YES;
        selPersonItem.multiMuster = NO;
    }
    else
    {
        processTypeIntValue = -1;
    }
    
    //[stepTableView reloadData];
    [usrTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag== TableView_Step)
    {
        self.selectStep = [arySteps objectAtIndex:indexPath.row];
        [self updateSelectStep];
    }
}

- (void)showAlertViewWithTitle:(NSString *)title andWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

@end
