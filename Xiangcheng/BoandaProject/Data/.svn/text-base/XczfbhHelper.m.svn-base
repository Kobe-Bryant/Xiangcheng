//
//  XczfbhHelper.m
//  BoandaProject
//
//  Created by 张仁松 on 13-8-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "XczfbhHelper.h"
#import "GUIDGenerator.h"

@implementation XczfbhHelper

-(BOOL)hasCommitBL:(NSString*)wyrmc andTableName:(NSString*)tableName{
    [self openDataBase];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM xczfbh WHERE  TABLENAME='%@' and WRYMC='%@' and CJSJ = '%@'",tableName,wyrmc,dateString];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            
            [ary addObject:[rs stringForColumn:@"XCZFBH"]];
        }
    }];
    if([ary count] > 0)
        return YES;
    
    return NO;
}

-(NSString*)getXCZFBHByMc:(NSString*)wrymc{
    [self openDataBase];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM xczfbh WHERE  WRYMC='%@' and CJSJ = '%@' order by XCZFBH desc",wrymc,dateString];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            
            [ary addObject:[rs stringForColumn:@"XCZFBH"]];
        }
    }];
    if([ary count] > 0)
        return [ary objectAtIndex:0];
    return [GUIDGenerator generateBHByWryName:wrymc];
}

-(void)saveXCZFBH:(NSString*)xczfbh Wrymc:(NSString*)wrymc TableName:(NSString*)tableName{
    [self openDataBase];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *sqlDel = [NSString stringWithFormat:@"DELETE  from xczfbh WHERE   WRYMC='%@' and XCZFBH !='%@'",wrymc,xczfbh];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL res = [db executeUpdate:sqlDel];
        if(res == NO)
            NSLog(@"SQL ERROR:%@",sqlDel);
    }];
    
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO  xczfbh(WRYMC,XCZFBH,TABLENAME,CJSJ) values('%@','%@','%@', '%@')",wrymc,xczfbh,tableName, dateString];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL res = [db executeUpdate:sqlInsert];
        if(res == NO)
            NSLog(@"SQL ERROR:%@",sqlInsert);
        
    }];
}

@end
