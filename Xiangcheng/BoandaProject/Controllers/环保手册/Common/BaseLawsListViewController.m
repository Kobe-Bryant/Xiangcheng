//
//  BaseLawsListViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseLawsListViewController.h"
#import "LawsDetailViewController.h"

@interface BaseLawsListViewController ()

@end

@implementation BaseLawsListViewController

- (void)makeSubViews
{
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 960) style:UITableViewStylePlain];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.view addSubview:self.listTableView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 0.0)];
    self.searchBar.delegate = self;
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    self.navigationItem.rightBarButtonItem = searchItem;}

- (void)initData
{
	self.aryItems = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeSubViews];
    
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.aryItems count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"Law_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:22];
    NSDictionary *dicItem = [self.aryItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [dicItem objectForKey:@"FGMC"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicItem = [self.aryItems objectAtIndex:indexPath.row];
    NSString *boolStr = [dicItem objectForKey:@"SFML"];
	BOOL bHasChild = [boolStr boolValue];
    if (bHasChild)
    {
        BaseLawsListViewController *list = [[BaseLawsListViewController alloc] init];
        [self.navigationController pushViewController:list animated:YES];
        [list searchByFIDH: [dicItem objectForKey:@"FGBH"] root:[dicItem objectForKey:@"FGMC"] ];
    }
    else
    {
        LawsDetailViewController *detail = [[LawsDetailViewController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
        [detail loadHBSCItem:dicItem ];
    }
}

- (void) searchByFIDH:(id)strFIDH root:(id)rootMl
{
    self.title = self.viewTitle = rootMl;

	[self.aryItems removeAllObjects];
	    
    HBSCHelper *helper = [[HBSCHelper alloc] init];
    NSArray *ary = [helper searchByFIDH:strFIDH];
    [self.aryItems addObjectsFromArray:ary];

	[self.listTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.title = @"查询结果";
    HBSCHelper *helper = [[HBSCHelper alloc] init];
    [self.aryItems removeAllObjects];
    NSArray *ary = [helper searchByFGMC:searchBar.text];
    [self.aryItems addObjectsFromArray:ary];
    [self.listTableView reloadData];
    [_searchBar resignFirstResponder];
}

@end
