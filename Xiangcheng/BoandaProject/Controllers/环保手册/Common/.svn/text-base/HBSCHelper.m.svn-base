//
//  HBSCHelper.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "HBSCHelper.h"

@implementation HBSCHelper

- (NSArray*) searchByFIDH:(NSString*)strFIDH{
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
   NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM T_YDZF_FLFG WHERE FIDH = '%@'  order by PXH",strFIDH];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}


- (NSArray*) searchByFGMC:(NSString*)keywords{
    [self openDataBase];
    
    
    NSMutableArray *__block ary = [[NSMutableArray alloc] initWithCapacity:40];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM T_YDZF_FLFG WHERE FGMC like '%%%@%%%%' and SFML ='0' order by PXH ",keywords];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            [ary addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return ary;
}
@end
