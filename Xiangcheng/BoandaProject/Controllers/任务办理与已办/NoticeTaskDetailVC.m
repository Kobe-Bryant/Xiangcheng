//
//  NoticeTaskDetailVC.m
//  BoandaProject
//
//  Created by 张仁松 on 13-8-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "NoticeTaskDetailVC.h"
#import "ToDoActionsDataModel.h"
#import "SharedInformations.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"
#import "UsersHelper.h"
#import "ServiceUrlString.h"
#import "FileUtil.h"

@interface NoticeTaskDetailVC ()
@property (nonatomic,strong) NSArray *toDisplayKey;//发文信息所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property(nonatomic,strong) NSMutableArray *toDisplayHeightAry;

@property (nonatomic,strong) NSArray *stepAry;      //发文步骤
@property (nonatomic,strong) NSArray *stepHeightAry;      //步骤的高度
@property (nonatomic,strong) NSArray *attachmentAry; //发文附件

@property (nonatomic,strong) NSDictionary *infoDic; //来文信息
@property (nonatomic,strong) IBOutlet UITableView *resTableView;

@property(nonatomic,strong)NSURLConnHelper *webHelper;
@property(nonatomic,strong)ToDoActionsDataModel *actionsModel;

@property (nonatomic,strong) UsersHelper *usersHelper;
@end

@implementation NoticeTaskDetailVC
@synthesize isHandle,itemParams,toDisplayHeightAry,toDisplayKeyTitle;
@synthesize toDisplayKey,stepAry,stepHeightAry,attachmentAry,infoDic,resTableView,webHelper,actionsModel;

- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.itemParams = item;
        isHandle = isToBanLi;
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
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        
        self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"tzggbz"];
        
        self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        
        
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
    NSMutableArray *aryTmp1 = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i=0; i< [toDisplayKeyTitle count]-1;i++)
    {
        CGFloat cellHeight = 60.0f;
        if(i < 3)
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font1 andWidth:520.0]+20;
        }
        else if(i == 3 )
        {
            cellHeight = 60.0f;
        }
        else
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i+1]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font1 andWidth:520.0]+20;
        }
        if(cellHeight < 60) cellHeight = 60.0f;
        [aryTmp1 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.toDisplayHeightAry = aryTmp1;

    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [stepAry count];i++) {
        NSDictionary *dicTmp = [stepAry   objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@",
                          [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700] + 30.0;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.stepHeightAry = aryTmp2;
    
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
    
    // Do any additional setup after loading the view from its nib.
    
    self.toDisplayKey = [NSArray arrayWithObjects:@"TZBT",@"TZNR",@"ZBDWMC",@"NGRMC",@"NGSJ",@"SHYJ",@"CBYJ",@"ZGSSHYJ",@"YBSHYJ",@"QFYJ",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"通知标题：",@"内容：",@"主办单位：",@"拟稿人：",@"拟稿时间：",@"部门领导审核意见：",@"副总工程师承办意见：",@"总工室审核意见：",@"院办审核意见：",@"院领导签发意见：",nil];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i=0; i< 15;i++)
    {
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeightAry;
    self.usersHelper = [[UsersHelper alloc] init];
    NSString *strUrl = nil;
    if (isHandle) {
        
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_TZGGCONTENTINFO" forKey:@"service"];
    [params setObject:[itemParams objectForKey:@"LCSLBH"] forKey:@"LCSLBH"];
    strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    self.bOKFromTransfer = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.webHelper) {
        [self.webHelper cancel];
    }
    [super viewWillDisappear:animated];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text= @"  基本信息";
    else if (section == 1)  headerView.text= @"  附件";
    else  headerView.text= @"  处理步骤";
   
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 )
    {
        return [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
    }
    else if (indexPath.section == 1 )
    {
        return 80;
    }
    else if(indexPath.section == 0)
    {
        return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0 )
    {
        return 9;
    }
    else if (section == 1)
    {
        return (self.attachmentAry.count > 0 && self.attachmentAry) ? self.attachmentAry.count : 1;
    }
    else 
    {
        if(self.stepAry ==nil)
            return 0;
        else if ( [self.stepAry count] == 0) {
            return 1;
        }
        else
            return [self.stepAry count];
    }
   
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if(indexPath.row == 3)
        {
            //发文文号 发文时间 0 0，1
            NSString *title1 = [self.toDisplayKeyTitle objectAtIndex:3];
            NSString *title2 = [self.toDisplayKeyTitle objectAtIndex:4];
            NSString *value1 = [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:3]];
            NSString *value2 = [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:4]];
            if([value2 length] > 10)
                value2 = [value2 substringToIndex:10];
                
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:nHeight];
        }
        else if(indexPath.row < 3)
        {
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row];
            NSString *value = [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row]];
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
        }else{
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row+1];
             NSString *value = @"";
            if(indexPath.row == 4){
                NSString *SHYJ = [self.infoDic objectForKey:@"SHYJ"];
                NSString *SHR = [self.infoDic objectForKey:@"SHR"];
                NSString *SHSJ = [self.infoDic objectForKey:@"SHSJ"];
                value = [NSString stringWithFormat:@"%@ %@ %@",SHYJ,SHR,SHSJ];
            }else if(indexPath.row == 5){
                NSString *SHYJ = [self.infoDic objectForKey:@"CBYJ"];
                NSString *SHR = [self.infoDic objectForKey:@"CBR"];
                NSString *SHSJ = [self.infoDic objectForKey:@"CBSJ"];
                value = [NSString stringWithFormat:@"%@ %@ %@",SHYJ,SHR,SHSJ];
            }
            else if(indexPath.row == 6){
                NSString *SHYJ = [self.infoDic objectForKey:@"ZGSSHYJ"];
                NSString *SHR = [self.infoDic objectForKey:@"ZGSSHR"];
                NSString *SHSJ = [self.infoDic objectForKey:@"ZGSSHSJ"];
                value = [NSString stringWithFormat:@"%@ %@ %@",SHYJ,SHR,SHSJ];
            }
            else if(indexPath.row == 7){
                NSString *SHYJ = [self.infoDic objectForKey:@"YBSHYJ"];
                NSString *SHR = [self.infoDic objectForKey:@"YBSHR"];
                NSString *SHSJ = [self.infoDic objectForKey:@"YBSHSJ"];
                value = [NSString stringWithFormat:@"%@ %@ %@",SHYJ,SHR,SHSJ];
            }
            else if(indexPath.row == 8){
                NSString *SHYJ = [self.infoDic objectForKey:@"QFYJ"];
                NSString *SHR = [self.infoDic objectForKey:@"QFR"];
                NSString *SHSJ = [self.infoDic objectForKey:@"QFSJ"];
                value = [NSString stringWithFormat:@"%@ %@ %@",SHYJ,SHR,SHSJ];
            }
                
            
            if(indexPath.row == 4)
            {
                NSString *shyj = [self.infoDic objectForKey:@"SHYJ"];
                if(shyj == nil) shyj = @"";
                NSString *shr = [self.infoDic objectForKey:@"SHR"];
                if(shr == nil) shr = @"";
                shr = [self.usersHelper queryUserNameByID:shr];
                NSString *shsj = [self.infoDic objectForKey:@"SHSJ"];
                if(shsj == nil) shsj = @"";
                value = [NSString stringWithFormat:@"%@ %@ %@", shyj, shr, shsj];
            }
            else if(indexPath.row == 5)
            {
                NSString *shyj = [self.infoDic objectForKey:@"CBYJ"];
                if(shyj == nil) shyj = @"";
                NSString *shr = [self.infoDic objectForKey:@"CBR"];
                if(shr == nil) shr = @"";
                shr = [self.usersHelper queryUserNameByID:shr];
                NSString *shsj = [self.infoDic objectForKey:@"CBSJ"];
                if(shsj == nil) shsj = @"";
                value = [NSString stringWithFormat:@"%@ %@ %@", shyj, shr, shsj];
            }
            else if(indexPath.row == 6)
            {
                NSString *shyj = [self.infoDic objectForKey:@"ZGSSHYJ"];
                if(shyj == nil) shyj = @"";
                NSString *shr = [self.infoDic objectForKey:@"ZGSSHR"];
                if(shr == nil) shr = @"";
                shr = [self.usersHelper queryUserNameByID:shr];
                NSString *shsj = [self.infoDic objectForKey:@"ZGSSHSJ"];
                if(shsj == nil) shsj = @"";
                value = [NSString stringWithFormat:@"%@ %@ %@", shyj, shr, shsj];
            }
            else if(indexPath.row == 7)
            {
                NSString *shyj = [self.infoDic objectForKey:@"YBSHYJ"];
                if(shyj == nil) shyj = @"";
                NSString *shr = [self.infoDic objectForKey:@"YBSHR"];
                if(shr == nil) shr = @"";
                shr = [self.usersHelper queryUserNameByID:shr];
                NSString *shsj = [self.infoDic objectForKey:@"YBSHSJ"];
                if(shsj == nil) shsj = @"";
                value = [NSString stringWithFormat:@"%@ %@ %@", shyj, shr, shsj];
            }
            else if(indexPath.row == 8)
            {
                NSString *shyj = [self.infoDic objectForKey:@"QFYJ"];
                if(shyj == nil) shyj = @"";
                NSString *shr = [self.infoDic objectForKey:@"QFR"];
                if(shr == nil) shr = @"";
                shr = [self.usersHelper queryUserNameByID:shr];
                NSString *shsj = [self.infoDic objectForKey:@"QFSJ"];
                if(shsj == nil) shsj = @"";
                value = [NSString stringWithFormat:@"%@ %@ %@", shyj, shr, shsj];
            }
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier = @"fujiancell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (self.attachmentAry ==nil||[self.attachmentAry count] == 0)
        {
            cell.textLabel.text = @"没有相关附件";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [self.attachmentAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else 
    {
        if (self.stepAry ==nil||[self.stepAry count] == 0)
        {
            static NSString *identifier = @"fujiancell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
                cell.textLabel.numberOfLines = 0;
            }
            cell.textLabel.text = @"没有相关处理步骤";
        }
        else
        {
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        if ([attachmentAry count] <= 0) {
            return;
        }
        NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
        
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
