//
//  SearchNoticeViewController.m
//  GuangXiOA
//
//  Created by sz apple on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchNoticeViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "UsersHelper.h"
#import "NoticeDetailsViewController.h"
#import "TingDepartmentInfoItem.h"
#import "TingDataHelper.h"

#define kTag_TZBT_Field 1 
#define kTag_ZBDW_Field 2
#define kTag_KSSJ_Field 3
#define kTag_JSSJ_Field 4

@implementation SearchNoticeViewController

@synthesize pageCount,currentTag,currentPage,isLoading,pages;
@synthesize resultAry,refreshUrl,departmentDM,typeDM;
@synthesize wordsPopoverController,wordsSelectViewController;
@synthesize webHelper,showTingData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods and delegates

- (IBAction)searchButtonPressed:(id)sender {
    [self.zbdwField resignFirstResponder];
    self.pageCount = 0;
    self.currentPage = 0;
    [resultAry removeAllObjects];
    [self.myTableView reloadData];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_TZGGLIST" forKey:@"service"];

   /* q_NGSJ1 拟办开始时间
    q_NGSJ2 拟办结束时间
    q_TZBT  通知标题
    q_ZBDWMC 主办单位名称*/
    if ([self.tzbtField.text length]>0)
    {
        [params setObject:self.tzbtField.text forKey:@"q_TZBT"];
    }
    if ([self.zbdwField.text length]>0)
    {
        [params setObject:self.zbdwField.text forKey:@"q_ZBDWMC"];
    }
    if ([self.kssjField.text length]>0)
    {
        [params setObject:self.kssjField.text forKey:@"q_NGSJ1"];
    }
    if ([self.jssjField.text length]>0)
    {
        [params setObject:self.jssjField.text forKey:@"q_NGSJ2"];
    }
    
    if(showTingData)
        self.refreshUrl = [ServiceUrlString generateTingUrlByParameters:params];
    else
        self.refreshUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:refreshUrl andParentView:self.view delegate:self];
}

- (IBAction)touchDownForDepartment:(id)sender
{
    UITextField *ctrl = (UITextField*)sender;
    ctrl.text = @"";
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(320, 400);
	tmpController.delegate = self;
    NSMutableArray *bmNameAry = [NSMutableArray arrayWithCapacity:20];
    NSArray *depAry = [[[UsersHelper alloc] init]  queryAllSubDept:@"ROOT"];
    if (depAry == nil) return;
    for (NSDictionary *aItem in depAry) {
        [bmNameAry addObject:[aItem objectForKey:@"ZZQC"]];
    }
    tmpController.wordsAry = [[NSArray alloc] initWithArray:bmNameAry];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

- (IBAction)touchDownForType:(id)sender
{
    UITextField *ctrl = (UITextField*)sender;
    ctrl.text = @"";
    currentTag = ctrl.tag;
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(150, 240);
	tmpController.delegate = self;
    
    tmpController.wordsAry = [[NSArray alloc] initWithObjects:@"审核通知公告",@"所有通知公告",@"本周通知公告", nil];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;	
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	//[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    self.zbdwField.text = words;    
    if (self.wordsPopoverController != nil)
    {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.resultAry = [NSMutableArray arrayWithCapacity:5];
    
    self.zbdwField.tag = kTag_ZBDW_Field;
    self.tzbtField.tag = kTag_TZBT_Field;
    self.kssjField.tag = kTag_KSSJ_Field;
    self.jssjField.tag = kTag_JSSJ_Field;
    
    [self searchButtonPressed:nil]; 
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    if(self.datePopoverController)
    {
        [self.datePopoverController dismissPopoverAnimated:YES];
    }
    if(self.wordsPopoverController)
    {
        [self.wordsPopoverController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  查询到的通知公告(%d条)",pageCount];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [resultAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 90;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        // cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    
    NSString *yxjStr = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"NGRMC"];
    if (!yxjStr)
        yxjStr = @"";
    
    NSString *fbdwStr = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"ZBDWMC"];
    if (!fbdwStr)
        fbdwStr = @"";
    
    NSString *fbsjStr = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"NGSJ"];
    if (!fbsjStr)
        fbsjStr = @"";
    if(fbsjStr.length > 10) fbsjStr = [fbsjStr substringToIndex:10];
    
	cell.textLabel.text = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"TZBT"];
    cell.textLabel.numberOfLines = 3;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"拟稿人：%@    主办单位：%@    拟稿时间：%@",yxjStr,fbdwStr,fbsjStr];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
	return cell;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeDetailsViewController *childView = [[NoticeDetailsViewController alloc] initWithNibName:@"NoticeDetailsViewController" bundle:nil];
    childView.tzbh = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"TZBH"];
    childView.title = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"TZBT"];
    childView.showTingData = NO;
    [self.navigationController pushViewController:childView animated:YES];
}

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic)
        {
            pageCount = [[pageInfoDic objectForKey:@"count"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
            pages = [[pageInfoDic objectForKey:@"pages"] intValue];
        }
        else
            bParseError = YES;
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        
        if ([parsedItemAry count] != 0)
        {
            [self.resultAry addObjectsFromArray:parsedItemAry];
        }
    }
    else
        bParseError = YES;
     [self.myTableView reloadData];
    if (bParseError)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"查询的通知公告不存在。" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    return;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
    
    if (currentPage == pages)
         return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
		isLoading = YES;
        
        NSString *newStrUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.refreshUrl,currentPage];

        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:newStrUrl andParentView:self.view delegate:self];
    }
}

- (IBAction)touchDownForDate:(id)sender
{
    UIControl *btn =(UIControl*)sender;
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.datePopover = tmpdate;
	self.datePopover.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.datePopover];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.datePopoverController = popover;
	[self.datePopoverController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.currentTag = btn.tag;
}

#pragma mark - PopupDateViewController Delegate Method

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
	[self.datePopoverController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (self.currentTag)
        {
			case kTag_KSSJ_Field:
				self.kssjField.text = dateString;
				break;
			case kTag_JSSJ_Field:
				self.jssjField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (self.currentTag)
        {
			case kTag_KSSJ_Field:
				self.kssjField.text = @"";
				break;
			case kTag_JSSJ_Field:
				self.jssjField.text = @"";
				break;
			default:
				break;
		}
    }
}

- (void)viewDidUnload {
    [self setTzbtField:nil];
    [self setZbdwField:nil];
    [super viewDidUnload];
}
@end
