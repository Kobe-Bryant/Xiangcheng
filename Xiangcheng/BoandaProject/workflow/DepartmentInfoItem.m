//
//  DepartmentInfoItem.m
//  GuangXiOA
//
//  Created by sz apple on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DepartmentInfoItem.h"

@implementation DepartmentInfoItem
@synthesize number,name;

- (DepartmentInfoItem *)init {
    self = [super init];
    if (self) {
        self.number = @"";
        self.name = @"";
    }
    return self;
}
@end
