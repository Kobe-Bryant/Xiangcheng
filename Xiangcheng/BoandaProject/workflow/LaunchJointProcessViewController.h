//
//  LaunchJointProcessViewController.h
//  GuangXiOA
//
//  Created by 张 仁松 on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  发起会办

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "UISelectPersonVC.h"
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"
#import "SelectedPersonItem.h"

#define kWebService_WorkFlow 0
#define kWebService_Transfer 1
#define NOT_SELECTED -1

@interface LaunchJointProcessViewController : UIViewController<UISelPeronViewDelegate,UIAlertViewDelegate,WordsDelegate>

@property (nonatomic,strong) IBOutlet UITableView *stepTableView;
@property (nonatomic,strong) IBOutlet UITableView *usrTableView;

@property (nonatomic,strong) IBOutlet UITextView *opinionView;

@property (nonatomic,strong) IBOutlet UISegmentedControl *signSegCtrl;
@property (nonatomic,strong) IBOutlet UILabel *signLabel;

//会办意见汇总的时候用到
@property (nonatomic,strong) IBOutlet UISwitch *collectSwitch;
@property (nonatomic,strong) IBOutlet UILabel *isCollectLabel;
@property (nonatomic,strong) IBOutlet UILabel *collectPersonLabel;
@property (nonatomic,strong) IBOutlet UIButton *collectPersonBtn;

@property(nonatomic,copy)NSString *bzbh;
@property(nonatomic,assign) BOOL canSignature;
@property(nonatomic,copy)NSString *processType;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;

//会办步骤编号
@property(nonatomic,copy)NSString *hbbzbh;

-(IBAction)btnTransferPressed:(id)sender;

-(IBAction)btnPersonShortCutPressed:(id)sender;

-(IBAction)btnStepShortCutPressed:(id)sender;

-(void)updateSelectStep;

@end
