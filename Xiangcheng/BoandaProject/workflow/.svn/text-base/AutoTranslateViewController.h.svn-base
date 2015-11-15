//
//  AutoTranslateViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-9-10.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandleGWProtocol.h"
#import "NSURLConnHelper.h"

@interface AutoTranslateViewController : UIViewController

@property (nonatomic, copy) NSString *LCLXBH;//(流程类型编号)
@property (nonatomic, copy) NSString *BZDYBH;//(步骤定义编号)
@property (nonatomic, copy) NSString *BZBH;//(步骤编号)
@property (nonatomic, copy) NSString *LCSLBH;//(流程编号)
@property (nonatomic, copy) NSString *processer ;//(当前步骤处理人)
@property (nonatomic, copy) NSString *processType;//(当前步骤处理类型)
@property (strong, nonatomic) IBOutlet UITextView *opinionView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;


@property (nonatomic, assign) id<HandleGWDelegate> delegate;
@property (nonatomic, strong) NSURLConnHelper *webHelper;

@end
