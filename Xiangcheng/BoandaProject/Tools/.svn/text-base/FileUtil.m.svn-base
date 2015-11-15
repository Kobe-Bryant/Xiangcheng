//
//  FileUtil.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

+(UIImage*)imageForFileExt:(NSString*)pathExt{
    if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        return  [UIImage imageNamed:@"pdf_file.png"];
    else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        return [UIImage imageNamed:@"doc_file.png"];
    else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        return [UIImage imageNamed:@"xls_file.png"];
    else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        return [UIImage imageNamed:@"rar_file.png"];
    else
        return [UIImage imageNamed:@"default_file.png"];
}

+(NSString*)documentDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(NSString*)tmpDir{
    return NSTemporaryDirectory();
}
@end
