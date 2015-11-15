//
//  ShowLocalFileController.h
//  GuangXiOA
//
//  Created by 张 仁松 on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ShowLocalFileController : UIViewController
<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property(nonatomic,retain) NSString *fileName;
@property(nonatomic,retain) NSString *fullPath;
@property(nonatomic,assign) BOOL bCanSendEmail;
@end
