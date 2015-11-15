//
//  LocationItem.h
//  BoandaProject
//
//  Created by Alex Jean on 13-7-30.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationItem : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *createTime;

@end
