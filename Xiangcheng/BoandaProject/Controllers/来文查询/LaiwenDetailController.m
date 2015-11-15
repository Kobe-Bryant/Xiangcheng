//
//  LaiwenDetailController.m
//  GuangXiOA
//
//  Created by  on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LaiwenDetailController.h"
#import "SharedInformations.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"
#import "UITableViewCell+Custom.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "ServiceUrlString.h"

@implementation LaiwenDetailController
@synthesize jbxxDic,wjxxAry,lwid,toDisplayKey,toDisplayKeyTitle,resTableView; 
@synthesize toDisplayHeightAry;
@synthesize webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil andLWID:(NSString*)idstr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.lwid = idstr;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle
-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        self.wjxxAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.jbxxDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
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

    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i=0; i< 8;i++)
    {
        CGFloat cellHeight = 60.0f;
        
        if(i>=3 )
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [jbxxDic objectForKey:[toDisplayKey objectAtIndex:i+3]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font1 andWidth:520.0]+20;
        }else{
            cellHeight = 70.0f;
        }
        
        if(cellHeight < 60) cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.toDisplayHeightAry = aryTmp;
    
    [resTableView reloadData];
}

-(void)processError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    return;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"来文详细信息";
   
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"来文日期：",@"限时办结日期：",@"来文单位：",@"来文类型：",@"来文文号：",@"紧急程度：",@"来文标题：",@"拟办意见：",@"部门意见：",@"院领导审批意见：",@"备注：",nil];
    self.toDisplayKey = [NSArray arrayWithObjects:@"LWRQ",@"XSBJRQ",@"LWDW",@"LWLX",@"LWWH",@"JJCD",@"LWBT",@"NBYJ",@"BLYJ",@"SPYJ",@"BZ", nil];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i=0; i< 12;i++)
    {
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeightAry;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_LWCONTENT" forKey:@"service"];
    [params setObject:lwid forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
       
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text = @"  来文信息";
    else  headerView.text = @"  来文附件";

    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)  return 8;
    else {
        if(wjxxAry == nil)
            return 0;
        else if ([wjxxAry count] == 0) {
            return 1;
        }
    }return [wjxxAry count];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	CGFloat nHeight = 60.0f;
    if(indexPath.section == 0){
        return [[toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        
    }
    
    return nHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	

	UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            //来文日期   限时办结日期
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:1];
            
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:0]];
            if([value1 length]>10) value1 = [value1 substringToIndex:10];
            
            NSString *value2 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:1]];
            if([value2 length]>10) value2 = [value2 substringToIndex:10];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if(indexPath.row == 1)
        {
            //来文单位 来文类型
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:2]];
            NSString *lwType = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:3]];
            NSString *value2 = [SharedInformations getLWLXFromStr:lwType];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if(indexPath.row == 2)
        {
            //来文文号 紧急程度
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:4];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:5];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:4]];
            int num = [[jbxxDic objectForKey:[toDisplayKey objectAtIndex:5]] intValue];
            NSString *value2 = [SharedInformations getJJCDFromInt:num];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else
        {
            int div = 3;
            NSString *title = [toDisplayKeyTitle objectAtIndex:indexPath.row+div];
            NSString *value = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+div]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        static NSString *identifier = @"cellLaiwenDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (wjxxAry ==nil||[wjxxAry count] == 0) {
            cell.textLabel.text = @"没有相关附件";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [wjxxAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [dicTmp objectForKey:@"WDDX"];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }


    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
  
    
	return cell;
	
    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
        if ([wjxxAry count] <= 0) {
            return;
        }

        NSDictionary *dicTmp = [wjxxAry objectAtIndex:indexPath.row];
        
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil ) {
            return;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];

        
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        
        
        [self.navigationController pushViewController:controller animated:YES];
       
    }
    
}

@end

