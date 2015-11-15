//
//  LocationHelper.h
//  BoandaProject
//
//  Created by Alex Jean on 13-7-30.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteHelper.h"
#import "LocationItem.h"

@interface LocationHelper : SqliteHelper

- (void)addLocation:(LocationItem *)item;

@end
