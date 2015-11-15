//
//  FaWenSearchController.h
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "DepartmentInfoItem.h"
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"

@interface HaveDoneSearchController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PopupDateDelegate,WordsDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UITextField *titleField;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UILabel *lclxLabel;
@property (nonatomic, strong) IBOutlet UITextField *lclxField;

@property (nonatomic, strong) IBOutlet UITextField *lcFromDateField;
@property (nonatomic, strong) IBOutlet UILabel *lcFromDateLabel;
@property (nonatomic, strong) IBOutlet UITextField *lcEndDateField;
@property (nonatomic, strong) IBOutlet UILabel *lcEndDateLabel;

/*@property (nonatomic, strong) IBOutlet UITextField *bzFromDateField;
@property (nonatomic, strong) IBOutlet UILabel *bzFromDateLabel;
@property (nonatomic, strong) IBOutlet UITextField *bzEndDateField;
@property (nonatomic, strong) IBOutlet UILabel *bzEndDateLabel;
*/
@property (nonatomic, strong) NSURLConnHelper *webHelper;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic,strong) NSMutableArray *aryItems;

@property (nonatomic, strong) IBOutlet UIButton *searchBtn;

@property (nonatomic, strong) NSMutableArray *laiWenItemAry;
@property (nonatomic, strong) NSMutableArray *faWenItemAry;
@property (nonatomic, strong) NSMutableArray *neiBuShiXiangItemAry;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSum;
@property (nonatomic, assign) BOOL bHaveShowed;
@property (nonatomic, assign) BOOL currentTag;
@property (nonatomic, assign) NSInteger gwType;
@property (nonatomic, strong) NSString *urlString; //不含p_CURRENT的url

@property (nonatomic, strong) NSArray *gwTypeAry;
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;
@property (nonatomic, strong) UIPopoverController *wordPopController;
@property (nonatomic, strong) CommenWordsViewController *wordsController;
@property (nonatomic, strong) UIBarButtonItem *rightButtonBar;

@property (nonatomic, strong) NSArray* segmentControlTitles;

-(void)showSearchBar:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)touchFromDate:(id)sender;
-(IBAction)touchFromType:(id)sender;

@end
