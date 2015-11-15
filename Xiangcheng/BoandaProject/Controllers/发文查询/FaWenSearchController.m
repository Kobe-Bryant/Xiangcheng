//
//  FaWenSearchController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FaWenSearchController.h"
#import "PDJsonkit.h"
#import "FawenDetailController.h"
#import "UsersHelper.h"
#import "ServiceUrlString.h"
@interface FaWenSearchController ()

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString;
@end
@implementation FaWenSearchController
@synthesize resultAry,resultTableView,bHaveShowed,lxtype;
@synthesize titleField,titleLabel,niwenField,niwenLabel,searchBtn,danweiDM;
@synthesize wenHaoLabel,wenHaoField;
@synthesize pageCount,currentPage,wordsPopoverController,wordsSelectViewController;
@synthesize gklxSegCtrl,gklxLabel;
@synthesize isLoading;
@synthesize webHelper,currentTag;
@synthesize fromDateField,fromDateLabel,endDateField,endDateLabel,popController,dateController,urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(NSString*)typeStr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.lxtype = typeStr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString {
    NSUInteger location = 0;
    NSUInteger length = [oldString length];
    unichar charBuffer[length];
    [oldString getCharacters:charBuffer];
    int i = 0;
    for (i = 0;i < length;i++) {
        location ++;
       
        if ([characterSet characterIsMember:charBuffer[i]]) {
            break;
        }
    }
    
    return [oldString substringWithRange:NSMakeRange(0,location)];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    titleField.hidden = NO;
    titleLabel.hidden = NO;
    niwenField.hidden = NO;
    niwenLabel.hidden = NO;
    searchBtn.hidden = NO;
    wenHaoLabel.hidden = NO;
    wenHaoField.hidden = NO;
    gklxSegCtrl.hidden = NO;
    gklxLabel.hidden = NO;
    
    fromDateField.hidden = NO;
    fromDateLabel.hidden = NO;
    endDateField.hidden = NO;
    endDateLabel.hidden = NO;
}

-(void)showSearchBar:(id)sender{
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = resultTableView.frame;
        aItem.title = @"开启查询";
        titleField.hidden = YES;
        titleLabel.hidden = YES;
        niwenField.hidden = YES;
        niwenLabel.hidden = YES;
        searchBtn.hidden = YES;
        wenHaoLabel.hidden = YES;
        gklxSegCtrl.hidden = YES;
        gklxLabel.hidden = YES;
        wenHaoField.hidden = YES;
        
        fromDateField.hidden = YES;
        fromDateLabel.hidden = YES;
        endDateField.hidden = YES;
        endDateLabel.hidden = YES;
    
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-140, origFrame.size.width, origFrame.size.height+140);        
        [UIView commitAnimations];
        
        

    }
    else{
        aItem.title = @"关闭查询";
        bHaveShowed = YES;
        CGRect origFrame = resultTableView.frame;
        
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+140, origFrame.size.width, origFrame.size.height-140);
        
        [UIView commitAnimations];
        
    }
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    self.niwenField.text = words;
    if (self.wordsPopoverController != nil) {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
}

- (void)touchDownForDepartment:(id)sender {
    UIControl *ctrl = (UIControl*)sender;

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
	[self.wordsPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)processWebData:(NSData*)webData{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic ) {
            pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
        }
        else
            bParseError = YES;
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        
        if ([parsedItemAry count]>0) {
         //   [resultAry removeAllObjects];
            [resultAry addObjectsFromArray:parsedItemAry];
        }
            
    }
    else
        bParseError = YES;
    if (bParseError) {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"获取数据出错。" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
  
        return;
        
    }
    [self.resultTableView reloadData];
    
}

-(void)processError:(NSError *)error{
    isLoading = NO;
    [self.resultTableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
 
    return;
}


-(IBAction)btnSearchPressed:(id)sender{
    if (!resultAry) {
        resultAry = [[NSMutableArray alloc] initWithCapacity:30];
        
    }
    else
        [resultAry removeAllObjects];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_FWLIST" forKey:@"service"];
    [params setObject:lxtype forKey:@"WJLX"];
    
    //WJLX=1&FWBT=q&NWDW=办&GKLX=1&WH=桂环科
    if ([titleField.text length] > 0) {
        [params setObject:titleField.text forKey:@"FWBT"];
    }
    if ([niwenField.text length] > 0) {
        [params setObject:niwenField.text forKey:@"NWDW"];
    }
    if ([wenHaoField.text length] > 0) {
        [params setObject:wenHaoField.text forKey:@"WH"];
    }
    if (gklxSegCtrl.selectedSegmentIndex > 0) {
         [params setObject:[NSString stringWithFormat:@"%d",gklxSegCtrl.selectedSegmentIndex] forKey:@"GKLX"];
    }
    if([fromDateField.text length] > 0 || [endDateField.text length] >0){
        //接收日期JRSJ  厅办收文日期SGRQ 办结日期BJRQ
        [params setObject:@"JRSJ" forKey:@"q_RQNAME"];
        if ([fromDateField.text length] > 0)
             [params setObject:fromDateField.text forKey:@"RQ1"];
        if ([endDateField.text length] > 0)
            [params setObject:endDateField.text forKey:@"RQ2"];
        
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}


-(IBAction)touchFromDate:(id)sender{
	UIControl *btn =(UIControl*)sender;
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
	
	
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date{
    [popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		
		switch (currentTag) {
			case 1:
				fromDateField.text = dateString;
				break;
			case 2:
				endDateField.text = dateString;
				break;
			default:
				break;
		}
	}else {
        switch (currentTag) {
			case 1:
				fromDateField.text = @"";
				break;
			case 2:
				endDateField.text = @"";
				break;
			default:
				break;
		}
    }
}


//不让日起textfield可以编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发文列表";
    // Do any additional setup after loading the view from its nib.
    [self.niwenField addTarget:self action:@selector(touchDownForDepartment:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar:)];
    

    self.navigationItem.rightBarButtonItem = aItem;
    
    bHaveShowed = YES;
    [self showSearchBar:aItem];
    
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	dateController.delegate = self;
	
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;

    
    resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_FWLIST" forKey:@"service"];
    [params setObject:lxtype forKey:@"WJLX"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    //WJLX=1&FWBT=q&NWDW=办&GKLX=1&WH=桂环科

    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
    UIColor *color = [UIColor colorWithRed:67.0/255 green:160.0/255 blue:179.0/255 alpha:1];
    gklxSegCtrl.tintColor = color;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    if(self.popController)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    if(self.wordsPopoverController)
    {
        [self.wordsPopoverController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableView Delegate & DataSource Methods

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
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  查询到的发文(%d条)",[resultAry count]]; 
    return headerView ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [resultAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    
	NSString *itemTitle = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"BT"];
    if (itemTitle== nil)
    {
        itemTitle = @"";
    }
	cell.textLabel.text = [self stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] oldString:itemTitle];
    NSString *lwdate = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"FWSJ"];
    if ([lwdate length] > 9)
    {
        lwdate = [lwdate substringToIndex:10];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"发文日期：%@    发布单位：%@",lwdate,[[resultAry objectAtIndex:indexPath.row] objectForKey:@"FBDW"]];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * flag = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SFZXXJBRFW"];
    if([flag integerValue] != 1){
        [self showAlertMessage:@"您没有权限查看此公文。"];
        return;
    }
    
    NSString *xh = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"XH"];
    FawenDetailController *controller = [[FawenDetailController alloc] initWithNibName:@"FawenDetailController" andFWID:xh];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentPage == pageCount)
        return;
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

@end
