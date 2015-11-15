//
//  FawenDetailController.m
//  GuangXiOA
//
//  Created by  on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FawenDetailController.h"
#import "PDJsonkit.h"
#import "SharedInformations.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "NSStringUtil.h"
#import "NSString+MD5Addition.h"
#import "FileUtil.h"
#import "ServiceUrlString.h"

@interface FawenDetailController ()

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString;

@end

@implementation FawenDetailController

@synthesize toDisplayKey,toDisplayKeyTitle,bsgwFilesAry,isHaveZSGW,jbxxDic,fwid,resTableView;
@synthesize toDisplayHeightAry,zsgwFilesAry;
@synthesize webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil andFWID:(NSString*)idstr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.fwid = idstr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, imag etc that aren't in use.
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

#pragma mark - View lifecycle
-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        self.bsgwFilesAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.jbxxDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        self.zsgwFilesAry = [[tmpParsedJsonAry lastObject] objectForKey:@"sczsgw"];
        self.isHaveZSGW = [[jbxxDic objectForKey:@"ZSGWPATH"] length] > 0;

        
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
    NSMutableArray *aryTmp1 = [[NSMutableArray alloc] initWithCapacity:13];
    for (int i=0; i< 13;i++)
    {
        CGFloat cellHeight = 60.0f;
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [jbxxDic objectForKey:[toDisplayKey objectAtIndex:i]]];
        cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font1 andWidth:520.0]+20;
        if(cellHeight < 60) cellHeight = 60.0f;
        [aryTmp1 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.toDisplayHeightAry = aryTmp1;

    
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
    self.title =@"发文详细信息";
    

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_FWCONTENT" forKey:@"service"];
    [params setObject:fwid forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];

    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    

    self.toDisplayKey = [NSArray arrayWithObjects:@"YLDSHYJ",@"BMSHYJ",@"BGSFZRSHYJ",@"XBBMBLYJ",@"GKLX",@"NWDWNGR",@"NGSJ",@"XDR",@"ZS",@"CB",@"CS",@"WHMC",@"BT",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"签发人：",@"会签部门意见：",@"部门核稿：",@"办公室核稿意见：",@"信息是否公开：",@"拟办部门和拟稿人：",@"拟稿时间：",@"校对人：",@"主送：",@"抄报：",@"抄送：",@"文号：",@"文件标题：",nil];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i=0; i< 15;i++)
    {
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeightAry;
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
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)   headerView.text = @"  发文信息";
    else if (section == 1)  headerView.text = @"  上传报送公文";
    else   headerView.text = @"  正式打印公文";
    return headerView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)  return 13;
    else if (section == 1)
    {
        if(bsgwFilesAry == nil)
            return 0;
        else if ([bsgwFilesAry count] == 0) {
            return 1;
        }
        return [bsgwFilesAry count];
    }
    else  {//只要一条正式公文
        if(isHaveZSGW)
            return [zsgwFilesAry count]+1;
        else
            return [zsgwFilesAry count];

    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	if(indexPath.section == 0){
            return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 4)
        {
            //信息是否公开
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:4];
            
            int gklx = [[jbxxDic objectForKey:[self.toDisplayKey objectAtIndex:4]] intValue];
            
            NSString *value = [SharedInformations getGKLXFromInt:gklx];
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
        }
        else if (indexPath.row == 6)
        {
            //信息是否公开
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:6];
            
            NSString *ngsj = [jbxxDic objectForKey:[self.toDisplayKey objectAtIndex:6]];
            if([ngsj length] > 10)
                ngsj = [ngsj substringToIndex:10];
            
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:ngsj andHeight:nHeight];
        }
        else if (indexPath.row == 11)
        {
            
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row];
            NSString *WHMC =  [self.jbxxDic objectForKey:@"WHMC"];
            NSString *WHNF =  [self.jbxxDic objectForKey:@"WHNF"];
            NSNumber *WHSZ =  [self.jbxxDic objectForKey:@"WHSZ"];
            NSString *value = [NSString stringWithFormat:@"%@[%@]%@号",WHMC,WHNF,WHSZ];
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
        }
        else
        {
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row];
            NSString *value = @"";
            if([self.jbxxDic objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row]] != nil)
            {
                value = [NSString stringWithFormat:@"%@", [self.jbxxDic objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row]]];
            }
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else {
        static NSString *identifier = @"cellFawenDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if(indexPath.section == 1){
            
            if (bsgwFilesAry ==nil||[bsgwFilesAry count] == 0)
            {
                cell.textLabel.text = @"没有相关附件";
            }
            else
            {
                NSDictionary *dicTmp = [bsgwFilesAry   objectAtIndex:indexPath.row];
                cell.textLabel.text = [dicTmp objectForKey:@"WDMC"];
                NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
                cell.imageView.image = [FileUtil imageForFileExt:pathExt];
                cell.detailTextLabel.text =  [dicTmp objectForKey:@"WDDX"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else if(indexPath.section == 2){
            int indexRow = indexPath.row;
            BOOL flag = NO;
            if(isHaveZSGW ==NO){
                flag = YES;
            }else{
                if(indexPath.row == 0){
                    NSString *title = [NSString stringWithFormat:@"%@.pdf",[jbxxDic objectForKey:@"WJMC"]];
                    NSString *title1 = [self stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] oldString:title];
                    cell.textLabel.text = title1;
                    cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                   flag = YES;
                    indexRow += 1;//第一条显示的是正式公文pdf
                }
            }
            if(flag == YES)
            {
                if(indexRow < [zsgwFilesAry count]){
                    NSDictionary *dicTmp = [zsgwFilesAry   objectAtIndex:indexRow];
                    cell.textLabel.text = [dicTmp objectForKey:@"WDMC"];
                    NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
                    cell.imageView.image = [FileUtil imageForFileExt:pathExt];
                    cell.detailTextLabel.text = [dicTmp objectForKey:@"WDDX"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
            }
        }
        
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
        if ([bsgwFilesAry count] <= 0) {
            return;
        }

        NSDictionary *dicTmp = [bsgwFilesAry objectAtIndex:indexPath.row];
        
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
    else if(indexPath.section == 2){

        if(isHaveZSGW && indexPath.row == 0){
            NSString *xh = [jbxxDic objectForKey:@"XH"];
            NSString *fileName= [NSString stringWithFormat:@"%@.pdf",[jbxxDic objectForKey:@"WH"]];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
            [params setObject:@"DOWN_OA_FWZSGW" forKey:@"service"];
            [params setObject:xh forKey:@"xh"];
            NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
            
            DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:fileName];
            
            
            [self.navigationController pushViewController:controller animated:YES];

        }
        else{
            if ([zsgwFilesAry count] <= 0) {
                return;
            }
            
            NSDictionary *dicTmp = [zsgwFilesAry objectAtIndex:indexPath.row];
            
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
}

@end
