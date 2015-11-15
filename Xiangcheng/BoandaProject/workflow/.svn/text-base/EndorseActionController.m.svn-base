//
//  EndorseActionController.m
//  TaskTransfer
//
//  Created by zhang on 12-11-16.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "EndorseActionController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"

#define kWebService_Before_Endorse   0
#define kWebService_Endorse_Action   1

#define TableView_Usr       1
#define TableView_ShortCut  2

@interface EndorseActionController ()
@property (nonatomic,strong)NSURLConnHelper *webHelper;
@property (nonatomic,assign)NSInteger webServiceType; // 0 请求流转步骤 1 流转命令
@property (nonatomic,strong)NSArray *aryUserShortCut;
@property (nonatomic,strong)NSArray *aryStepShortCut;
@property (nonatomic,strong)NSArray *aryBZUsers; //会签步骤的人员
@property (nonatomic,strong)NSMutableArray *arySelectedUsers;
@property (nonatomic,strong)NSMutableArray *arySelectedUserIDs;//选择的人员的ID
@property (nonatomic,retain)UIPopoverController* wordsPopoverController;
@property (nonatomic,retain)CommenWordsViewController* wordsSelectViewController;

@end

@implementation EndorseActionController
@synthesize bzbh,usrTableView, opinionView,selUsersTxtView;
@synthesize nextStepSegCtrl,sumOpinionSegCtrl,arySelectedUsers;
@synthesize webHelper,webServiceType,aryStepShortCut,aryUserShortCut,aryBZUsers;
@synthesize wordsPopoverController,wordsSelectViewController,canSignature,delegate;

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
    if (webServiceType == kWebService_Endorse_Action) {
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
    else{
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp && [[dicTmp objectForKey:@"result"] isEqualToString:@"success"]) {
               
               NSArray *arySteps = [dicTmp objectForKey:@"steps"];
               if([arySteps count] > 0){
                   NSDictionary *dicInStep = [arySteps objectAtIndex:0];
                   self.aryBZUsers = [dicInStep objectForKey:@"users"];

               }
            
               NSDictionary *dicUsrShortCut = [dicTmp objectForKey:@"userShortCut"];
               if(dicUsrShortCut){
                   NSArray * aryTmpUserShortCut = [dicUsrShortCut objectForKey:@"dmList"];
                   NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:5];
                   for(NSDictionary *dic in aryTmpUserShortCut)
                       [aryTmp addObject:[dic objectForKey:@"dmnr"]];
                   self.aryUserShortCut = aryTmp;
                   
               }
            

               NSDictionary *dicStepShortCut = [dicTmp objectForKey:@"stepShortCut:"];
               if(dicStepShortCut){
                   self.aryStepShortCut = [dicStepShortCut objectForKey:@"dmList"];
               }
            
              [usrTableView reloadData];
            
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

-(void)processError:(NSError *)error{
}

#pragma mark - View lifecycle

-(void)requestWorkFlow{
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_ENDORSE" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    [dicParams setObject:@"false" forKey:@"showDepartments"];
    [dicParams setObject:@"false" forKey:@"showUserGroups"];
    [dicParams setObject:@"false" forKey:@"showDepartmentRoles"];
    [dicParams setObject:@"true" forKey:@"showUserShortCut"];
    [dicParams setObject:@"true" forKey:@"showStepShortCut"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    webServiceType =  kWebService_Before_Endorse;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"加签成功！"]) {
        [self.navigationController popViewControllerAnimated:YES];
         [delegate HandleGWResult:TRUE];
    }
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

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    opinionView.text = words;
    [wordsPopoverController dismissPopoverAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"流转" style:UIBarButtonItemStyleDone target:self action:@selector(endorse:)];
    self.navigationItem.rightBarButtonItem = barItem;

    
    [self requestWorkFlow];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}


-(IBAction)endorse:(id)sender
{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_ENDORSE_ACTION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"BZBH"];
    if(self.opinionView.text.length == 0)
    {
        return;
    }
    [dicParams setObject:opinionView.text forKey:@"opinion"];
    
    NSMutableString *strUsers = [NSMutableString stringWithCapacity:20];
    
    for(NSString *name in self.arySelectedUserIDs)
        [strUsers appendFormat:@"%@#",name];
    [dicParams setObject:strUsers forKey:@"selectUsers"];
    if(nextStepSegCtrl.selectedSegmentIndex == 0)
        [dicParams setObject:@"WAIT" forKey:@"status"];
    else
        [dicParams setObject:@"FINISH" forKey:@"status"];
    
    if(sumOpinionSegCtrl.selectedSegmentIndex == 0)
        [dicParams setObject:@"ALL" forKey:@"activePoint"];
    else
        [dicParams setObject:@"SINGLE" forKey:@"activePoint"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    webServiceType = kWebService_Endorse_Action;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (tableView.tag == TableView_Usr) {
        headerView.text = @"  处理人选择";
    }
    else{
        headerView.text = @"  快捷操作";
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:231.0/255 green:240.0/255 blue:236.0/255 alpha:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView.tag == TableView_Usr) {
        NSLog(@"%d",[aryBZUsers count]);
        return [aryBZUsers count];
        
    }else{
        NSLog(@"%d",[aryStepShortCut count]);
        return [aryStepShortCut count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil) {
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
    
    if (tableView.tag == TableView_Usr) {
        NSDictionary *dic = [aryBZUsers objectAtIndex:indexPath.row];
        NSString *selUsr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]];
        if([arySelectedUsers containsObject:selUsr])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.textLabel.text = selUsr;
    }else{
        NSDictionary *dic = [aryStepShortCut objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dmnr"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
	return cell;
	
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == TableView_Usr) {
        NSDictionary *dic = [aryBZUsers objectAtIndex:indexPath.row];
        if(arySelectedUsers == nil)
        {
            self.arySelectedUsers = [NSMutableArray arrayWithCapacity:3];
            self.arySelectedUserIDs = [NSMutableArray arrayWithCapacity:3];
        }
        NSString *selUsr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]];
        NSString *selUsrID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
        if([arySelectedUsers containsObject:selUsr])
        {
            [arySelectedUsers removeObject:selUsr];
            [self.arySelectedUserIDs removeObject:selUsrID];
        }
        else
        {
            [arySelectedUsers addObject:selUsr];
            [self.arySelectedUserIDs addObject:selUsrID];
        }
        NSMutableString *strUsers = [NSMutableString stringWithCapacity:20];
        
        for(NSString *name in arySelectedUsers)
            [strUsers appendFormat:@"%@  ",name];
        selUsersTxtView.text = strUsers;
        [usrTableView reloadData];
    }else{
        NSDictionary *dic = [aryStepShortCut objectAtIndex:indexPath.row];
        opinionView.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dmnr"]];
    }
}
@end
