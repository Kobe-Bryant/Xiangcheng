//
//  ProjectViewController.h
//  BoandaProject
//
//  Created by PowerData on 14-3-4.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PopupDateViewController.h"

@interface ProjectViewController : BaseViewController<PopupDateDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)IBOutlet UITextField *xmmcFie;
@property (nonatomic,strong)IBOutlet UITextField *lxdzFie;
@property (nonatomic,strong)IBOutlet UITextField *qsrqFie;
@property (nonatomic,strong)IBOutlet UITextField *jzrqFie;
@property (strong, nonatomic) IBOutlet UITextField *spwhFie;
@property (strong, nonatomic) IBOutlet UITextField *spnfFie;
@property (strong, nonatomic) IBOutlet UITextField *spszFie;
@property (strong, nonatomic) IBOutlet UITextField *jsdwFie;
@property (nonatomic,strong)IBOutlet UIButton *searchBtn;
@property (nonatomic,strong)IBOutlet UITableView *listTableView;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic,strong)NSMutableArray *valueAry;
- (IBAction)searchBtnPressed:(id)sender;

@end