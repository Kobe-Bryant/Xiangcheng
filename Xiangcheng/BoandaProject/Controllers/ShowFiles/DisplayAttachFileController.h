//
//  DisplayAttachFileController.h
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface DisplayAttachFileController : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate> {

}

@property(nonatomic,strong) IBOutlet UILabel *labelTip;
@property(nonatomic,strong) IBOutlet UIProgressView *progress;




- (id)initWithNibName:(NSString *)nibNameOrNil fileURL:(NSString *)fileUrl andFileName:(NSString*)fileName;
@end
