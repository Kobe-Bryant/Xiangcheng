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
    //FolderViewController *_folderViewController;
}

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UITableView *listTableView;
@property(nonatomic,strong) NSString *attachURL;
@property(nonatomic,strong) NSString *attachName;
@property(nonatomic,strong) IBOutlet UILabel *labelTip;
@property(nonatomic,strong) IBOutlet UIProgressView *progress;
@property(nonatomic,strong) ASINetworkQueue * networkQueue ;
@property(nonatomic,assign) BOOL showZipFile;
@property(nonatomic,strong) NSArray *aryFiles;
@property(nonatomic,strong) NSString *tmpUnZipDir;//解压缩后的临时目录

//添加弹出文件夹选择
//@property (nonatomic,strong) MovePopViewController *moveVc;
@property (nonatomic,strong) UIPopoverController *popVc;
//@property (nonatomic,strong) FolderViewController *folderViewController;
//@property (nonatomic,strong) NSString *newPath;
@property (nonatomic,assign) NSInteger didTag;

- (id)initWithNibName:(NSString *)nibNameOrNil fileURL:(NSString *)fileUrl andFileName:(NSString*)fileName;
@end
