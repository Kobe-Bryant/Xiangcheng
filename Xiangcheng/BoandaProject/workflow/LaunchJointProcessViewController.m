//
//  LaunchJointProcessViewController.m
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LaunchJointProcessViewController.h"
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
/**抄送读者 只能查看业务的信息没有修改，编辑删除的功能 不能决定流程的走向*/
//MIXTURE;
/** 一个主办 + 多个协办 + 多个抄送的处理模式 */

#define SINGLE_MASTER 1
#define MULTI_MASTER  2
#define HELPER  3
#define READER  4
#define MIXTURE 5
#define Choose_Collection_Person 6

@interface LaunchJointProcessViewController()
@property (nonatomic,strong) NSArray *arySteps;
@property(nonatomic,strong)NSURLConnHelper *webHelper;

@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令
@property(nonatomic,assign) NSInteger processTypeIntValue;
@property(nonatomic,strong) SelectedPersonItem *selPersonItem;
//选择的步骤，目前仅仅支持选择单个步骤
@property(nonatomic,strong) NSDictionary* selectStep;

@property (nonatomic, retain) UIPopoverController* wordsPopoverController;
@property (nonatomic, retain) CommenWordsViewController* wordsSelectViewController;
@property(nonatomic,strong)NSArray *aryUserShortCut;
@property(nonatomic,strong)NSArray *aryStepShortCut;
@property (nonatomic, retain) UIPopoverController* personPopoverController;
@property (nonatomic, retain) UISelectPersonVC* personSelectViewController;

@property(nonatomic, copy)NSDictionary *collectPersonDic;
@property(nonatomic, assign) int currentClickButton;
@property(nonatomic, copy) NSString* collectionPersonId;
@property(nonatomic, copy) NSString* collectionPersonName;
@end



@implementation LaunchJointProcessViewController
@synthesize bzbh,hbbzbh;
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
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




