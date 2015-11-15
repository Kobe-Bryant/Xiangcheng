//
//  HBSCHelper.h
//  BoandaProject
//
//  Created by 曾静 on 13-10-16.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"

@interface HBSCHelper : SqliteHelper



- (NSArray*) searchByFIDH:(NSString*)strFIDH;


- (NSArray*) searchByFGMC:(NSString*)keywords;

@end
