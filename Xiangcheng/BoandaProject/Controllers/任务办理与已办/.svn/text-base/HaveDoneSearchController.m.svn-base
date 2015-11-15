//
//  FaWenSearchController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "HaveDoneSearchController.h"
#import "PDJsonkit.h"
#import "BanLiDetailController.h"
#import "ServiceUrlString.h"
#import "FaWenBanliController.h"
#import "HaveDoneSearchController.h"
#import "SystemConfigContext.h"
#import "NoticeTaskDetailVC.h"

#define kField_LiuCheng_From_Tag 1
#define kField_LiuCheng_End_Tag 2
#define kField_BuZhou_From_Tag 3
#define kField_BuZhou_End_Tag 4
#define kField_LiuCheng_LeiXing_Tag 5


@implementation HaveDoneSearchController

@synthesize myTableView,bHaveShowed;
@synthesize popController,dateController;
@synthesize titleField,titleLabel,searchBtn;
@synthesize pageSum,currentPage;
@synthesize isLoading,currentTag,urlString;
@synthesize webHelper,gwType,rightButtonBar,segmentControlTitles;
@synthesize laiWenItemAry,faWenItemAry,neiBuShiXiangItemAry;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.titleField.hidden = NO;
    self.titleLabel.hidden = NO;
    self.lcFromDateField.hidden = NO;
    self.lcFromDateLabel.hidden = NO;
    self.lcEndDateField.hidden = NO;
    self.lcEndDateLabel.hidden = NO;
    /*self.bzFromDateField.hidden = NO;
    self.bzFromDateLabel.hidden = NO;
    self.bzEndDateField.hidden = NO;
    self.bzEndDateLabel.hidden = NO;*/
    self.lclxLabel.hidden = NO;
    self.lclxField.hidden = NO;
    self.searchBtn.hidden = NO;
}

-(void)showSearchBar:(id)sender
{
    if(self.bHaveShowed)
    {
        self.bHaveShowed = NO;
        CGRect origFrame = self.myTableView.frame;
        UIBarButtonItem* rightButton = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [rightButton setTitle:@"开启查询"];
        self.titleField.hidden = YES;
        self.titleLabel.hidden = YES;        
        self.lcFromDateField.hidden = YES;
        self.lcFromDateLabel.hidden = YES;
        self.lcEndDateField.hidden = YES;
        self.lcEndDateLabel.hidden = YES;
        /*self.bzFromDateField.hidden = YES;
        self.bzFromDateLabel.hidden = YES;
        self.bzEndDateField.hidden = YES;
        self.bzEndDateLabel.hidden = YES;  */      
        self.lclxLabel.hidden = YES;
        self.lclxField.hidden = YES;        
        self.searchBtn.hidden = YES;
    
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.1f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.myTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-100, origFrame.size.width, origFrame.size.height+100);
        [UIView commitAnimations];
    }
    else
    {
        UIBarButtonItem* rightButton = (UIBarButtonItem*)self.navigationItem.rightBarButtonItem;
        [rightButton setTitle:@"关闭查询"];
        self.bHaveShowed = YES;
        CGRect origFrame = self.myTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.1f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        self.myTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+100, origFrame.size.width, origFrame.size.height-100);
        [UIView commitAnimations];
    }
}

-(void)processWebData:(NSData*)webData
{
    self.isLoading = NO;
    if([webData length] <=0 )
    {
        [self.myTableView reloadData];
        return;
    }
    [self.aryItems removeAllObjects];
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        [self.aryItems addObjectsFromArray:tmpParsedJsonAry];
    }
    else
        bParseError = YES;
    if (bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据出错。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [myTableView reloadData];
}

-(void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self.myTableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"提示"  message:@"请求数据失败." delegate:self  cancelButtonTitle:@"确定"  otherButtonTitles:nil];
    [alert show];
    [self.myTableView reloadData];
    return;
}

-(IBAction)btnSearchPressed:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    //1 发文  2 来文  3通知公告  4采购申请  5用车申请  6文印申请   7出差申请  8请假申请 
    if(self.lclxField.text.length > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%d", self.gwType] forKey:@"gwType"];
    }
    if ([titleField.text length] > 0)
    {
        //任务信息
        [params setObject:titleField.text forKey:@"q_DWMC"];
    }
    if ([self.lcFromDateField.text length] > 0)
    {
        //业务开始时间
        [params setObject:self.lcFromDateField.text forKey:@"q_BEGIN"];
    }
    if ([self.lcEndDateField.text length] > 0)
    {
        //业务结束时间
        [params setObject:self.lcEndDateField.text forKey:@"q_END"];
    }
    /*if ([self.bzFromDateField.text length] > 0)
    {
        //步骤开始时间
        [params setObject:self.bzFromDateField.text forKey:@"q_BZBEGIN"];
    }
    if ([self.bzEndDateField.text length] > 0)
    {
        //步骤结束时间
        [params setObject:self.bzEndDateField.text forKey:@"q_BZEND"];
    }*/
    isLoading = YES;
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}



-(void)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipe];
    self.title = @"已办任务";
    //1 发文  2 来文  3通知公告  4采购申请  5用车申请  6文印申请   7出差申请  8请假申请
    self.gwType = 1;
    self.aryItems = [[NSMutableArray alloc] init];

    /*segmentControlTitles = [NSArray arrayWithObjects:@"来文",@"发文",@"内部事项", nil];
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc] initWithItems:segmentControlTitles];
    segmentCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentCtrl.selectedSegmentIndex = 0;
    [segmentCtrl addTarget:self action:@selector(onTitleChangeClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentCtrl;*/
    
    self.lcFromDateField.tag = kField_LiuCheng_From_Tag;
    self.lcEndDateField.tag = kField_LiuCheng_End_Tag;
    self.lclxField.tag = kField_LiuCheng_LeiXing_Tag;
    
