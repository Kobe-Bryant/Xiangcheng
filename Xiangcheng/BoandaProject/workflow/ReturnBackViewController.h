//
//  ReturnBackViewController.h
//  GuangXiOA
//
//  Created by zhang on 12-9-12.
//
//

#import <UIKit/UIKit.h>

#import "BanLiItem.h"
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"
#define kWebService_WorkFlow   0
#define kWebService_ReturnBack 1
#define NOT_SELECTED -1

#import "BanLiItem.h"

@interface ReturnBackViewController : UIViewController<UIAlertViewDelegate,QQSectionHeaderViewDelegate>

@property (nonatomic,strong) NSArray *arySteps;
@property (nonatomic,strong) NSMutableArray *aryFilteredSteps;
@property (nonatomic,assign) NSInteger openSection;
@property(nonatomic,strong) BackStepItem *selUsrItem;
@property (nonatomic,strong) IBOutlet UITableView *stepTableView;
@property (nonatomic,strong) IBOutlet UITextView *txtView;

@property(nonatomic,copy)NSString *bzbh;

@property (nonatomic,assign) id<HandleGWDelegate> delegate;
@property (nonatomic,assign) NSInteger webServiceType; // 0 请求流转步骤 1 流转命令

@property(nonatomic,strong)NSURLConnHelper *webHelper;
@property(nonatomic,assign) BOOL canSignature;

-(IBAction)btnTransferPressed:(id)sender;

@end
