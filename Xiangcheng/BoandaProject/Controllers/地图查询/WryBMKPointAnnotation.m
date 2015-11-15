//
//  WryBMKPointAnnotation.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WryBMKPointAnnotation.h"

@implementation WryBMKPointAnnotation
@synthesize infoItem,title,subtitle;
- (CLLocationCoordinate2D)coordinate
{
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

@end
