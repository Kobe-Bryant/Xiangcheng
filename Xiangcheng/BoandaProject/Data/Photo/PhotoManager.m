//
//  PhotoManager.m
//  BoandaProject
//
//  Created by Alex Jean on 13-8-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PhotoManager.h"

@implementation PhotoManager

- (void)uploadPhotos:(NSArray *)photoList
{
    //TODO:上传
    
    //上传完毕删除全部图片
    [self deletePhotos:photoList];
}

//删除图片
- (void)deletePhotos:(NSArray *)photoList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(NSString *path in photoList)
    {
        if([fileManager fileExistsAtPath:path])
        {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
}

//图片重命名
- (void)renamePhotoFromPath:(NSString *)from toPath:(NSString *)to
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:from] == YES && [fileManager fileExistsAtPath:to] == NO)
    {
        [fileManager moveItemAtPath:from toPath:to error:nil];
    }
}

@end
