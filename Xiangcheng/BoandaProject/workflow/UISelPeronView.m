//
//  UISelPeronView.m
//  TaskTransfer
//
//  Created by zhang on 12-11-23.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "UISelPeronView.h"
#define TableView_Left  1
#define TableView_Right 2
#import <QuartzCore/QuartzCore.h>


//250*750  500*750 
@interface UISelPeronView()
@property(nonatomic,strong)UISegmentedControl *segCtrl;
@property(nonatomic,strong)UIButton *exitBtnCtrl;
@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;
@property(nonatomic,strong) NSMutableArray * arySelUsrs;
@property(nonatomic,strong) NSArray * aryRightUsrs;
@property(nonatomic,strong) NSDictionary *dicSelDepart;

@property(nonatomic,assign)BOOL bShow;
@end


@implementation UISelPeronView
@synthesize segCtrl,aryWorkflowUsrs,multiUsr,bShow,toSelPersonType,delegate,arySelUsrs;
@synthesize leftTableView,rightTableView,departUserModel,aryRightUsrs,dicSelDepart,exitBtnCtrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = NO;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 12;
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(5,5);
        self.layer.cornerRadius = 4.0;
        
        // Initialization code
        UISegmentedControl *aSegCtrl =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"流程定义",@"组织机构", nil]];
        aSegCtrl.frame = CGRectMake(10, 10, 180, 40);
        aSegCtrl.selectedSegmentIndex = 0;
        self.segCtrl = aSegCtrl;
        [segCtrl addTarget:self action:@selector(segCtrlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:segCtrl];

        
        UIButton *exitBtn  = [[UIButton alloc] initWithFrame:CGRectMake(200, 10, 30, 30)];
        [exitBtn addTarget:self action:@selector(exitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [exitBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [self addSubview:exitBtn];
        self.exitBtnCtrl = exitBtn;

        
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 245, 640) style:UITableViewStylePlain];
        self.rightTableView = tableView;
        tableView.tag = TableView_Right;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        
        UITableView *tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(-250, 55, 245, 640) style:UITableViewStylePlain];
        self.leftTableView = tableView1;
        leftTableView.hidden = YES;
        tableView1.tag = TableView_Left;
        tableView1.delegate = self;
        tableView1.dataSource = self;
        [self addSubview:tableView1];

        
        
        UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnOk.frame = CGRectMake(25, 700, 200, 45);
        [btnOk addTarget:self action:@selector(okBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnOk setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:btnOk];
    }
    return self;
}

-(void)exitBtnPressed:(id)sender{
    CGFloat xPos;
    CGFloat width = self.frame.size.width;
    if(bShow){
        xPos = 768;
    }else{
        xPos = 768-250;
    }
    
    [UIView beginAnimations:@"kshowRight" context:(__bridge void *)(self)];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect rect = CGRectMake(xPos, 60, width,750);
    self.frame = rect;
    [UIView commitAnimations];
    
    self.bShow = !bShow;
}

-(void)segCtrlValueChanged:(id)sender{
    CGFloat xPos,width;
    if(segCtrl.selectedSegmentIndex == 0){
        xPos = 518;
        width = 250;
        leftTableView.hidden = YES;
        leftTableView.frame = CGRectMake(-250, 55,  245, 640);
        rightTableView.frame = CGRectMake(0, 55,  245, 640);
        exitBtnCtrl.frame = CGRectMake(200, 10, 30, 30);
        
    }else{
        xPos = 268;
        width = 500;
        leftTableView.hidden = NO;
        leftTableView.frame = CGRectMake(0, 55,  245, 640);
        rightTableView.frame = CGRectMake(250, 55,  245, 640);
        exitBtnCtrl.frame = CGRectMake(450, 10, 30, 30);
    }
    
    [UIView beginAnimations:@"kshowRight" context:(__bridge void *)(self)];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGRect rect = CGRectMake(xPos, 60, width,750);
    self.frame = rect;
    
    [UIView commitAnimations];
    
    if(segCtrl.selectedSegmentIndex == 0)
        self.aryRightUsrs = aryWorkflowUsrs;
    else{
        self.aryRightUsrs = nil;
        self.dicSelDepart = nil;
    }
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];

}

-(void)okBtnPressed:(id)sender{
    [delegate returnSelectedPersons:arySelUsrs andPersonType:toSelPersonType];
    [self exitBtnPressed:nil];
}

-(void)showView:(BOOL)isShow{
    if(toSelPersonType == kPersonType_Master)
        segCtrl.hidden = YES;
    else
        segCtrl.hidden = NO;
    
    if(segCtrl.selectedSegmentIndex == 0)
        self.aryRightUsrs = aryWorkflowUsrs;
    else{
        self.aryRightUsrs = nil;
        self.dicSelDepart = nil;
        }
    if(bShow != isShow){
        [self exitBtnPressed:nil];
    }
    [self segCtrlValueChanged:nil];
}

-(void)setAryWorkflowUsrs:(NSArray *)ary{
    aryWorkflowUsrs = [ary copy];
    [arySelUsrs removeAllObjects];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (tableView.tag == TableView_Right) {
        headerView.text = [NSString stringWithFormat:@"  可选择的人员"];
            
    }else{
        headerView.text = [NSString stringWithFormat:@"  组织机构"];
    }
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView.tag == TableView_Right){
        
        return [aryRightUsrs count];
    }
    else
        return [departUserModel.aryDeparts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (tableView.tag == TableView_Right) {
         return 1;
     }else{
         NSDictionary *dic = [departUserModel.aryDeparts objectAtIndex:indexPath.row];
         NSString *departID = [dic objectForKey:@"deptId"];
         return [departUserModel getLevelByDepartID:departID];
     }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WryXmspListCellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.detailTextLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

        
	}
    
    if (tableView.tag == TableView_Right) {
        NSDictionary *dic = [aryRightUsrs objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"userName"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(arySelUsrs){
            if([arySelUsrs containsObject:dic])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }else{
        NSDictionary *dic = [departUserModel.aryDeparts objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"deptName"];
        if([dicSelDepart isEqualToDictionary:dic])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
        
	return cell;
	
    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == TableView_Right) {
        if (arySelUsrs == nil) {
            self.arySelUsrs = [NSMutableArray arrayWithCapacity:3];
        }
        
        NSDictionary *dic  = [aryRightUsrs objectAtIndex:indexPath.row];
        if(toSelPersonType == kPersonType_Master && multiUsr==NO){
            [arySelUsrs removeAllObjects];
            [arySelUsrs addObject:dic];
        }else{
            
            if([arySelUsrs containsObject:dic])
                [arySelUsrs removeObject:dic];
            else
                [arySelUsrs addObject:dic];
        }
        
        [tableView reloadData];
    }else{
        self.dicSelDepart = [departUserModel.aryDeparts objectAtIndex:indexPath.row];
        self.aryRightUsrs = [dicSelDepart objectForKey:@"users"];
        [rightTableView reloadData];
        [leftTableView reloadData];
    }
    
}


@end

