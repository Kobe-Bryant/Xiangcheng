//
//  UsersHelper.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "UsersHelper.h"
#import "UserItem.h"
#import "DataSyncTables.h"
@implementation UsersHelper

-(id)init{
    if(self = [super init]){
        
        NSArray *aryTables = [DataSyncTables tableNamesAry];
        for(NSString *table in aryTables){
            NSString *key = [DataSyncTables primaryKeyForTable:table];
            if([key length] > 0){
                [self deleteDupRecords:table byKeyColumn:key];
            }
        }
    }
    return self;
}

-(void)saveAllUsers:(NSArray *)aryUsers{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    int counts = aryUsers.count;
    NSDateFormatter *customDateFormatter = [[NSDateFormatter alloc] init];
    NSDate *datex = [NSDate date];
    [customDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *cjsj = [customDateFormatter stringFromDate:datex];

   
    __block BOOL success = NO;
    for(int i = 0 ;i < counts;i++){
        UserItem *aItem = [aryUsers objectAtIndex:i];
        if([aItem isKindOfClass:[UserItem class]]){
            NSString *sql = [NSString stringWithFormat:@"insert into T_MSG_RECORD(USERNAME,USERID,DEPARTMENT,CJSJ ) values(\'%@\',\'%@\',\'%@\',\'%@\')",aItem.userName,aItem.userID,aItem.userDepart,cjsj];
            [self.dbQueue inDatabase:^(FMDatabase *db) {
                success = [db executeUpdate:sql];
                
            }];
            if (success == NO){
                NSLog(@"error###exec sql:%@",sql);
            }
            
        }
        success = NO;
    }
}

-(NSArray*)queryAllUsers{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from  T_ADMIN_RMS_YH"];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}

- (NSString *)queryUserNameByID:(NSString *)userId
{
    if([userId isEqualToString:@"system"])
    {
        return @"系统管理员";
    }
    __block NSString *ret = @"";
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_YH where YHID='%@'", userId];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if (rs.next) {
            ret = [rs stringForColumn:@"YHMC"];
        }
        [rs close];
    }];
    return ret;
}
- (NSArray *)queryUserIDByZW:(NSString *)YHZW
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_YH where SFLD='%@'", YHZW];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}
- (NSString *)queryUserPositionByID:(NSString *)userId
{
    if([userId isEqualToString:@"system"])
    {
        return @"系统管理员";
    }
    __block NSString *ret = @"";
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_YH where YHID='%@'", userId];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if (rs.next) {
            ret = [rs stringForColumn:@"SFLD"];
        }
        [rs close];
    }];
    return ret;
}

- (NSArray *)queryAllRootDept
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where SJZZXH='%@' order by PXH ASC", @"ROOT"];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (NSArray *)queryAllDept
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG  order by PXH ASC"];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (BOOL)hasSubDept:(NSString *)deptStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    BOOL __block ret = NO;
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where SJZZXH='%@'", deptStr];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if(rs.next)
        {
            ret = YES;
        }
        [rs close];
    }];
    return ret;
}

- (NSArray *)queryAllSubDept:(NSString *)parentStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where SJZZXH='%@' order by PXH ASC", parentStr];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (NSArray *)queryAllUsers:(NSString *)deptStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_YH where BMBH='%@' order by PXH ASC", deptStr];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    return ary;
}

- (NSString *)queryParentDeptName:(NSString *)deptStr
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"select * from T_ADMIN_RMS_ZZJG where ZZBH=(select SJZZXH from T_ADMIN_RMS_ZZJG where ZZBH='%@');", deptStr];
    NSString __block *ret = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        ret = [rs stringForColumn:@"ZZQC"];
        [rs close];
    }];
    return ret;
}

- (void)clearAllData
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    NSString *sql1 = [NSString stringWithFormat:@"delete from %@", @"T_ADMIN_RMS_YH"];
    NSString *sql2 = [NSString stringWithFormat:@"delete from %@", @"T_ADMIN_RMS_ZZJG"];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql1];//一点要先清空用户表，然后再清空组织机构表
        [db executeUpdate:sql2];
    }];
}

@end
