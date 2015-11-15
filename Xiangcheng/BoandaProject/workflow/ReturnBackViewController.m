//
//  ReturnBackViewController.m
//  GuangXiOA
//
//  Created by zhang on 12-9-12.
//
//

#import "ReturnBackViewController.h"

#import "PDJsonkit.h"
#import "ServiceUrlString.h"



@implementation ReturnBackViewController

@synthesize bzbh,selUsrItem;
@synthesize arySteps;
@synthesize stepTableView,txtView;
@synthesize delegate,webServiceType;
@synthesize aryFilteredSteps;
@synthesize webHelper,openSection,canSignature;

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
    NSLog(@"%@",resultJSON);
    if (webServiceType == kWebService_ReturnBack) {
        NSDictionary *dicTmp = [resultJSON objectFromJSONString];
        
        if (dicTmp){
            if ([[dicTmp objectForKey:@"result"] boolValue]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"提示"
                                      message:@"退回成功！"
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
            if ([[dicTmp objectForKey:@"result"] boolValue]) {
                self.arySteps = [dicTmp objectForKey:@"parents"];
                
                NSInteger count = [arySteps count];
                if(count > 0){
                    
                    openSection = -1;
                }
                
            }
            else
                bParseError = YES;
            
        }
        else
            bParseError = YES;
        if (bParseError == NO) {
            
            self.aryFilteredSteps = [NSMutableArray arrayWithArray:arySteps];
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
}

#pragma mark - View lifecycle

-(void)requestWorkFlow{
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_BEFORE_SENDBACK" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"bzbh"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    webServiceType =  kWebService_WorkFlow;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"退回成功！"] ) {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    }
}

//回退
-(void)returnBackAction{
    
    if (selUsrItem == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请选择退回步骤和人员。"
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];

        return;
    }
    if(txtView.text == nil || txtView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请输入处理意见。"
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }

    NSString *opinion = [NSString stringWithFormat:@"%@",txtView.text];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"WORKFLOW_SENDBACK_ACTION" forKey:@"service"];
    [dicParams setObject:bzbh forKey:@"bzbh"];
    [dicParams setObject:opinion forKey:@"opinion"];
    [dicParams setObject:selUsrItem.stepID forKey:@"backStepIds"];
    NSString *paramKey = [NSString stringWithFormat:@"sdf_%@",selUsrItem.stepID ];
    [dicParams setObject:selUsrItem.userId forKey:paramKey];
    
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
      
    webServiceType = kWebService_ReturnBack;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)btnTransferPressed:(id)sender{
    [self returnBackAction];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"流转";
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"回退" style:UIBarButtonItemStyleDone target:self action:@selector(btnTransferPressed:)];
    self.navigationItem.rightBarButtonItem = barItem;

    
   

    [self requestWorkFlow];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return [aryFilteredSteps count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 60.0;
   
	return headerHeight;
}



-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 60.0;
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:section];
    NSString *title = [tmpDic objectForKey:@"stepDesc"];
    BOOL opened = NO;
    if(section == openSection){
        opened = YES;
    }
    
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc]
                                            initWithFrame:CGRectMake(0.0, 0.0, self.stepTableView.bounds.size.width, headerHeight)
                                            title:title
                                            section:section
                                            opened:opened
                                            delegate:self];
	return sectionHeadView;
}

#pragma mark - QQ section header view delegate

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    
    openSection = -1;
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [stepTableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
		[self.stepTableView reloadData];
        //  [self.stepTableView deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	openSection = section;

	[self.stepTableView reloadData];
	// 展开+动画 (如果不需要动画直接reloaddata)
    ///////////////////////////////////////////////////////////////fix
	//if(persons.indexPaths){
    //if ([persons.m_arrayPersons count] > 0)
    {
        
		//[self.processTable insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
	//persons.indexPaths = nil;
    ///////////////////////////////////////////////////////////////fix
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == openSection){
        NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:section];
        NSArray *ary = [tmpDic objectForKey:@"users"];
        return [ary count];
    }
    else
        return 0;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
	}
    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:indexPath.section];
    NSArray *ary = [tmpDic objectForKey:@"users"];
    NSDictionary *dicPerson = [ary objectAtIndex:indexPath.row];
	cell.textLabel.text = [dicPerson objectForKey:@"userName"];

    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *userId = [dicPerson objectForKey:@"userId"];
    NSString *stepId = [tmpDic objectForKey:@"stepId"];
    if ([selUsrItem.userId isEqualToString:userId] && [selUsrItem.stepID isEqualToString:stepId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
	
	return cell;
    
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *tmpDic = [aryFilteredSteps objectAtIndex:indexPath.section];
    NSArray *ary = [tmpDic objectForKey:@"users"];
    NSDictionary *dicPerson = [ary objectAtIndex:indexPath.row];
    NSString *userId = [dicPerson objectForKey:@"userId"];
    NSString *stepId = [tmpDic objectForKey:@"stepId"];

    BackStepItem *aUsrItem = [[BackStepItem alloc] init];
    aUsrItem.userId = userId;
    aUsrItem.stepID = stepId;

    self.selUsrItem = aUsrItem;

    [tableView reloadData];
    
}


@end
