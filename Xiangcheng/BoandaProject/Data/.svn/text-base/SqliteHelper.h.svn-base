//
//  SqliteHelper.h
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface SqliteHelper : NSObject{
    
    BOOL isDbOpening;
}
@property(nonatomic,strong) FMDatabaseQueue *dbQueue;
-(BOOL)openDataBase;

-(void)closeDataBase;

//获取数据库表的最后更新时间
-(NSString*)queryLastSyncTimeByTable:(NSString*)table;
//插入数据到本地数据库
-(void)insertTable:(NSString*)tableName andDatas:(NSArray*)aryItems;

-(void)deleteDupRecords:(NSString*)tableName byKeyColumn:(NSString*)column;

-(void)deleteAllRecords:(NSString*)tableName;

//转储数据
-(BOOL)reStoreRecordsFromTable:(NSString*)fromName toTable:(NSString*)toName;

//检查数据表是否有数据，有数据为YES
- (BOOL)checkRecords:(NSString *)tableName;
@end
