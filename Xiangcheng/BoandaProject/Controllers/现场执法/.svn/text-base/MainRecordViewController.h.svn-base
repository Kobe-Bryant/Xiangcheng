//
//  MainRecordViewController.h
//  BoandaProject
//
//  Created by BOBO on 13-12-30.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDateViewController.h"
#import "BaseViewController.h"

@interface MainRecordViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,PopupDateDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *recordTable;
@property (nonatomic,strong) IBOutlet UILabel *wrymcLab;

@property (nonatomic,strong) IBOutlet UILabel *qsrqLab;
@property (nonatomic,strong) IBOutlet UILabel *jzrqLab;
@property (nonatomic,strong) IBOutlet UITextField *wrymcFie;

@property (nonatomic,strong) IBOutlet UITextField *qsrqFie;
@property (nonatomic,strong) IBOutlet UITextField *jzrqFie;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;

@property (nonatomic,strong) NSArray *webResultAry;
@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSMutableString *curParsedData;


@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,assign) int currentTag;

- (IBAction)searchBtnPressed:(id)sender;


@end
