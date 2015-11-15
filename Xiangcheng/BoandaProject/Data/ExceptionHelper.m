//
//  ExceptionHelper.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "ExceptionHelper.h"

@implementation ExceptionHelper

-(BOOL)saveOneException:(NSString*)exception LoginUser:(NSString*)aLoginUser SoftInfo:(NSString*)info SBBH:(NSString*)sbbh{
    [self openDataBase];
    
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    NSDate *datex = [NSDate date];
    [customDateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *idstr = [customDateFormatter stringFromDate:datex];
    
    [customDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *cjsj = [customDateFormatter stringFromDate:datex];
    

    
    __block BOOL success = NO;
    NSString *sql = [NSString stringWithFormat:@"insert into T_EXCEPTION_RECORD(ID,USERID,SOFTINFO,SBBH,EXCEPTION,CJSJ,STATUS ) values(\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',0)",idstr,aLoginUser,info,sbbh,exception,cjsj];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return success;
}

-(BOOL)setExceptionSended:(NSString*)idStr{
    [self openDataBase];
    __block BOOL success = NO;
    NSString *sql = [NSString stringWithFormat:@"update  T_EXCEPTION_RECORD set STATUS=1 where ID = \'%@\'",idStr];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    return success;
}

-(NSArray*)getAllUnsendExceptions{
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from T_EXCEPTION_RECORD where STATUS = 1"];
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
