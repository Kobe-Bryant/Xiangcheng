//
//  NSExceptionSender.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "NSExceptionSender.h"
#import "ExceptionHelper.h"
#import "ServiceUrlString.h"

@implementation NSExceptionSender

-(void)startSendThread{
    ExceptionHelper *helper = [[ExceptionHelper alloc] init];
    NSArray *aryToSend = [helper getAllUnsendExceptions];
    if(aryToSend == nil || [aryToSend count] == 0)
        return;
    
    for(NSDictionary *item in aryToSend){
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"INSERT_EXCEPTION" forKey:@"service"];
        [params setObject:[item objectForKey:@"USERID"] forKey:@"userId"];
        [params setObject:[item objectForKey:@"SOFTINFO"]  forKey:@"softInfo"];
        [params setObject:[item objectForKey:@"SBBH"]  forKey:@"sbbh"];
        [params setObject:[item objectForKey:@"EXCEPTION"]  forKey:@"exception"];
        
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        
        NSString *resultStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:strUrl] encoding:NSUTF8StringEncoding error:nil];
        
        //如果返回有数据，默认提交正确，去掉这个错误日志
        if([resultStr length] > 0){
            [helper setExceptionSended:[item objectForKey:@"ID"]];
        }
    }
}

-(void)sendExceptions{
   
    [NSThread detachNewThreadSelector:@selector(startSendThread) toTarget:self withObject:nil];
}

@end
