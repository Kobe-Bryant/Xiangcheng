//
//  EndorseActionController.h
//  TaskTransfer
//
//  Created by zhang on 12-11-16.
//  Copyright (c) 2012年 zhang. All rights reserved.
//   发起加签操作

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "CommenWordsViewController.h"
#import "HandleGWProtocol.h"

@interface EndorseActionController : UIViewController<NSURLConnHelperDelegate,WordsDelegate>
@property(nonatomic,copy)NSString *bzbh;
@property(nonatomic,assign) BOOL canSignature;
@property (nonatomic,strong) IBOutlet UITableView *usrTableView;

@property (nonatomic,strong) IBOutlet UITextView *opinionView;
@property (nonatomic,strong) IBOutlet UITextView *selUsersTxtView;

@property (nonatomic,strong) IBOutlet UISegmentedControl *nextStepSegCtrl;
@property (nonatomic,strong) IBOutlet UISegmentedControl *sumOpinionSegCtrl;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;
-(IBAction)endorse:(id)sender;
-(IBAction)btnPersonShortCutPressed:(id)sender;

-(IBAction)btnStepShortCutPressed:(id)sender;
@end
