//
//  OperateLogHelper.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-22.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "OperateLogHelper.h"

@implementation OperateLogHelper

-(BOOL)saveOperate:(NSString*)webservice andUserID:(NSString*)userid{
    
#ifdef Save_OperateLog
    [self openDataBase];
    
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    NSDate *datex = [NSDate date];
    [customDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *cjsj = [customDateFormatter stringFromDate:datex];    
    
    __block BOOL success = NO;
    NSString *sql = [NSString stringWithFormat:@"insert into T_OPERATE_LOG(USERID,WEBSERVICE,CJSJ ) values(\'%@\',\'%@\',\'%@\')",userid,webservice,cjsj];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return success;
#else
    return YES;
#endif
    
    
}
@end
