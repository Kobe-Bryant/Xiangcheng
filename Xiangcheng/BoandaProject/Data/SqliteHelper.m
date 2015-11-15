//
//  SqliteHelper.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "SqliteHelper.h"
#import "SystemConfigContext.h"
#import "FMDatabaseAdditions.h"
#import "NSDateUtil.h"
@implementation SqliteHelper
@synthesize dbQueue;
//打开数据源

-(BOOL)openDataBase{
    if (isDbOpening)
        return YES;
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask
                                                                , YES);
    NSString *dbName = [[SystemConfigContext sharedInstance] getString:@"DBName"];
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:databaseFilePath];
    if (dbQueue == nil) {
        return NO;
    }
    isDbOpening = YES;
    //数据库表创建检测
    [self checkSystemTables];
    
    //添加初始化数据
    [self addInitialDatas];
    return YES;
}

//关闭数据源
-(void)closeDataBase{
    if (isDbOpening) {
        [dbQueue close];
        isDbOpening = false;
    }
}

//数据库表创建检测
-(void)checkSystemTables{
    
    NSArray *sqlAry = [[SystemConfigContext sharedInstance] getResultItems:@"DbTables"];
    int counts = sqlAry.count;
    
    __block BOOL success = NO;
    for(int i = 0 ;i < counts;i++){
        NSString *sql = [sqlAry objectAtIndex:i];
        
        [dbQueue inDatabase:^(FMDatabase *db) {
            success = [db executeUpdate:sql];
            
        }];
        if (success == NO){
            NSLog(@"error###exec sql:%@",sql);
        }
        success = NO;
    }
}

-(void)addInitialDatas{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *flag = [defaults objectForKey:@"AddInitDatas"];
    if([flag isEqualToString:@"1"])
        return;//初始化数据已经添加过了
    NSArray *sqlAry = [[SystemConfigContext sharedInstance] getResultItems:@"InitialDatas"];
    int counts = sqlAry.count;
    
    __block BOOL success = NO;
    for(int i = 0 ;i < counts;i++){
        NSString *sql = [sqlAry objectAtIndex:i];
        
        [dbQueue inDatabase:^(FMDatabase *db) {
            success = [db executeUpdate:sql];
            
        }];
        if (success == NO){
            NSLog(@"error###exec sql:%@",sql);
        }
        success = NO;
    }
    [defaults setObject:@"1" forKey:@"AddInitDatas"];
}

-(NSString*)queryLastSyncTimeByTable:(NSString*)table{
    NSString *__block cjsj = @"2000-01-01 10:00:00";//如果查找不到更新时间，就用这个时间
    NSString *__block xgsj = @"2000-01-01 10:00:00";
    if(isDbOpening == NO){
        [self openDataBase];
    }
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT ifnull(MAX(XGSJ),'2000-01-01 10:00:00') as XGSJ,ifnull(MAX(CJSJ),'2000-01-01 10:00:00') as CJSJ from  %@",table];
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            cjsj = [rs stringForColumn:@"CJSJ"];
            xgsj = [rs stringForColumn:@"XGSJ"];
        }
        [rs close];
    }];
    
    
    NSDate *cjsjDate = [NSDateUtil dateFromString:cjsj andTimeFMT:@"yyyy-MM-dd HH:mm:ss"];
    if(cjsjDate == nil)
        cjsjDate =[NSDateUtil dateFromString:cjsj andTimeFMT:@"yyyyMMddHHmmss"];
    NSDate *xgsjDate = [NSDateUtil dateFromString:xgsj andTimeFMT:@"yyyy-MM-dd HH:mm:ss"];
    if(xgsjDate == nil)
        xgsjDate =[NSDateUtil dateFromString:xgsj andTimeFMT:@"yyyyMMddHHmmss"];
    
    if(xgsjDate==nil ){
        if(cjsjDate == nil)
            return @"2000-01-01 10:00:00";
        else
            return cjsj;
    }
    else{
        if(cjsjDate == nil)
            return xgsj;
        else{
            if([cjsjDate compare:xgsjDate] == NSOrderedAscending)
                return xgsj;
            else
                return cjsj;
        }
    }
    
    
}


-(void)insertTable:(NSString*)tableName andDatas:(NSArray*)aryItems{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    if(aryItems == nil || [aryItems count] == 0 )
        return;
    NSMutableString *sqlstr = [NSMutableString stringWithCapacity:100];
    NSMutableString *fieldStr = [NSMutableString stringWithCapacity:50];
    NSMutableString *valueStr = [NSMutableString stringWithCapacity:50];
    FMDatabase *db = [dbQueue database];
    if(db == nil)return;
    [db beginTransaction];
    for(NSDictionary *dic in aryItems){
        
        NSArray *aryKeys = [dic allKeys];
        //NSInteger *fieldCount = [aryKeys count];
        
        for(NSString *field in aryKeys){
            //查看是否有该列
           // if([db columnExists:field inTableWithName:tableName])
            {
                [fieldStr appendFormat:@"%@,",field];
                [valueStr appendFormat:@"'%@',",[dic objectForKey:field]];
            }
            
        }
        if([fieldStr length] >0 && [valueStr length] >0){
            [sqlstr appendFormat:@"insert into %@(%@) values(%@)",tableName,[fieldStr substringToIndex:([fieldStr length]-1)],[valueStr substringToIndex:([valueStr length]-1)]];
            NSLog(@"data:%@",sqlstr);
            // [dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:sqlstr];
            //  }];
        }
        
        
        
        [fieldStr setString:@""];
        [valueStr setString:@""];
        [sqlstr setString:@""];
        
    }
    [db commit];
    //[db close];
}

//delete from t_admin_rms_zzjg where zzbh in (select ZZBH from  t_admin_rms_zzjg group by ZZBH) and rowid not in (select max(rowid) from  t_admin_rms_zzjg group by ZZBH)
-(void)deleteDupRecords:(NSString*)tableName byKeyColumn:(NSString*)column{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ in (select %@ from  %@ group by %@) and rowid not in (select max(rowid) from  %@ group by %@)",tableName,column,column,tableName,column,tableName,column];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    
}

-(BOOL)reStoreRecordsFromTable:(NSString*)fromName toTable:(NSString*)toName{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    //NSString *sql01 = [NSString stringWithFormat:@"delete from %@", toName];
    NSString *sql02 = [NSString stringWithFormat:@"insert into %@ select * from %@", toName, fromName];
    NSString *sql03 = [NSString stringWithFormat:@"delete from %@", fromName];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  BOOL ret01 = [db executeUpdate:sql01];//清空目标表
        BOOL ret02 = [db executeUpdate:sql02];//复制表
        BOOL ret03 = [db executeUpdate:sql03];//清空临时表
        success =  ret02 & ret03;
    }];
    return success;
}

- (BOOL)checkRecords:(NSString *)tableName
{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        //FMResultSet *rs = [db executeQuery:sql];
        FMResultSet *rs =[db executeQuery:@"select * from T_ADMIN_RMS_YH"];
        success = rs.next;
        //[rs close];
    }];
    return success;
}

-(void)deleteAllRecords:(NSString*)tableName{
    if(isDbOpening == NO){
        [self openDataBase];
    }
    __block BOOL success = NO;
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ ",tableName];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        success = [db executeUpdate:sql];
        
    }];
    if (success == NO){
        NSLog(@"error###exec sql:%@",sql);
    }
    
}
@end
