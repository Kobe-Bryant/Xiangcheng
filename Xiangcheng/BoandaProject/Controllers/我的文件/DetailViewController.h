//
//  DetailViewController.h
//  GuangXiOA
//
//  Created by apple on 13-1-16.
//
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import "FolderViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MovePopViewController.h"
#import "PDFileManager.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MovePopViewControllerDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) MGSplitViewController *mgSplitViewController;
@property (nonatomic,strong) FolderViewController *folderViewController;
@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,strong) UITableView *resultTableView;
@property (nonatomic,strong) NSMutableArray *resultHeightAry;
@property (nonatomic,strong) NSMutableArray *checkArray;
@property (nonatomic,strong) NSMutableArray *boxArray;
@property (nonatomic,assign) BOOL isMove;
@property (nonatomic,assign) BOOL isDelete;
@property (nonatomic,strong) MovePopViewController *moveVc;
@property (nonatomic,strong) UIPopoverController *popVc;
@property (nonatomic,strong) NSMutableArray *folderKeys;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) BOOL edited;
@property (nonatomic,assign) NSInteger firstTag;
@property (nonatomic,strong) PDFileManager *fileManager;
@property (nonatomic,strong) NSString *folderBasePath;

- (void)reloadResultHeightAry;

@end
