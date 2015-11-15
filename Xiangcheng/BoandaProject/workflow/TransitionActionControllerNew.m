//
//  HandleFileController.m
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TransitionActionControllerNew.h"
#import "SystemConfigContext.h"
#import "NSURLConnHelper.h"
#import "PDJsonkit.h"
#import "UsersHelper.h"
#import "BECheckBox.h"
#import "ServiceUrlString.h"
#import "DepartUsersDataModel.h"

#define TableView_Step 1
#define TableView_Usr  2

//SINGLE_MASTER, 一个主办
/**唯一主办人员，拥有决定流程流向的功能*/
//MULTI_MASTER,多个主办
/**并行的流程主办人员，可以决定流程的流向*/
// HELPER,一个主办多个协办
/**协办人员 可以协助主办人员，不可以决定流程的走向*/
//READER,一个主办多个抄送
/**抄送读者 只能查看业务的信息没有修改，编辑删除的 功能 不能决定流程的走向*/
//MIXTURE;
/** 一个主办 + 多个协办 + 多个抄送的处理模式 */

#define SINGLE_MASTER 1
#define MULTI_MASTER  2
#define HELPER  3
#define READER  4
#define MIXTURE 5
#define Choose_Collection_Person 6

@interface TransitionActionControllerNew()

@property (nonatomic,strong) NSArray *arySteps;
@property (nonatomic,strong)NSURLConnHelper *webHelper;

@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令
@property (nonatomic,assign) NSInteger processTypeIntValue;
@property (nonatomic,strong) SelectedPersonItem *selPersonItem;
//选择的步骤，目前仅仅支持选择单个步骤
@property (nonatomic,strong) NSDictionary* selectStep;

@property (nonatomic,strong) UIPopoverController* wordsPopoverController;
@property (nonatomic,strong) CommenWordsViewController* wordsSelectViewController;
@property (nonatomic,strong)NSArray *aryUserShortCut;
@property (nonatomic,strong)NSArray *aryStepShortCut;
@property (nonatomic,strong) UIPopoverController* personPopoverController;
@property (nonatomic,strong) UISelectPersonVC* personSelectViewController;

@property (nonatomic,copy) NSDictionary *collectPersonDic;
@property (nonatomic,assign) int currentClickButton;
@property (nonatomic,copy) NSString* collectionPersonId;
@property (nonatomic,copy) NSString* collectionPersonName;

@property (nonatomic,strong)NSMutableArray *valueAry;
@property (nonatomic,strong)NSMutableArray *userIdAry;
@property (nonatomic,strong)NSMutableArray *cyrAry;

@property (nonatomic,strong)NSMutableArray *jzAry;//局长，副局长，主任，科员
@property (nonatomic,strong)NSMutableArray *fjzAry;
@property (nonatomic,strong)NSMutableArray *zrAry;
@property (nonatomic,strong)NSMutableArray *kyAry;
@property (nonatomic,assign)BOOL sfbl;//是否办理

@end

