//
//  PDFileManager.h
//  文件管理（文件(夹)的创建、删除、移动）
//
//  Created by 曾静 on 13-9-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFileManager : NSObject

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, copy) NSString *defaultFolderPath;

- (id)init;

- (BOOL)directoryExistsAtPath:(NSString *)filePath;

//文件移动
- (void)copyItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

//文件删除
- (void)removeFileAtPath:(NSString *)filePath;

//创建文件夹
- (int)createDirectoryAtPath:(NSString *)filePath;

//删除文件夹
- (void)removeDirectoryAtPath:(NSString *)filePath;

- (NSArray *)fileListAtPath:(NSString *)filePath;

- (NSArray *)directoryListAtPath:(NSString *)filePath;

@end
