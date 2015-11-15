//
//  LaiWenSearchController.h
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"
#import "BaseViewController.h"

@interface LaiWenSearchController : BaseViewController<NSURLConnHelperDelegate,PopupDateDelegate>

@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) IBOutlet UITextField *titleField; //来文标题field
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;     //来文标题label
@property (strong, nonatomic) IBOutlet UILabel *wenHaoLabel;    //文号label
@property (strong, nonatomic) IBOutlet UITextField *wenHaoField;
@property (strong, nonatomic) IBOutlet UILabel *jjcdLabel; //紧急程度Label
@property (strong, nonatomic) IBOutlet UISegmentedControl *jjcdSegment;
@property (strong, nonatomic) IBOutlet UITextField *fromDateField;//开始日期
@property (strong, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (strong, nonatomic) IBOutlet UITextField *endDateField;//截止日期
@property (strong, nonatomic) IBOutlet UILabel *endDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) NSURLConnHelper *webHelper;

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL bHaveShowed;
@property (nonatomic, strong) NSMutableArray *resultAry;
@property (nonatomic, strong) NSMutableArray *resultHeightAry;
@property (nonatomic, strong) NSString *lxtype;//类型
@property (nonatomic, strong) NSString *urlString; //不含p_CURRENT的url

- (void)showSearchBar:(id)sender;

- (IBAction)btnSearchPressed:(id)sender;

- (IBAction)touchFromDate:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(NSString*)typeStr;

@end
