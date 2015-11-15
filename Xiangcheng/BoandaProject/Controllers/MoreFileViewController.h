//
//  MoreFileViewController.h
//  BoandaProject
//
//  Created by BOBO on 13-12-23.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MoreFileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithFile:(NSDictionary*)fileDic andType:(NSString*)type;
@end
