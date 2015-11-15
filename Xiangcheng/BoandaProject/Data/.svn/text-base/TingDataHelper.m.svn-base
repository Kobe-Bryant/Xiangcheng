//
//  TingDateHelper.m
//  BoandaProject
//
//  Created by Alex Jean on 13-8-26.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "TingDataHelper.h"
#import "TingDepartmentInfoItem.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

@implementation TingDataHelper

static TingDataHelper *_singletonInstace = nil;

+ (TingDataHelper *)shareInstace
{
    @synchronized(self)
    {
        if(_singletonInstace == nil)
        {
            _singletonInstace = [[TingDataHelper alloc] init];
        }
    }
    return _singletonInstace;
}

- (NSArray *)getTingDeptList
{
    if (departmentInfoAry ) {
        return departmentInfoAry;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_BMLIST" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSString *resultJSON = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    
    if (tmpParsedJsonAry == nil || [tmpParsedJsonAry count] <=0) {
        return nil;
    }
    NSMutableArray* departAry = [[NSMutableArray alloc] init];
    TingDepartmentInfoItem *infoItem;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        for (NSDictionary *aItem in tmpParsedJsonAry) {
            infoItem = [[TingDepartmentInfoItem alloc] init];
            infoItem.name = [[aItem objectForKey:@"ZZJC"] copy];
            infoItem.number = [[aItem objectForKey:@"ZZBH"] copy];
            //  NSLog(@"%@ %@ ",infoItem.name,infoItem.number);
            [departAry addObject:infoItem];
        }
    }
    
    NSComparator sortingBlock = ^(id obj1, id obj2) {
        
        if ([self compareDepartment:[obj1 valueForKey:@"name"] withAnotherDep:[obj2 valueForKey:@"name"]]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedDescending;
    };
    
    departmentInfoAry = [departAry sortedArrayUsingComparator:sortingBlock];
    if([departmentInfoAry count] > 25)
        departmentInfoAry = [departmentInfoAry subarrayWithRange:NSMakeRange(0, 25)];
    return departmentInfoAry;
}



- (BOOL)compareDepartment:(NSString*)dep1 withAnotherDep:(NSString*)dep2
{
    NSDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:30];
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"办公室"];
    [dic setValue:[NSNumber numberWithInt:2] forKey:@"规财处"];
    [dic setValue:[NSNumber numberWithInt:3] forKey:@"法规处"];
    [dic setValue:[NSNumber numberWithInt:4] forKey:@"科标处"];
    [dic setValue:[NSNumber numberWithInt:5] forKey:@"总量处"];
    [dic setValue:[NSNumber numberWithInt:6] forKey:@"环评处"];
    [dic setValue:[NSNumber numberWithInt:7] forKey:@"污防处"];
    [dic setValue:[NSNumber numberWithInt:8] forKey:@"生态处"];
    [dic setValue:[NSNumber numberWithInt:9] forKey:@"辐射处"];
    [dic setValue:[NSNumber numberWithInt:10] forKey:@"监测处"];
    [dic setValue:[NSNumber numberWithInt:11] forKey:@"人事处"];
    [dic setValue:[NSNumber numberWithInt:12] forKey:@"机关党委"];
    [dic setValue:[NSNumber numberWithInt:13] forKey:@"监察室"];
    [dic setValue:[NSNumber numberWithInt:14] forKey:@"总队"];
    [dic setValue:[NSNumber numberWithInt:15] forKey:@"监测站"];
    [dic setValue:[NSNumber numberWithInt:16] forKey:@"辐射站"];
    [dic setValue:[NSNumber numberWithInt:17] forKey:@"环科院"];
    [dic setValue:[NSNumber numberWithInt:18] forKey:@"宣教中心"];
    [dic setValue:[NSNumber numberWithInt:19] forKey:@"记者站"];
    [dic setValue:[NSNumber numberWithInt:20] forKey:@"北海站"];
    [dic setValue:[NSNumber numberWithInt:21] forKey:@"金花茶管理处"];
    [dic setValue:[NSNumber numberWithInt:22] forKey:@"固废中心"];
    [dic setValue:[NSNumber numberWithInt:23] forKey:@"技术中心"];
    [dic setValue:[NSNumber numberWithInt:24] forKey:@"信息中心"];
    [dic setValue:[NSNumber numberWithInt:25] forKey:@"机关服务中心"];
    
    NSNumber *number1 = [dic objectForKey:dep1];
    NSNumber *number2 = [dic objectForKey:dep2];
    if(number1 == nil) number1 = [NSNumber numberWithInt:INT32_MAX];
    if(number2 == nil) number2 = [NSNumber numberWithInt:INT32_MAX];
    if ([number1 intValue] < [number2 intValue]) return TRUE;
    return FALSE;
}

@end
