//
//  CounterSignActionController.h
//  TaskTransfer
//
//  Created by zhang on 12-11-15.
//  Copyright (c) 2012年 zhang. All rights reserved.
//  发起会签操作


#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "CommenWordsViewController.h"
#import "HandleGWProtocol.h"

@interface CounterSignActionController : UIViewController<NSURLConnHelperDelegate,WordsDelegate,UIAlertViewDelegate>

@property (nonatomic,copy) NSString *bzbh;
@property (nonatomic,copy) NSString *nextStepId;
@property (nonatomic,assign) BOOL canSignature;
@property (nonatomic,strong) IBOutlet UITableView *usrTableView;
@property (nonatomic,strong) IBOutlet UITableView *shortcutTableView;
@property (nonatomic,strong) IBOutlet UITextView *opinionView;
@property (nonatomic, strong) IBOutlet UITextView *selUsersTxtView;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *signSegCtrl;
@property (strong, nonatomic) IBOutlet UIButton *collectButton;
@property (strong, nonatomic) IBOutlet UIButton *userShortCutButton;
@property (strong, nonatomic) IBOutlet UIButton *stepShortCutButton;

@property (nonatomic,strong) IBOutlet UISegmentedControl *nextStepSegCtrl;
@property (nonatomic,strong) IBOutlet UISegmentedControl *sumOpinionSegCtrl;
@property (nonatomic,strong) IBOutlet UISegmentedControl *counterSignTypeSegCtrl;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) id<HandleGWDelegate> delegate;

-(IBAction)counterSign:(id)sender;
-(IBAction)btnPersonShortCutPressed:(id)sender;
-(IBAction)btnStepShortCutPressed:(id)sender;

@end