@implementation TransitionActionControllerNew
@synthesize bzbh,hbbzbh,btndelete,TransferBtn;
@synthesize arySteps,selectStep;
@synthesize stepTableView,usrTableView,opinionView;
@synthesize delegate,webServiceType;
@synthesize webHelper,canSignature,processType,processTypeIntValue,selPersonItem;
@synthesize wordsPopoverController, wordsSelectViewController,personPopoverController,personSelectViewController;
@synthesize aryStepShortCut,aryUserShortCut,signLabel,signSegCtrl;
@synthesize collectSwitch,isCollectLabel,collectPersonLabel,collectPersonBtn,collectPersonDic;

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

    
    self.jzAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.fjzAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.zrAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.kyAry = [[NSMutableArray alloc]initWithCapacity:0];
    
    collectSwitch.hidden = YES;
    isCollectLabel.hidden = YES;
    collectPersonLabel.hidden = YES;
    collectPersonBtn.hidden = YES;
    
    
    self.title = @"流转";
    self.selPersonItem = [[SelectedPersonItem alloc] init];
    selPersonItem.multiMuster = NO;
    selPersonItem.showHelper = NO;
    selPersonItem.showReader = NO;
    
    self.valueAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.userIdAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.cyrAry = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self requestWorkFlow];
    
    collectPersonBtn.tag = Choose_Collection_Person;
    [collectPersonBtn addTarget:self action:@selector(chooseCollectPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    signLabel.hidden = !canSignature;
    signSegCtrl.hidden = !canSignature;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload {
    [self setUsrFrameView:nil];
    [super viewDidUnload];
}


//意见汇总人按钮点击处理
- (void)chooseCollectPersonClick:(id)sender
{
    if(wordsPopoverController == nil){
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  init];
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


-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    if (webServiceType == kWebService_Transfer) {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp){
            if ([[dicTmp objectForKey:@"result"] isEqualToString:@"true"])
            {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"提示" 
                                      message:@"办理成功"
                                      delegate:self 
                                      cancelButtonTitle:@"确定" 
                                      otherButtonTitles:nil];
                [alert show];

                
            }
            else
            {
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
        if (dicTmp && [[dicTmp objectForKey:@"result"] isEqualToString:@"success"]) {
            //步骤
            NSMutableArray *stepsAry = [NSMutableArray arrayWithArray:[dicTmp objectForKey:@"steps"]];
            for(int i = 0; i < stepsAry.count; i++)
            {
                NSDictionary *subDict = [stepsAry objectAtIndex:i];
                if([[subDict objectForKey:@"stepDesc"] isEqualToString:@"会签"])
                {
                    [stepsAry removeObjectAtIndex:i];
                }
            }
            self.arySteps = stepsAry;
            if ([self.arySteps count] > 0)
            {
                self.selectStep = [self.arySteps objectAtIndex:0];
            }
            
            NSDictionary *dicUsrShortCut = [dicTmp objectForKey:@"userShortCut"];
            if(dicUsrShortCut){
                NSArray * aryTmpUserShortCut = [dicUsrShortCut objectForKey:@"dmList"];
                NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                for(NSDictionary *dic in aryTmpUserShortCut)
                    [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                self.aryUserShortCut = aryTmp;
            }
            
            NSDictionary *dicStepShortCut = [dicTmp objectForKey:@"stepShortCut"];
            if(dicStepShortCut){
                NSArray * aryTmpStepShortCut = [dicStepShortCut objectForKey:@"dmList"];
                NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                for(NSDictionary *dic in aryTmpStepShortCut)
                    [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                self.aryStepShortCut = aryTmp;
            }

       
            
            
        }
        else
            bParseError = YES;
        if (bParseError == NO) {
            
            [stepTableView reloadData]; 
            
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
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"获取数据出错。"
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];

    return;
}

#pragma mark - View lifecycle

-(void)requestWorkFlow
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_TRANSITION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    [dicParams setObject:@"true" forKey:@"showUserShortCut"];
    [dicParams setObject:@"true" forKey:@"showStepShortCut"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    NSLog(@"^^^^^%@",strUrl);
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
    if([self.valueAry count] <=0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"请选择处理人." 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];

        return;
    }
    
    if([opinionView.text length] <=0 )
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入处理意见."
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];

        return;
        
    }

    NSMutableString *selectUsers = [NSMutableString stringWithCapacity:100];
    NSMutableString *selectHelpers = [NSMutableString stringWithCapacity:100];
    NSMutableString *selectReaders = [NSMutableString stringWithCapacity:100];

    BOOL firstUsr=YES;
    for (NSDictionary *dic in self.valueAry)
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
    
    firstUsr=YES;
    for (NSDictionary *dic in self.cyrAry)
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
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    NSString *nextBZBH = [selectStep objectForKey:@"stepId"];
    if([nextBZBH isEqualToString:hbbzbh])
    {
        //如果下一步是会办步骤，那么要调用发起会办的服务
        if(self.hbbzbh == nil || self.hbbzbh.length == 0)
        {
            return;
        }
        if(collectSwitch.isOn)
        {
            [dicParams setObject:@"1" forKey:@"isCollect"];
            [dicParams setObject:[collectPersonDic objectForKey:@"userId"] forKey:@"opinionProcessor"];
        }
        else
        {
             [dicParams setObject:@"0" forKey:@"isCollect"];
        }
        [dicParams setObject:@"WORKFLOW_JOINT_PROCESS_ACTION" forKey:@"service"];
    }
    else
    {
        //如果当前步骤不是会办步骤的话就采用普通的流程流转的服务，这里需要判断步骤的名称是不是会办
        NSString *nextBZMC = [self.selectStep objectForKey:@"stepDesc"];
        if([nextBZMC isEqualToString:@"会办"])
        {
            return;
        }
        [dicParams setObject:@"WORKFLOW_TRANSITION_ACTION" forKey:@"service"];
    }
    NSString *opinion = [NSString stringWithFormat:@"%@",opinionView.text];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    [dicParams setObject:opinion forKey:@"opinion"];
    [dicParams setObject:[selectStep objectForKey:@"stepId"] forKey:@"selectSteps"];
    [dicParams setObject:selectUsers forKey:@"selectUsers"];
    [dicParams setObject:selectHelpers forKey:@"selectHelpers"];
    [dicParams setObject:selectReaders forKey:@"selectReaders"];
    if (canSignature)
    {
        [dicParams setObject:[NSString stringWithFormat:@"%d",signSegCtrl.selectedSegmentIndex] forKey:@"signature"];
    }
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
    if(self.currentClickButton == Choose_Collection_Person)
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
        [collectPersonBtn setTitle:words forState:UIControlStateNormal];
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
    else if ([words isEqualToString:@""]) {
       opinionView.text = @"";
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@。",words];
        opinionView.text = str;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* vi in [self.view subviews])
    {
        if ([vi isKindOfClass:[UIPopoverController class]])
        {
            wordsPopoverController = (UIPopoverController*)vi;
            [wordsPopoverController dismissPopoverAnimated:YES];
        }
    }
    [self.opinionView resignFirstResponder];
}
-(IBAction)btnPersonShortCutPressed:(id)sender{
    if(wordsPopoverController == nil){
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc]  init];
        tmpController.contentSizeForViewInPopover = CGSizeMake(300, 320);
        tmpController.delegate = self;
        tmpController.selectType = 1;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark
#pragma mark UISelPeronViewDelegate

-(void)returnSelectedPersons:(NSArray*)ary andPersonType:(NSInteger)personType
{
    if (personType == kPersonType_Master)
    {
        
        for (int i=0; i<ary.count; i++)
        {
            NSDictionary *dic = [ary objectAtIndex:i];
            NSString *userId = [dic objectForKey:@"userId"];
                
            NSLog(@"^^^^^^%@",dic);
            //NSString *yhzw =
            if(![self.userIdAry containsObject:userId])
            {
                [self.userIdAry addObject:userId];
                [self.valueAry addObject:dic];
                [self addEndName:userId];
                
            }
            
        }
        //selPersonItem.arySelectedMainUsers = ary;

    }else if(personType == kPersonType_Reader) {
        if (self.cyrAry.count > 0)
        {
            [self.cyrAry removeAllObjects];
        }
        
        [self.self.cyrAry addObjectsFromArray:ary];
    }
    else if(personType == kPersonType_Helper) {
        selPersonItem.arySelectedHelperUsers = ary;
    }
    [self refreshOpinionView];
    [usrTableView reloadData];
    [personPopoverController dismissPopoverAnimated:YES];
}

-(void)addEndName:(NSString*)userId
{
    NSString *yhmc = @"";
    NSString *yhzw = @"";
    UsersHelper* usersHelp = [[UsersHelper alloc]init];
    yhmc = [usersHelp queryUserNameByID:userId];
    yhzw = [usersHelp queryUserPositionByID:userId];
    if ([yhzw isEqualToString:@"ORG_LEADER#DEPT_LEADER"])
    {
        NSString *N = [yhmc substringToIndex:1];
        NSString *str = [NSString stringWithFormat:@"%@局",N ];
        [self.jzAry addObject:str];
    }
    if ([yhzw isEqualToString:@"DEPT_LEADERS#WORKER"]||[yhzw isEqualToString:@"ORG_LEADERS#DEPT_LEADERS"])
    {
        [self.fjzAry addObject:yhmc];
        
    }
    if ([yhzw isEqualToString:@"DEPT_LEADER"]||[yhzw isEqualToString:@"DEPT_LEADERS"])
    {
        [self.zrAry addObject: yhmc];
    
    }
    if([yhzw isEqualToString:@"WORKER"])
    {
        [self.kyAry addObject: yhmc];
    }
    
}


-(void)selectPerson:(id)sender
{
    
    UIButton *btn = (UIButton*)sender;
    personPopoverController = nil;
    
        
    UISelectPersonVC *tmpController = [[UISelectPersonVC alloc] initWithNibName:@"UISelectPersonVC" bundle:nil];
    tmpController.contentSizeForViewInPopover = CGSizeMake(320, 480);
    tmpController.delegate = self;
    tmpController.toSelPersonType = btn.tag;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tmpController];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:nav];
    
    self.personSelectViewController = tmpController;
    self.personPopoverController = tmppopover;

    
    personSelectViewController.toSelPersonType = btn.tag;

    UsersHelper* usersHelp = [[UsersHelper alloc]init];
    
    //NSArray *ary1 = [usersHelp queryUserIDByZW:@"ORG_LEADER#DEPT_LEADER"];
    NSArray *ary2 = [usersHelp queryUserIDByZW:@"ORG_LEADERS#DEPT_LEADERS"];
    NSArray *ary3 = [usersHelp queryUserIDByZW:@"DEPT_LEADER"];
    NSArray *ary4 = [usersHelp queryUserIDByZW:@"DEPT_LEADERS"];
    NSArray *ary5 = [usersHelp queryUserIDByZW:@"DEPT_LEADERS#WORKER"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    //[array addObjectsFromArray:ary1];
    [array addObjectsFromArray:ary2];
    [array addObjectsFromArray:ary3];
    [array addObjectsFromArray:ary4];
    [array addObjectsFromArray:ary5];
    
    NSMutableArray *userArray = [[NSMutableArray alloc]init];
    for (NSDictionary *userDic in array) {
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
        NSString *userName = [userDic objectForKey:@"YHMC"];
        NSString *userId = [userDic objectForKey:@"YHID"];
        [mutDic setObject:userName forKey:@"userName"];
        [mutDic setObject:userId forKey:@"userId"];
        [userArray addObject:mutDic];
    }
    personSelectViewController.aryWorkflowUsrs = [NSArray arrayWithArray:userArray];
    
    personSelectViewController.multiUsr = selPersonItem.multiMuster;
    
    //personSelectViewController.multiUsr = YES;

	[personSelectViewController.myTableView reloadData];
	[self.personPopoverController presentPopoverFromRect:self.usrFrameView.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionLeft
											   animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    if(tableView.tag == TableView_Step)
        return 1;
    else{

        return 2;
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == TableView_Step)
        return 0;
    return 35.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section 
{
    
    if(tableView.tag == TableView_Step){
        return nil;
    }
    else{

        UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 233, 33)];
        titleView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255  blue:242.0/255  alpha:1];
        titleView.textColor = [UIColor blackColor];
        [headerView addSubview:titleView];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
        btnAdd.frame = CGRectMake(200, 0, 31, 31);
        
        [btnAdd addTarget:self action:@selector(selectPerson:) forControlEvents:UIControlEventTouchUpInside];
        
        btndelete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btndelete.frame = CGRectMake(185, 3, 40, 30);
        [btndelete addTarget:self action:@selector(deleteAItem) forControlEvents:UIControlEventTouchUpInside];
        

        if(section == 0)
        {
            titleView.text = [NSString stringWithFormat:@"主办人员"];
            [headerView addSubview:btndelete];
            if (self.usrTableView.editing)
            {
                [btndelete setTitle:@"完成" forState:UIControlStateNormal];
            }
            else
            {
                [btndelete setTitle:@"编辑" forState:UIControlStateNormal];
            }
        
        }
        else
        {
            [headerView addSubview:btnAdd];
            titleView.text = [NSString stringWithFormat:@"传阅人员"];
            btnAdd.tag = kPersonType_Reader;
        }
        
        return headerView;
        //return nil;
    }
   
}
-(void)deleteAItem
{
    self.usrTableView.editing = !self.usrTableView.editing;
    if (![self.usrTableView isEditing])
    {
        [self refreshOpinionView];
    }
    [self.usrTableView reloadData];
}
-(void)refreshOpinionView
{
    
    NSString *jzStr = @"";
    NSString *fjzStr = @"";
    NSString *zrStr = @"";
    NSString *kyStr = @"";
    NSString *cyStr = @"";
    NSString *endStr= @"";
    if (self.jzAry.count!=0)
    {
        NSString *str = [self.jzAry objectAtIndex:0];
        jzStr = [NSString stringWithFormat:@"请%@阅示；",str];
    }
    if (self.fjzAry.count!=0)
    {
        NSString *str = @"";
        for (int i=0; i<self.fjzAry.count; i++)
        {
            
            if (i==0)
            {
                str  = [self.fjzAry objectAtIndex:i];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@、%@",str,[self.fjzAry objectAtIndex:i]];
            }
            
        }
        fjzStr = [NSString stringWithFormat:@"请%@阅处；",str];
    }
    if (self.zrAry.count!=0)
    {
        NSString *str = @"";
        for (int i=0; i<self.zrAry.count; i++)
        {
            
            if (i==0)
            {
                str  = [self.zrAry objectAtIndex:i];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@、%@",str,[self.zrAry objectAtIndex:i]];
            }
            
        }
        zrStr = [NSString stringWithFormat:@"请%@阅办；",str];
    }
    if (self.kyAry.count!=0)
    {
         NSString *str = @"";
        for (int i=0; i<self.kyAry.count; i++)
        {
           
            if (i==0)
            {
                str  = [self.kyAry objectAtIndex:i];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@、%@",str,[self.kyAry objectAtIndex:i]];
            }
            
        }
        kyStr = [NSString stringWithFormat:@"请%@办理；",str];
    }
    //传阅
    if (self.cyrAry.count!=0)
    {
        NSString *ccyStr = @"";
        for (int i=0; i<self.cyrAry.count; i++)
        {
            NSString *nameStr =[[self.cyrAry objectAtIndex:i]objectForKey:@"userName"];
            
            if (i==0)
            {
                ccyStr  = nameStr;
            }
            else
            {
                ccyStr = [NSString stringWithFormat:@"%@、%@",ccyStr,nameStr];
            }
            
        }
        cyStr = [NSString stringWithFormat:@"请%@传阅。",ccyStr];
    }
    
    
    endStr = [NSString stringWithFormat:@"%@%@%@%@%@",jzStr,fjzStr,zrStr,kyStr,cyStr];
    self.opinionView.text = endStr;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        int row = [indexPath row];
        NSString *userId = [self.userIdAry objectAtIndex:row];
        UsersHelper* usersHelper = [[UsersHelper alloc]init];
        NSString *yhmc = [usersHelper queryUserNameByID:userId];
        NSString *yhzw = [usersHelper queryUserPositionByID:userId];
        if ([yhzw isEqualToString:@"ORG_LEADER#DEPT_LEADER"])
        {
            NSString *N = [yhmc substringToIndex:1];
            NSString *str = [NSString stringWithFormat:@"%@局",N ];
            [self.jzAry removeObject:str];
        }
        if ([yhzw isEqualToString:@"DEPT_LEADERS#WORKER"]||[yhzw isEqualToString:@"ORG_LEADERS#DEPT_LEADERS"])
        {
            [self.fjzAry removeObject:yhmc];
            
        }
        if ([yhzw isEqualToString:@"DEPT_LEADER"]||[yhzw isEqualToString:@"DEPT_LEADERS"])
        {
            [self.zrAry removeObject:yhmc];
        }
        if([yhzw isEqualToString:@"WORKER"])
        {
            [self.kyAry removeObject:yhmc];
        }
        
        [self.valueAry removeObjectAtIndex:row];
        [self.userIdAry removeObjectAtIndex:row];
        
    }
	if (indexPath.section == 1)
    {
        int row = [indexPath row];
        [self.cyrAry  removeObjectAtIndex:row];
    }
    NSArray* array = [NSArray arrayWithObject:indexPath];
    [self.usrTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView.tag == TableView_Step)
    {
        return [arySteps count];
    }
    else
    {
        if(section == 0)
        {

            //return [selPersonItem.arySelectedMainUsers count];
            return self.valueAry.count;
        }
        else 
        {            
            return [self.cyrAry count];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 40;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255  blue:242.0/255  alpha:1];


}

// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    if(tableView.tag == TableView_Step)
    {
        NSDictionary *tmpDic = [arySteps objectAtIndex:indexPath.row];
        NSLog(@"step = %@",[tmpDic objectForKey:@"stepDesc"]);
        
        
        cell.textLabel.text = [tmpDic objectForKey:@"stepDesc"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        if(indexPath.section == 0){
            //NSDictionary *tmpDic = [selPersonItem.arySelectedMainUsers objectAtIndex:indexPath.row];
            NSDictionary *tmpDic = [self.valueAry objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [tmpDic objectForKey:@"userName"];
        }
        else if(indexPath.section == 1)
        {
            NSDictionary *tmpDic = [self.cyrAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [tmpDic objectForKey:@"userName"];
        }

        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    	
	return cell;
    
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(void)updateSelectStep{
    
    //SINGLE_MASTER, 一个主办
    /**唯一主办人员，拥有决定流程流向的功能*/
    //MULTI_MASTER,多个主办
    /**并行的流程主办人员，可以决定流程的流向*/
    // HELPER,一个主办多个协办
    /**协办人员 可以协助主办人员，不可以决定流程的走向*/
    //READER,一个主办多个抄送
    /**抄送读者 只能查看业务的信息没有修改，编辑删除的 功能 不能决定流程的走向*/
    //MIXTURE;
    /** 一个主办 + 多个协办 + 多个抄送的处理模式 */
    //根据不同processType来选择对应的各种类型人员
    self.processType = [selectStep objectForKey:@"processType"];
    if([processType isEqualToString:@"SINGLE_MASTER"] ){
        processTypeIntValue = SINGLE_MASTER;
        selPersonItem.multiMuster = NO;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = YES;
    }
    else if([processType isEqualToString:@"MULTI_MASTER"] ){
        processTypeIntValue = MULTI_MASTER;
        selPersonItem.multiMuster = YES;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = YES;
    }
    else if([processType isEqualToString:@"HELPER"] ){
        processTypeIntValue = HELPER;
        selPersonItem.showHelper = YES;
        selPersonItem.showReader = NO;
        selPersonItem.multiMuster = NO;
        
    }
    else if([processType isEqualToString:@"READER"] ){
        processTypeIntValue = READER;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = YES;
        selPersonItem.multiMuster = NO;
    }
    else if([processType isEqualToString:@"MIXTURE"] ){
        processTypeIntValue = MIXTURE;
        selPersonItem.showHelper = YES;
        selPersonItem.showReader = YES;
        selPersonItem.multiMuster = NO;
    }
    else{
        processTypeIntValue = -1;
    }
    selPersonItem.arySelectedHelperUsers = nil;
    //selPersonItem.arySelectedMainUsers = nil;
    //self.cyrAry = nil;
    
    NSString *nextBZBH = [selectStep objectForKey:@"stepId"];
    
    BOOL isHuiBan = [nextBZBH isEqualToString:hbbzbh];

    if(isHuiBan ){
        if(collectPersonDic == nil){
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
            
        }
        
        [collectPersonBtn setTitle:[collectPersonDic objectForKey:@"userName"] forState:UIControlStateNormal];
    }
    
    collectSwitch.hidden = !isHuiBan;
    isCollectLabel.hidden = !isHuiBan;
    collectPersonLabel.hidden = !isHuiBan;
    collectPersonBtn.hidden = !isHuiBan;
    
    [stepTableView reloadData];
    [usrTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self updateSelectStep];
    
    if (tableView.tag== TableView_Step)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSString *str = [[self.arySteps objectAtIndex:indexPath.row] objectForKey:@"stepDesc"];
        if([str isEqualToString:@"会签"])
        {
            return;
        }
        self.sfbl = YES;
        self.selectStep = [arySteps objectAtIndex:indexPath.row];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kPersonType_Master;
        
        UISelectPersonVC *tmpController = [[UISelectPersonVC alloc] initWithNibName:@"UISelectPersonVC" bundle:nil];
        tmpController.contentSizeForViewInPopover = CGSizeMake(320, 480);
        tmpController.delegate = self;      
        tmpController.toSelPersonType = btn.tag;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tmpController];
        
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:nav];
        
        self.personSelectViewController = tmpController;
        self.personPopoverController = tmppopover;
        
        
        personSelectViewController.toSelPersonType = btn.tag;
        
        if (self.sfbl)
        {
            self.sfbl = NO;
            
            personSelectViewController.aryWorkflowUsrs = [selectStep objectForKey:@"users"];
            personSelectViewController.multiUsr = selPersonItem.multiMuster;
            
            CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
            CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
            
            NSLog(@"rect = %@",NSStringFromCGRect(rect));
            
            ;
            //personSelectViewController.multiUsr = YES;
            [personSelectViewController.myTableView reloadData];
            [self.personPopoverController presentPopoverFromRect:rect
                                                          inView:self.view
                                        permittedArrowDirections:UIPopoverArrowDirectionLeft
                                                        animated:YES];
        }
               
    }
}



@end
