//
//  BanLiController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BanLiController.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "BanLiDetailController.h"
#import "BanLiItem.h"
#import "FaWenBanliController.h"
#import "NoticeDetailsViewController.h"
#import "SystemConfigContext.h"
#import "NoticeTaskDetailVC.h"

@implementation BanLiController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.swipe];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *itemTitle = [[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
    NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
    //cell.textLabel.text = itemTitle;
    NSString *qixian = [dic objectForKey:@"LCMC"]; //任务类型
    //if([qixian length]>10)
        //qixian = [qixian substringToIndex:10];
    
    NSString *fbr = [NSString stringWithFormat:@"交办人：%@",[dic objectForKey:@"YHMC"]];
    
    NSString *fbsj = [NSString stringWithFormat:@"发布时间：%@",[dic objectForKey:@"KSSJ"]];
    
    NSString *bljd = [NSString stringWithFormat:@"办理阶段：%@",[dic objectForKey:@"BZMC"]];
    
    NSString *strlclxbh = [dic objectForKey:@"LCLXBH"];
    
    
    UIImage *cellImg = nil;
    
    if ([strlclxbh isEqualToString:kFaWen_Type_Tag])
    {
        //发文
        itemTitle = [[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
        if (itemTitle== nil) {
            itemTitle = @"";
        }
        itemTitle = [NSString stringWithFormat:@"%@【发文】",itemTitle];
        cellImg = [UIImage imageNamed:@"fw.png"];
    }
    else if ([strlclxbh isEqualToString:kLaiWen_Type_Tag])
    {
        //来文
        itemTitle = [NSString stringWithFormat:@"%@【来文】",itemTitle];
        cellImg = [UIImage imageNamed:@"lw.png"];
    }
    else if([strlclxbh isEqualToString:kNotice_Type_Tag])
    {
        itemTitle = [NSString stringWithFormat:@"%@【通知公告】",itemTitle];
        cellImg = [UIImage imageNamed:@"tzgg.png"];
    }
    
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:itemTitle andSubvalue1:fbr andSubvalue2:fbsj andSubvalue3:bljd andSubvalue4:[NSString stringWithFormat:@"任务类型：%@",qixian]];
    cell.imageView.image = cellImg;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.aryItems==nil || [self.aryItems count] <= indexPath.row)
    {
        NSLog(@"parsedItemAry error in BanliCOntroller");
    }
    
    NSDictionary *tmpDic = [self.aryItems objectAtIndex:indexPath.row];    
    NSString *lclxbh = [tmpDic objectForKey:@"LCLXBH"];
    NSString *dwmc = [tmpDic objectForKey:@"DWMC"];
    if ([lclxbh isEqualToString:kFaWen_Type_Tag])
    {
        //发文
        FaWenBanliController *controller = [[FaWenBanliController alloc] initWithNibName:@"FaWenBanliController" andParams:tmpDic isBanli:YES];
        controller.title = dwmc;
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([lclxbh isEqualToString:kLaiWen_Type_Tag])
    {
        //来文
        BanLiDetailController *controller = [[BanLiDetailController alloc] initWithNibName:@"BanLiDetailController" andParams:tmpDic isBanli:YES];
        controller.title = dwmc;
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([lclxbh isEqualToString:kNotice_Type_Tag])
    {
        //通知公告
        NoticeTaskDetailVC *controller = [[NoticeTaskDetailVC alloc] initWithNibName:@"NoticeTaskDetailVC" andParams:tmpDic isBanli:NO];
        controller.title = dwmc;
        [self.navigationController pushViewController:controller animated:YES ];
    }
}

@end
