//
//  TaskActionBaseViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-8-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseViewController.h"
#import "HandleGWProtocol.h"
@interface TaskActionBaseViewController : BaseViewController<HandleGWDelegate>
@property (nonatomic,assign)BOOL bOKFromTransfer;
@end
