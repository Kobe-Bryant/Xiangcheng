//
//  DataSyncManager.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataSyncManager.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "DataSyncTables.h"
#import "DataSyncHandleDatas.h"
#import "ServiceUrlString.h"
#import "SqliteHelper.h"


@implementation DataSyncManager
@synthesize networkQueue,pregress,aryHandlers;


-(void)handleRecvedDatas:(NSDictionary*)dicData{
    NSInteger tag = [[dicData objectForKey:@"TAGID"] integerValue];
    NSString *data = [dicData objectForKey:@"DATA"];
    DataSyncHandleDatas *handler = [[DataSyncHandleDatas alloc] initWithDatas:data andParserTag:tag completionHandler:^(NSInteger tag){
        [aryHandlers addObject:[NSNumber numberWithInt:tag]];
    }];
    [handler parseAndSave];
    
}

- ( void )requestDone:(ASIHTTPRequest *)request
{
    //如果数据量很大 返回的xml 用########隔开
    NSArray *xmlStrAry = [request.responseString componentsSeparatedByString:@"########"];
    for(NSString *xmlstr in xmlStrAry){
        NSRange range = [xmlstr rangeOfString:@"<?xml"];
        if(NSNotFound == range.location)
            continue;
        NSString *childxmlstr = [xmlstr substringFromIndex:range.location];
        count++;
        NSDictionary *dicData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:childxmlstr,[NSNumber numberWithInt:count], nil] forKeys:[NSArray arrayWithObjects:@"DATA",@"TAGID",nil]];
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(handleRecvedDatas:) object:dicData];
        
        // [aryParseDataThreads addObject:thread];
        [thread start];
        /* [self handleRecvedDatas:childxmlstr];*/
        //[NSThread detachNewThreadSelector:@selector(handleRecvedDatas:) toTarget:self withObject:childxmlstr];
    }
    NSLog(@"同步待处理条数：%d条", count);
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter  defaultCenter] postNotificationName:kNotifyDataSyncFailed object:self];
}

-(void) allSyncFinished :(ASINetworkQueue *)queue{
    sleep(1);
    
    BOOL wait = YES;
    //当所有处理数据的线程都存储完毕了，才能发送finish的消息
    
    while (wait) {
        
        if([aryHandlers count] == count){
            wait = NO;
            
        }
        else{
            wait = YES;
            sleep(1);
        }
    }
    
    SqliteHelper *dbHelper = [[SqliteHelper alloc] init];
    NSArray *aryTables = [DataSyncTables tableNamesAry];
    //将临时表数据转移
    for(NSString *table in aryTables)
    {
        [dbHelper reStoreRecordsFromTable:[NSString stringWithFormat:@"%@_TEMP", table] toTable:table];
    }
    //去除重复数据
    
    for(NSString *table in aryTables)
    {
        NSString *key = [DataSyncTables primaryKeyForTable:table];
        if([key length] > 0)
        {
            [dbHelper deleteDupRecords:[NSString stringWithFormat:@"%@", table] byKeyColumn:key];
        }
    }
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *currentSyncTime = [df stringFromDate:now];
    [[NSUserDefaults standardUserDefaults] setObject:currentSyncTime forKey:kLastSyncDate];
    [[NSUserDefaults standardUserDefaults] setObject:@"loaded" forKey:kLoadHbsc];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter  defaultCenter] postNotificationName:kNotifyDataSyncFininshed object:self];
}

-(BOOL)syncAllTables:(BOOL)now{
    
    if(now == NO){
        //获取上一次同步的时间,如果上一次同步的时间和当前时间间隔比较如果大于7天，立即同步数据
        NSString *lastSyncTime = [[NSUserDefaults standardUserDefaults] stringForKey:kLastSyncDate];
        if(lastSyncTime.length > 0)
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [df dateFromString:lastSyncTime];
            NSTimeInterval timeInterval = [date timeIntervalSinceNow];
            if(timeInterval < 7*24*60*60)
            {
                return NO;
            }
        }
    }
    
    
    NSArray *aryTables = [DataSyncTables tableNamesAry];
    //////////////////////////// 任务队列 /////////////////////////////
    if (! networkQueue ) {
        self.networkQueue = [[ ASINetworkQueue alloc ] init ];
    }
    if(pregress)
        [networkQueue setDownloadProgressDelegate:pregress];
    [networkQueue setShowAccurateProgress:YES];
    [ networkQueue reset ]; // 队列清零
    [ networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DATASYNC_REQUEST" forKey:@"service"];
    if(aryHandlers == nil)
        self.aryHandlers = [NSMutableArray arrayWithCapacity:5];
    count = 0;
    ASIHTTPRequest *request;
    SqliteHelper *dbHelper = [[SqliteHelper alloc] init];
    for(NSString *table in aryTables){
        [params setObject:table forKey:@"table"];
        [params setObject:[dbHelper queryLastSyncTimeByTable:table] forKey:@"lastSyncTime"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        request = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :strUrl]];
        [request setDelegate:self];
        [request setDidFinishSelector: @selector (requestDone:)];
        [request setDidFailSelector: @selector (requestWentWrong:)];
        [ networkQueue addOperation :request];
        
    }
    [networkQueue go ]; // 队列任务开始
    return YES;
}

-(BOOL)syncDataByTable:(NSString*)tableName{
    return YES;
}

-(void)cancel
{
    if(networkQueue)
        [self.networkQueue cancelAllOperations];
}

-(void)reSyncAllTables{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kLoadHbsc];
    NSArray *aryTables = [DataSyncTables tableNamesAry];
    SqliteHelper *helper = [[SqliteHelper alloc] init];
    for(NSString *table in aryTables)
    {
        [helper deleteAllRecords:table];
    }
    [self syncAllTables:YES];
    
    
}

@end
