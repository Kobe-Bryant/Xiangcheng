//
//  FeedbackActionController.h
//  TaskTransfer
//
//  Created by zhang on 12-11-15.
//  Copyright (c) 2012年 zhang. All rights reserved.
//  反馈操作

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "HandleGWProtocol.h"

@interface FeedbackActionController : UIViewController<NSURLConnHelperDelegate>
@property(nonatomic,strong)IBOutlet UITextView *personalOpinionTxtView;//个人意见
@property(nonatomic,strong)IBOutlet UITextView *sumOpinionTxtView; //汇总意见
@property(nonatomic,copy)NSString *bzbh;
@property(nonatomic,assign) BOOL canSignature;
@property (nonatomic,assign) id<HandleGWDelegate> delegate;
-(IBAction)modify:(id)sender;
-(IBAction)feedBack:(id)sender;
@end
