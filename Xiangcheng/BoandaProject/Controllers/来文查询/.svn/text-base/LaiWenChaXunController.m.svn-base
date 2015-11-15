//
//  LaiWenChaXunController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LaiWenChaXunController.h"
#import "PDJsonkit.h"
#import "LaiWenSearchController.h"


@implementation LaiWenChaXunController
@synthesize itemAry,typeAry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"收文查询";
    
    [self.listTableView setBackgroundView:nil];
    [self.listTableView setBackgroundView:[[UIView alloc] init]];
    self.listTableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view from its nib.
    /*self.itemAry = [NSArray arrayWithObjects:@"部（委）来文",@"厅（局）来文",@"市（县）来文",@"厅内各单位来文",@"其他单位来文",@"党委政府来文",@"电话记录",@"会议", nil];
    
    self.typeAry = [NSArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50",@"21",@"51",@"60", 
                    nil];*/
    self.itemAry = [NSArray arrayWithObjects:@"厅转外单位来文", @"厅下发文", @"厅通知公告",@"其他单位来文",@"会议",@"电话记录", @"其他",nil];
    
    self.typeAry = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",nil];
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	//self.navigationItem.hidesBackButton = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [itemAry count];
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 55;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

        
	}

	cell.textLabel.text = [itemAry objectAtIndex:indexPath.section];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;

}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LaiWenSearchController *controller = [[LaiWenSearchController alloc] initWithNibName:@"LaiWenSearchController" andType:[typeAry objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end