//
//  SearchNoticeViewController.h
//  GuangXiOA
//
//  Created by sz apple on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"

@interface SearchNoticeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,NSURLConnHelperDelegate,WordsDelegate,PopupDateDelegate>
@property (strong, nonatomic) IBOutlet UITextField *zbdwField;
@property (strong, nonatomic) IBOutlet UITextField *tzbtField;

@property (strong, nonatomic) IBOutlet UITextField *jssjField;
@property (strong, nonatomic) IBOutlet UITextField *kssjField;

@property (nonatomic,strong) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) IBOutlet UIButton *searchButton;

@property (nonatomic,unsafe_unretained) NSInteger pageCount;
@property (nonatomic,unsafe_unretained) NSInteger currentPage;
@property (nonatomic,unsafe_unretained) NSInteger pages;
@property (nonatomic,unsafe_unretained) BOOL isLoading;
@property (nonatomic,unsafe_unretained) NSInteger currentTag;

@property (nonatomic,strong) NSMutableArray *resultAry;
@property (nonatomic,strong) NSString *departmentDM;
@property (nonatomic,strong) NSString *typeDM;
@property (nonatomic,strong) NSString *refreshUrl;
@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;
@property (strong, nonatomic) PopupDateViewController *datePopover;
@property (strong, nonatomic) UIPopoverController *datePopoverController;

@property (nonatomic,assign) BOOL showTingData;

- (IBAction)searchButtonPressed:(id)sender;
- (IBAction)touchDownForDate:(id)sender;
- (IBAction)touchDownForDepartment:(id)sender;

@end
