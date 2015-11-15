//
//  MsgsHelper.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "MsgsHelper.h"

@implementation MsgsHelper
-(BOOL)saveOneMsg:(NSString*)msg LoginUser:(NSString*)aLoginUser TalkUser:(NSString*)aTalkUser sendTime:(NSString*)cjsj{
    [self openDataBase];
   
    
    __block BOOL success = NO;
     NSString *sql = [NSString stringWithFormat:@"insert into T_MSG_RECORD(LOGINUSER,TALKUSER,MSG,CJSJ ) values(\'%@\',\'%@\',\'%@\',\'%@\')",aLoginUser,aTalkUser,msg,cjsj];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return success;
}

-(NSArray*)queryByLoginUser:(NSString*)aLoginUser TalkUser:(NSString*)aTalkUser{
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from T_MSG_RECORD where LOGINUSER = \'%@\' and TALKUSER = \'%@\'",aLoginUser,aTalkUser];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}
@end
