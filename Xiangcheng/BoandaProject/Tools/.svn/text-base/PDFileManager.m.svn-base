//
//  PDFileManager.h
//  文件管理（文件(夹)的创建、删除、移动）
//
//  Created by 曾静 on 13-9-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "PDFileManager.h"

@implementation PDFileManager

- (id)init
{
    if(self = [super init])
    {
        self.fileManager = [NSFileManager defaultManager];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"files"];
        if(![self directoryExistsAtPath:filePath])
        {
            [self createDirectoryAtPath:filePath];
        }
        self.basePath = filePath;
        if(![self directoryExistsAtPath:[self.basePath stringByAppendingPathComponent:@"默认文件夹"]])
        {
            [self createDirectoryAtPath:[self.basePath stringByAppendingPathComponent:@"默认文件夹"]];
        }
        self.defaultFolderPath = [self.basePath stringByAppendingPathComponent:@"默认文件夹"];
    }
    return self;
}

- (BOOL)directoryExistsAtPath:(NSString *)filePath
{
    BOOL isDir = NO;
    BOOL existed = [self.fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if(existed == YES && isDir == YES)
    {
        return YES;
    }
    return NO;
}

//文件移动
- (void)copyItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    if([self.fileManager fileExistsAtPath:toPath])
    {
        [self.fileManager removeItemAtPath:toPath error:nil];
    }
    [self.fileManager copyItemAtPath:fromPath toPath:toPath error:nil];
}

//文件删除
- (void)removeFileAtPath:(NSString *)filePath
{
    //默认文件不允许删除
    if([[filePath lastPathComponent] isEqualToString:@"默认文件夹"])
    {
        return;
    }
    if([self.fileManager fileExistsAtPath:filePath])
    {
        [self.fileManager removeItemAtPath:filePath error:nil];
    }
}

//创建文件夹
- (int)createDirectoryAtPath:(NSString *)filePath
{
    if(![self directoryExistsAtPath:filePath])
    {
        BOOL ret = [self.fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        if(ret)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return -1;
    }
}

//删除文件夹
- (void)removeDirectoryAtPath:(NSString *)filePath
{
    if(![self directoryExistsAtPath:filePath])
    {
        return;
    }
    NSArray *contents = [self.fileManager contentsOfDirectoryAtPath:filePath error:nil];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        [self.fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
    }
    if([[filePath lastPathComponent] isEqualToString:@"默认文件夹"])
    {
        return;
    }
    [self.fileManager removeItemAtPath:filePath error:nil];
}

- (NSArray *)fileListAtPath:(NSString *)filePath
{
    if(![self directoryExistsAtPath:filePath])
    {
        return nil;
    }
    NSArray *contents = [self.fileManager contentsOfDirectoryAtPath:filePath error:nil];
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    for(NSString *name in contents)
    {
        if([@".DS_Store" isEqualToString:name])
        {
            continue;
        }
        if([filePath isEqualToString:self.basePath])
        {
            BOOL isDir = NO;
            [self.fileManager fileExistsAtPath:[filePath stringByAppendingPathComponent:name] isDirectory:&isDir];
            if(isDir)
            {
                continue;
            }
        }
        [ary addObject:name];
    }
    return ary;
}

- (NSArray *)directoryListAtPath:(NSString *)filePath
{
    BOOL isDir = NO;
    BOOL existed = [self.fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if(!(existed&&isDir))
    {
        return nil;
    }
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    NSArray *contents = [self.fileManager contentsOfDirectoryAtPath:filePath error:nil];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        NSString *subFilePath = [filePath stringByAppendingPathComponent:filename];
        BOOL isSubDir = NO;
        [self.fileManager fileExistsAtPath:subFilePath isDirectory:&isSubDir];
        if(isSubDir)
        {
            [ary addObject:filename];
        }
    }
    return ary;
}

@end
