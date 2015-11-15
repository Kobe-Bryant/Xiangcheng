//
//  CopyActionViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-9-10.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "CopyActionViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UsersHelper.h"
#import "SystemConfigContext.h"

@interface CopyActionViewController ()

@property (nonatomic, strong) UsersHelper *usersHelper;
@property (nonatomic, strong) NSDictionary *usersDict;
@property (nonatomic, strong) NSArray *deptsArray;
@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *selectedUsersArray;

@end

@implementation CopyActionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.openSection = -1;
    self.processer = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    self.selectedUsersArray = [[NSMutableArray alloc] init];
    self.usersHelper = [[UsersHelper alloc] init];
    self.deptsArray = [self.usersHelper queryAllSubDept:@"ROOT"];//获得全部部门
    self.usersArray = [[NSMutableArray alloc] init];
    [self.usersTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.webHelper)
    {
        [self.webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Network Handler
//{"result":"1","error":""}
-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@", resultJSON];
    [str replaceOccurrencesOfString:@"'" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
    NSDictionary *parsedJSONDict = [str objectFromJSONString];
    if(parsedJSONDict != nil)
    {
        NSString *result = [NSString stringWithFormat:@"%@", [parsedJSONDict objectForKey:@"result"]];
        if([result isEqualToString:@"1"])
        {
            [self showAlertMessage:@"办理成功"];
        }
        else
        {
            [self showAlertMessage:[parsedJSONDict objectForKey:@"error"]];
        }
    }
    else
    {
        [self showAlertMessage:@"获取数据出错."];
    }
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错."];
    return;
}

#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"办理成功"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate HandleGWResult:TRUE];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    self.openSection = -1;
	NSInteger countOfRowsToDelete = [self.usersTableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
		[self.usersTableView reloadData];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	self.openSection = section;
	[self.usersTableView reloadData];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 60.0;
	return headerHeight;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 60.0;
    NSDictionary *tmpDic = [self.deptsArray objectAtIndex:section];
    NSString *bmbh = [[self.deptsArray objectAtIndex:section] objectForKey:@"ZZBH"];
    NSArray *ary = [self.usersHelper queryAllUsers:bmbh];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:ary forKey:@"users"];
    [self.usersArray addObject:dict];
    NSString *title = [tmpDic objectForKey:@"ZZJC"];
    BOOL opened = NO;
    if(section == self.openSection)
    {
        opened = YES;
    }
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc]
                                            initWithFrame:CGRectMake(0.0, 0.0, self.usersTableView.bounds.size.width, headerHeight)
                                            title:title
                                            section:section
                                            opened:opened
                                            delegate:self];
	return sectionHeadView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.deptsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.openSection == section)
    {
        NSArray *ary = [[self.usersArray objectAtIndex:section] objectForKey:@"users"];
        return ary.count;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255  blue:242.0/255  alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [[[[self.usersArray objectAtIndex:indexPath.section] objectForKey:@"users"] objectAtIndex:indexPath.row] objectForKey:@"YHMC"];
    if([self.selectedUsersArray containsObject:[[[[self.usersArray objectAtIndex:indexPath.section] objectForKey:@"users"] objectAtIndex:indexPath.row] objectForKey:@"YHID"]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *yhid = [[[[self.usersArray objectAtIndex:indexPath.section] objectForKey:@"users"] objectAtIndex:indexPath.row] objectForKey:@"YHID"];
    if([self.selectedUsersArray containsObject:yhid])
    {
        [self.selectedUsersArray removeObject:yhid];
    }
    else
    {
        [self.selectedUsersArray addObject:yhid];
    }
    [self.usersTableView reloadData];
}

- (IBAction)sendButtonClick:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"WORKFLOW_COPYREADAR_ACTION" forKey:@"service"];
    [params setObject:self.LCLXBH forKey:@"LCLXBH"];
    [params setObject:self.BZDYBH forKey:@"BZDYBH"];
    [params setObject:self.BZBH forKey:@"BZBH"];
    [params setObject:self.LCSLBH forKey:@"LCSLBH"];
    [params setObject:self.processer forKey:@"processer"];
    [params setObject:self.processType forKey:@"processType"];
    if(self.opinionView.text.length == 0)
    {
        [self showAlertMessage:@"请输入消息内容."];
        return;
    }
    else
    {
         [params setObject:self.opinionView.text forKey:@"opinion"];
    }
    if(self.selectedUsersArray.count == 0)
    {
        [self showAlertMessage:@"请选择抄送的用户."];
        return;
    }
    else
    {
        NSMutableString *userIdStr = [[NSMutableString alloc] init];
        for(int i = 0; i < self.selectedUsersArray.count; i++)
        {
            if(i<self.selectedUsersArray.count-1)
            {
                [userIdStr appendFormat:@"%@;", [self.selectedUsersArray objectAtIndex:i]];
            }
            else
            {
                [userIdStr appendFormat:@"%@", [self.selectedUsersArray objectAtIndex:i]];
            }
        }
        [params setObject:userIdStr forKey:@"userids"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"抄送url===%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - 私有方法

- (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
    [alert show];
}

@end
