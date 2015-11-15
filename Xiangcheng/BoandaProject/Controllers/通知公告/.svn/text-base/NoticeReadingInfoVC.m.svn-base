//
//  NoticeReadingInfoVC.m
//  GuangXiOA
//
//  Created by zhang on 12-10-8.
//
//

#import "NoticeReadingInfoVC.h"

#define SHOWINFO_GRYDQK 1
#define SHOWINFO_DWYDQK 0

@interface NoticeReadingInfoVC ()

@property(nonatomic,unsafe_unretained) NSInteger showInfoType;

@end

@implementation NoticeReadingInfoVC

@synthesize aryDWQK,aryGRQK,resultTableView,showInfoType;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"阅读情况";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 0)
    {
        return [aryDWQK count];
    }
    else
    {
        return [aryGRQK count];
    }
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
    if (section == 0)
    {
        headerView.text = @"  单位阅读情况";
    }
    else if (section == 1)
    {
        headerView.text = @"  个人阅读情况";
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0)
    {
        return 90;
    }
    else
    {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoticeProject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.numberOfLines = 2;
    }
    if(indexPath.section == 0)
    {
        NSDictionary *dic = [aryDWQK objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"部门：%@    反馈人：%@    反馈时间：%@",[dic objectForKey:@"BMMC"],[dic objectForKey:@"FKR"],[dic objectForKey:@"FKRQ"]];
        cell.detailTextLabel.text = [dic objectForKey:@"FKNR"];
    }
    else
    {
        NSDictionary *dic = [aryGRQK objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"阅读用户：%@     最近阅读时间：%@",[dic objectForKey:@"YHMC"],[dic objectForKey:@"RDSJ"]];
        cell.detailTextLabel.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

@end
