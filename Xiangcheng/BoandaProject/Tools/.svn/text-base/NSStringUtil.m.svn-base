//
//  NSStringUtil.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-9.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "NSStringUtil.h"

@implementation NSStringUtil

+(CGFloat)calculateTextHeight:(NSString*) text byFont:(UIFont*)font
                     andWidth:(CGFloat)width{
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 20;
    
}

+(CGFloat)calculateTextWidth:(NSString*) text byFont:(UIFont*)font
                   andHeight:(CGFloat)height{
    CGSize constraintSize = CGSizeMake(MAXFLOAT, height);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return size.width + 20;
}
+(CGFloat)getTextHeight:(NSString *)text byFont:(UIFont *)font andWidth:(CGFloat)width{
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
    
}


@end