//    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStyleBordered target:self action:@selector(showSearchBar:)];
//    self.navigationItem.rightBarButtonItem = aItem;
//    bHaveShowed = YES;
//    [self showSearchBar:aItem];
    
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	self.dateController.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
    NSArray *gwTmpTypeAry = [NSArray arrayWithObjects:@"发文登记",@"来文登记",@"通知公告", nil];
    self.gwTypeAry = gwTmpTypeAry;
    CommenWordsViewController *tmpWord = [[CommenWordsViewController alloc]init];
    self.wordsController = tmpWord;
    self.wordsController.contentSizeForViewInPopover = CGSizeMake(200, 380);
    self.wordsController.delegate = self;
    self.wordsController.wordsAry = self.gwTypeAry;
    UIPopoverController *tmpWordPopover = [[UIPopoverController alloc] initWithContentViewController:self.wordsController];
	self.wordPopController = tmpWordPopover;
   
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_WAITTASK_DONE" forKey:@"service"];
    [params setObject:@"FIND_LIST" forKey:@"ACTION_TYPE"];
    [params setObject:@"DONE" forKey:@"type"];
    //NSString *strUrl = @"http://222.92.101.82:8008/xcoa_test/invoke?version=1.0&imei=356242050024965&clientType=IPAD&userid=GF&password=1&P_PAGESIZE=25&service=QUERY_WAITTASK_DONE&ACTION_TYPE=FIND_LIST&type=DONE";
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark -

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(self.popController)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    if(self.wordPopController)
    {
        [self.wordPopController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(isLoading)
    {
        return nil;
    }
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  查询到的已办任务(%d条)", self.aryItems.count];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.aryItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
	NSString *itemTitle = [[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"B_DWMC"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
    //cell.textLabel.text = itemTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时间：%@    步骤名称：%@",[[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"KSSJ"],[[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"BZMC"]];
    
    NSString *strLCBH = [[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"LCLXBH"];
    if ([strLCBH isEqualToString:kFaWen_Type_Tag])
    {
        //发文
        itemTitle = [[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"DWDZ"];
        if(itemTitle == nil) itemTitle = @"";
        cell.textLabel.text = [NSString stringWithFormat:@"%@【发文】", itemTitle];
        cell.imageView.image = [UIImage imageNamed:@"fw.png"];
    }
    else if ([strLCBH isEqualToString:kLaiWen_Type_Tag])
    {
        //来文
        cell.textLabel.text = [NSString stringWithFormat:@"%@【来文】", itemTitle];
        cell.imageView.image = [UIImage imageNamed:@"lw.png"];
    }
    else if ([strLCBH isEqualToString:kNotice_Type_Tag])
    {
        //通知公告
        cell.textLabel.text = [NSString stringWithFormat:@"%@【通知公告】", itemTitle];
        cell.imageView.image = [UIImage imageNamed:@"tzgg.png"];
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   	cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.aryItems == nil || [self.aryItems count] <= indexPath.row)
    {
        NSLog(@"parsedItemAry error in BanliCOntroller");
    }
    NSDictionary *tmpDic = [self.aryItems objectAtIndex:indexPath.row];
    NSLog(@"将要传入详细界面的字典为====%@",tmpDic);
    NSString *lclxbh = [tmpDic objectForKey:@"LCLXBH"];
    NSString *dwmc = [tmpDic objectForKey:@"B_DWMC"];
    if ([lclxbh isEqualToString:kFaWen_Type_Tag])
    {
        //发文
        FaWenBanliController *controller = [[FaWenBanliController alloc] initWithNibName:@"FaWenBanliController" andParams:tmpDic isBanli:NO];
        controller.title = dwmc;
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([lclxbh isEqualToString:kLaiWen_Type_Tag])
    {
        //来文
        BanLiDetailController *controller = [[BanLiDetailController alloc] initWithNibName:@"BanLiDetailController" andParams:tmpDic isBanli:NO];
        controller.title = dwmc;
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([lclxbh isEqualToString:kNotice_Type_Tag])
    {
        //通知公告
        NoticeTaskDetailVC *controller = [[NoticeTaskDetailVC alloc] initWithNibName:@"NoticeTaskDetailVC" andParams:tmpDic isBanli:YES];
        controller.title = dwmc;
        [self.navigationController pushViewController:controller animated:YES ];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentPage == pageSum)
    {
        return;
    }
    if (isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",urlString, currentPage];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

#pragma mark - Touch Event Handler

-(IBAction)touchFromDate:(id)sender
{
	UIControl *btn =(UIControl*)sender;
	[self.popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.currentTag = btn.tag;
}

-(IBAction)touchFromType:(id)sender
{
    UIControl *btn =(UIControl*)sender;
	[self.wordPopController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	self.currentTag = btn.tag;
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    [self.wordPopController dismissPopoverAnimated:YES];
    if(self.currentTag == kField_LiuCheng_LeiXing_Tag)
    {
        self.lclxField.text = words;
        self.gwType = row + 1;
    }
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
	[self.popController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (self.currentTag)
        {
			case kField_LiuCheng_From_Tag:
				self.lcFromDateField.text = dateString;
				break;
            case kField_LiuCheng_End_Tag:
				self.lcEndDateField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (self.currentTag)
        {
			case kField_LiuCheng_From_Tag:
				self.lcFromDateField.text = @"";
				break;
            case kField_LiuCheng_End_Tag:
				self.lcEndDateField.text = @"";
				break;
			default:
				break;
		}
    }
}

@end
