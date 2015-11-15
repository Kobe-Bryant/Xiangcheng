//
//  NdUncaughtExceptionHandler.h
//  GuoToOA
//
//  Created by 张仁松 on 13-6-27.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NdUncaughtExceptionHandler : NSObject {
    
     BOOL dismissed;
    
}

+ (void)setDefaultHandler;

+ (NSUncaughtExceptionHandler*)getHandler;

- (void)handleException:(NSString*)exception;

@property(nonatomic,copy)NSString *exception;
@end