-(void)processWebData:(NSData*)webData{

    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    if (webServiceType == kWebService_Transfer) {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp){
            if ([[dicTmp objectForKey:@"result"] isEqualToString:@"true"]) {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"提示" 
                                      message:@"办理成功"
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

        if (dicTmp && [[dicTmp objectForKey:@"result"] isEqualToString:@"success"]) {
            //步骤
            self.arySteps = [dicTmp objectForKey:@"steps"];
            if ([arySteps count] > 0) {
                self.selectStep = [arySteps objectAtIndex:0];
                [self updateSelectStep];
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

-(void)requestWorkFlow{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_JOINT_PROCESS" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    [dicParams setObject:hbbzbh forKey:@"selectSteps"];
    //usergroup department暂时没有做，不请求对应数据
     [dicParams setObject:@"false" forKey:@"showUserGroups"];
     [dicParams setObject:@"false" forKey:@"showDepartments"];
    [dicParams setObject:@"true" forKey:@"showUserShortCut"];
    [dicParams setObject:@"true" forKey:@"showStepShortCut"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];

    webServiceType =  kWebService_WorkFlow;
   self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"办理成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    } 
}


//流转
-(void)transferToNextStep{
    if([selPersonItem.arySelectedMainUsers count] <=0 )
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
                              message:@"请输入办理意见."
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
    for (NSDictionary *dic in selPersonItem.arySelectedMainUsers) {
        if(firstUsr){
            [selectUsers appendFormat:@"%@",[dic objectForKey:@"userId"]];
            firstUsr = NO;
        }else{
            [selectUsers appendFormat:@"#%@",[dic objectForKey:@"userId"]];
        }
        
    }
    
    firstUsr=YES;
    for (NSDictionary *dic in selPersonItem.arySelectedHelperUsers) {
        if(firstUsr){
            [selectHelpers appendFormat:@"%@",[dic objectForKey:@"userId"]];
            firstUsr = NO;
        }else{
            [selectHelpers appendFormat:@"#%@",[dic objectForKey:@"userId"]];
        }
        
    }
    firstUsr=YES;
    for (NSDictionary *dic in selPersonItem.arySelectedReaderUsers) {
        if(firstUsr){
            [selectReaders appendFormat:@"%@",[dic objectForKey:@"userId"]];
            firstUsr = NO;
        }else{
            [selectReaders appendFormat:@"#%@",[dic objectForKey:@"userId"]];
        }
        
    }
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];

    
    if(collectSwitch.isOn){
        [dicParams setObject:@"1" forKey:@"isCollect"];
        [dicParams setObject:[collectPersonDic objectForKey:@"userId"] forKey:@"opinionProcessor"];
    }else
        [dicParams setObject:@"0" forKey:@"isCollect"];
    
    [dicParams setObject:@"WORKFLOW_JOINT_PROCESS_ACTION" forKey:@"service"];
    NSString *opinion = [NSString stringWithFormat:@"%@",opinionView.text];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    [dicParams setObject:opinion forKey:@"opinion"];
    [dicParams setObject:[selectStep objectForKey:@"stepId"] forKey:@"selectSteps"];
    [dicParams setObject:selectUsers forKey:@"selectUsers"];
    [dicParams setObject:selectHelpers forKey:@"selectHelpers"];
    [dicParams setObject:selectReaders forKey:@"selectReaders"];
    if (canSignature) {
        [dicParams setObject:[NSString stringWithFormat:@"%d",signSegCtrl.selectedSegmentIndex] forKey:@"signature"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    webServiceType = kWebService_Transfer;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)btnTransferPressed:(id)sender{
    [self transferToNextStep];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
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
    }
    else
    {
        opinionView.text = words;
    }
    [wordsPopoverController dismissPopoverAnimated:YES];
}

-(IBAction)btnPersonShortCutPressed:(id)sender{
    if(wordsPopoverController == nil){
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

-(IBAction)btnStepShortCutPressed:(id)sender{
    if(wordsPopoverController == nil){
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"流转" style:UIBarButtonItemStyleDone target:self action:@selector(btnTransferPressed:)];
    self.navigationItem.rightBarButtonItem = barItem;

    
    self.title = @"流转";    
    self.selPersonItem = [[SelectedPersonItem alloc] init];
    selPersonItem.multiMuster = NO;
    selPersonItem.showHelper = NO;
    selPersonItem.showReader = NO;
   
    [self requestWorkFlow];
 
    collectPersonBtn.tag = Choose_Collection_Person;
    [collectPersonBtn addTarget:self action:@selector(chooseCollectPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)chooseCollectPersonClick:(id)sender
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark
#pragma mark UISelPeronViewDelegate

-(void)returnSelectedPersons:(NSArray*)ary andPersonType:(NSInteger)personType{
    if (personType == kPersonType_Master) {
        selPersonItem.arySelectedMainUsers = ary;
    }else if(personType == kPersonType_Reader) {
        selPersonItem.arySelectedReaderUsers = ary;
    }
    else if(personType == kPersonType_Helper) {
        selPersonItem.arySelectedHelperUsers = ary;
    }
    [usrTableView reloadData];
    [personPopoverController dismissPopoverAnimated:YES];
}




-(void)selectPerson:(id)sender{
    
    
    if(personPopoverController == nil){
        
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(tableView.tag == TableView_Step)
        return 1;
    else{
        if (processTypeIntValue == SINGLE_MASTER || processTypeIntValue == MULTI_MASTER) {
            return 1;
        }
        else if(processTypeIntValue == READER || processTypeIntValue == HELPER)
            return 2;
        else
            return 3;    
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
        [headerView addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(selectPerson:) forControlEvents:UIControlEventTouchUpInside];
        
        if(section == 0){
            if(selPersonItem.multiMuster)
                titleView.text = [NSString stringWithFormat:@"主办人员(可多选)"];
            else
                titleView.text = [NSString stringWithFormat:@"主办人员(单选)"];
            btnAdd.tag = kPersonType_Master;
        }else if(section == 1){
            if(processTypeIntValue == READER){
                titleView.text = [NSString stringWithFormat:@"传阅人员"];
                btnAdd.tag = kPersonType_Reader;
            }
            else{
                titleView.text = [NSString stringWithFormat:@"协办人员"];
                btnAdd.tag = kPersonType_Helper;
            }
            

                
        }else{
            titleView.text = [NSString stringWithFormat:@"传阅人员"];
            btnAdd.tag = kPersonType_Reader;
        }
        
        
        
        return headerView;
    }
   
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableView.tag == TableView_Step){
        return [arySteps count];
    }
    else{
        if(section == 0){

            return [selPersonItem.arySelectedMainUsers count];
        }else if(section == 1){
            if(processTypeIntValue == READER)
                return [selPersonItem.arySelectedReaderUsers count];
            else
                return [selPersonItem.arySelectedHelperUsers count];
        }else{
            return [selPersonItem.arySelectedReaderUsers count];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 40;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255  blue:242.0/255  alpha:1];
   // if(indexPath.row%2 == 0)
    //    cell.backgroundColor = LIGHT_BLUE_UICOLOR;
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
    
    if(tableView.tag == TableView_Step){
        NSDictionary *tmpDic = [arySteps objectAtIndex:indexPath.row];
        cell.textLabel.text = [tmpDic objectForKey:@"stepDesc"];
        if ([tmpDic isEqual:selectStep]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        if(indexPath.section == 0){
            NSDictionary *tmpDic = [selPersonItem.arySelectedMainUsers objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [tmpDic objectForKey:@"userName"];
        }else if(indexPath.section == 1){
            if(processTypeIntValue == READER){
                NSDictionary *tmpDic = [selPersonItem.arySelectedReaderUsers objectAtIndex:indexPath.row];
                cell.textLabel.text = [tmpDic objectForKey:@"userName"];
            }
            else{
                NSDictionary *tmpDic = [selPersonItem.arySelectedHelperUsers objectAtIndex:indexPath.row];
                cell.textLabel.text = [tmpDic objectForKey:@"userName"];
            }
        }else{
            NSDictionary *tmpDic = [selPersonItem.arySelectedReaderUsers objectAtIndex:indexPath.row];
            cell.textLabel.text = [tmpDic objectForKey:@"userName"];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    

	
	return cell;
    
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

-(void)updateSelectStep{
    //根据不同processType来选择对应的各种类型人员
    self.processType = [selectStep objectForKey:@"processType"];
    if([processType isEqualToString:@"SINGLE_MASTER"] ){
        processTypeIntValue = SINGLE_MASTER;
        selPersonItem.multiMuster = NO;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = NO;
    }
    else if([processType isEqualToString:@"MULTI_MASTER"] ){
        processTypeIntValue = MULTI_MASTER;
        selPersonItem.multiMuster = YES;
        selPersonItem.showHelper = NO;
        selPersonItem.showReader = NO;
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
    else
        processTypeIntValue = -1;
    
    

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
    
    [collectPersonBtn setTitle:[collectPersonDic objectForKey:@"userName"] forState:UIControlStateNormal];
    
    
    [stepTableView reloadData];
    [usrTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag== TableView_Step) {
        self.selectStep = [arySteps objectAtIndex:indexPath.row];
        
        
        [self updateSelectStep];
    }
}


@end
