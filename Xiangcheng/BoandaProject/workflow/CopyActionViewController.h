//
//  CopyActionViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-9-10.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"

@interface CopyActionViewController : UIViewController <NSURLConnHelperDelegate,UITableViewDataSource, UITableViewDelegate,QQSectionHeaderViewDelegate>

@property (nonatomic, copy) NSString *LCLXBH;//(流程类型编号)
@property (nonatomic, copy) NSString *BZDYBH;//(步骤定义编号)
@property (nonatomic, copy) NSString *BZBH;//(步骤编号)
@property (nonatomic, copy) NSString *LCSLBH;//(流程编号)
@property (nonatomic, copy) NSString *processer ;//(当前步骤处理人)
@property (nonatomic, copy) NSString *processType;//(当前步骤处理类型)

@property (nonatomic, assign) id<HandleGWDelegate> delegate;
@property (nonatomic, strong) NSURLConnHelper *webHelper;

@property (nonatomic,assign) NSInteger openSection;
@property (strong, nonatomic) IBOutlet UITableView *usersTableView;
@property (strong, nonatomic) IBOutlet UITextView *opinionView;
- (IBAction)sendButtonClick:(id)sender;

@end
