//
//  FinishActionController.h
//  TaskTransfer
//
//  Created by zhang on 12-11-15.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "HandleGWProtocol.h"

@interface FinishActionController : UIViewController

@property (nonatomic,assign) int serviceType;//0表示WORKFLOW_FINISH_ACTION 1表示WORKFLOW_SINGLEFINISH_ACTION
@property (nonatomic,copy) NSString *processer;
@property (nonatomic,copy) NSString *processType;
@property (nonatomic,strong) IBOutlet UITextView *txtView;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segCtrl;
@property (nonatomic,strong) IBOutlet UILabel *signLabel;
@property(nonatomic,copy)NSString *bzbh;
@property(nonatomic,assign) BOOL canSignature;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;   
-(IBAction)finish:(id)sender;

@end
