//
//  LaiWenSearchController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LaiWenSearchController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"
#import "LaiwenDetailController.h"

@implementation LaiWenSearchController

@synthesize resultAry,resultTableView,bHaveShowed,lxtype;
@synthesize titleField, titleLabel, searchBtn, wenHaoLabel,wenHaoField,fromDateField,fromDateLabel,endDateField,endDateLabel;
@synthesize pageCount,currentPage;
@synthesize isLoading,resultHeightAry;
@synthesize webHelper,currentTag,urlString;
@synthesize popController,dateController;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(NSString*)typeStr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.lxtype = typeStr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.titleField.hidden = NO;
    self.titleLabel.hidden = NO;
    self.wenHaoLabel.hidden = NO;
    self.wenHaoField.hidden = NO;
    self.jjcdLabel.hidden = NO;
    self.jjcdSegment.hidden = NO;
    self.fromDateField.hidden = NO;
    self.fromDateLabel.hidden = NO;
    self.endDateField.hidden = NO;
    self.endDateLabel.hidden = NO;
    self.searchBtn.hidden = NO;
}

-(void)processWebData:(NSData*)webData
{
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
        
        if (parsedItemAry == nil) {
            bParseError = YES;
        }
        else{
           // [resultAry removeAllObjects];
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
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [resultAry count];i++) {
        NSDictionary *dicTmp = [resultAry objectAtIndex:i];
        NSString *text = [dicTmp objectForKey:@"LWBT"];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:text byFont:font andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.resultHeightAry = aryTmp;
    
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


-(IBAction)btnSearchPressed:(id)sender
{
    if (!resultAry)
    {
        resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    }
    else
    {
        [resultAry removeAllObjects];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_LWLIST" forKey:@"service"];
    [params setObject:self.lxtype forKey:@"LWLX"];

    if ([titleField.text length] > 0)
    {
         [params setObject:titleField.text forKey:@"q_LWBT"];
    }
    if ([wenHaoField.text length] > 0)
    {
        [params setObject:wenHaoField.text forKey:@"q_LWWH"];
    }
    if (self.jjcdSegment.selectedSegmentIndex > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%d", self.jjcdSegment.selectedSegmentIndex] forKey:@"q_JJCD"];
    }
    if([fromDateField.text length] > 0 || [endDateField.text length] >0)
    {
        [params setObject:@"1" forKey:@"inType"];
        if ([fromDateField.text length] > 0)
        {
            [params setObject:fromDateField.text forKey:@"sDate"];
        }
        if ([endDateField.text length] > 0)
        {
            [params setObject:endDateField.text forKey:@"eDate"];
        }
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

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
	[popController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (currentTag)
        {
			case 1:
				fromDateField.text = dateString;
				break;
			case 2:
				endDateField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (currentTag)
        {
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


-(void)showSearchBar:(id)sender
{
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = resultTableView.frame;

        [aItem setTitle:@"开启查询"];
        self.titleField.hidden = YES;
        self.titleLabel.hidden = YES;
        self.wenHaoLabel.hidden = YES;
        self.wenHaoField.hidden = YES;
        self.jjcdLabel.hidden = YES;
        self.jjcdSegment.hidden = YES;
        self.fromDateField.hidden = YES;
        self.fromDateLabel.hidden = YES;
        self.endDateField.hidden = YES;
        self.endDateLabel.hidden = YES;
        self.searchBtn.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-140, origFrame.size.width, origFrame.size.height+140);        
        [UIView commitAnimations];
    }
    else
    {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"来文列表";
    
     UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar:)];
    self.navigationItem.rightBarButtonItem = aItem;
    
    UIColor *color = [UIColor colorWithRed:67.0/255 green:160.0/255 blue:179.0/255 alpha:1];
    self.jjcdSegment.tintColor = color;
   
    self.bHaveShowed = YES;
    [self showSearchBar:aItem];

    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	self.dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;

    
    self.resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_LWLIST" forKey:@"service"];
    [params setObject:self.lxtype forKey:@"LWLX"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setJjcdLabel:nil];
    [self setJjcdSegment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper)
    {
        [webHelper cancel];
    }
    if(self.popController)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [resultAry count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  查询到的来文(%d条)",[resultAry count]];
    return headerView;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[resultHeightAry objectAtIndex:indexPath.row] floatValue];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellId_laiwensearch";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];

        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

	}
    
	NSString *itemTitle = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"LWBT"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
	cell.textLabel.text = itemTitle;
    NSString *lwdate = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"LWRQ"];
    if ([lwdate length] > 9) {
        lwdate = [lwdate substringToIndex:10];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"来文日期：%@    来文单位：%@",lwdate,[[resultAry objectAtIndex:indexPath.row] objectForKey:@"LWDW"]];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
   // cell.detailTextLabel.textColor = [UIColor blueColor];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
	
    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * flag = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"SFZXXJBRFW"];
    if([flag integerValue] != 1){
        [self showAlertMessage:@"您没有权限查看此公文。"];
        return;
    }
    
    NSString *xh = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"XH"];
    LaiwenDetailController *controller = [[LaiwenDetailController alloc] initWithNibName:@"LaiwenDetailController" andLWID:xh];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (currentPage == pageCount)
        return;
	if (isLoading) {
        return;
    }
    
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",urlString, currentPage];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

@end
