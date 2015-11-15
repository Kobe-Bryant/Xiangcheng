//
//  DataSyncTables.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSyncTables : NSObject
+(NSArray*)tableNamesAry;
+(NSString*)primaryKeyForTable:(NSString*)tableName;
@end
