//
//  LocationHelper.m
//  BoandaProject
//
//  Created by Alex Jean on 13-7-30.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

- (void)addLocation:(LocationItem *)item
{
    if(isDbOpening == NO)
    {
        [self openDataBase];
    }
    NSString *sql = [NSString stringWithFormat:@"insert into T_USER_LOCATION(USERID,LAT,LON,CREATETIME) values('%@','%@','%@','%@')", item.userId, item.lat, item.lon, item.createTime];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

@end
