//
//  OperateLogHelper.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "SqliteHelper.h"

@interface OperateLogHelper : SqliteHelper
-(BOOL)saveOperate:(NSString*)webservice andUserID:(NSString*)userid;
@end
