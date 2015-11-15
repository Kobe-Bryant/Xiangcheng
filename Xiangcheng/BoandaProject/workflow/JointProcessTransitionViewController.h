//
//  JointProcessTransitionViewController.h
//  会办流转
//
//  Created by Alex Jean on 13-9-3.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "UISelectPersonVC.h"
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"
#import "SelectedPersonItem.h"

@interface JointProcessTransitionViewController : UIViewController <UISelPeronViewDelegate,UIAlertViewDelegate,WordsDelegate>

@property (nonatomic,strong) IBOutlet UITableView *usrTableView;
@property (nonatomic,strong) IBOutlet UITextView *opinionView;

@property (nonatomic,copy) NSString *bzbh;
@property (nonatomic,assign) BOOL canSignature;
@property (nonatomic,copy) NSString *processType;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;

-(IBAction)btnTransferPressed:(id)sender;

-(IBAction)btnPersonShortCutPressed:(id)sender;

-(IBAction)btnStepShortCutPressed:(id)sender;

-(void)updateSelectStep;

@end
