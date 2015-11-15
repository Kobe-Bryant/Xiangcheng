//
//  JointProcessFeedbackViewController.h
//  会办返回
//
//  Created by Alex Jean on 13-9-3.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"

@interface JointProcessFeedbackViewController : UIViewController <UIAlertViewDelegate,NSURLConnHelperDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *bzbh;
@property (nonatomic, assign) BOOL canSignature;
@property (nonatomic, copy) NSString *processType;
@property (nonatomic, assign) id<HandleGWDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *usersTableView;
@property (strong, nonatomic) IBOutlet UITextView *opinionTextView;

-(IBAction)btnTransferPressed:(id)sender;

@end
