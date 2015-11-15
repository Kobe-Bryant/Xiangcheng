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
#import "PopupDateViewController.h"
#import "BaseViewController.h"

@interface FaWenSearchController : BaseViewController<UITableViewDataSource,UITableViewDelegate,WordsDelegate,NSURLConnHelperDelegate,PopupDateDelegate>
@property(nonatomic,strong)IBOutlet UITableView *resultTableView;
@property(nonatomic,strong)IBOutlet UITextField *titleField;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UITextField *niwenField;
@property(nonatomic,strong)IBOutlet UILabel *niwenLabel;
@property(nonatomic,strong)IBOutlet UILabel *wenHaoLabel;
@property(nonatomic,strong)IBOutlet UITextField *wenHaoField;
@property(nonatomic,strong)IBOutlet UILabel *gklxLabel;
@property(nonatomic,strong)IBOutlet UISegmentedControl *gklxSegCtrl;

@property(nonatomic,strong)IBOutlet UITextField *fromDateField;
@property(nonatomic,strong)IBOutlet UILabel *fromDateLabel;
@property(nonatomic,strong)IBOutlet UITextField *endDateField;
@property(nonatomic,strong)IBOutlet UILabel *endDateLabel;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) PopupDateViewController *dateController;
@property(nonatomic,assign) NSInteger currentTag;
@property(nonatomic,strong)IBOutlet UIButton *searchBtn;
@property(nonatomic,assign) NSInteger pageCount;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;
@property(nonatomic,strong)NSURLConnHelper *webHelper;
@property (nonatomic,strong) NSString *danweiDM;//单位代码
@property(nonatomic,assign)BOOL bHaveShowed;
@property(nonatomic,strong) NSMutableArray *resultAry;
@property(nonatomic,strong) NSString *lxtype;//类型
@property(nonatomic,strong)NSString *urlString; //不含p_CURRENT的url
-(void)showSearchBar:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)touchFromDate:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil andType:(NSString*)typeStr;
@end
