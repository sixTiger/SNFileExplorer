//
//  XXBFileExplorerUtils.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "XXBFileExplorerUtils.h"

/**
 判断对象是否为空
 
 @param value 要判断得对象
 @return 是/否
 */
extern BOOL isNull_XXBFE(id value) {
    if (!value) return YES;
    if ([value isKindOfClass:[NSNull class]]) return YES;
    return NO;
}

/**
 判断字符串是否为空
 
 @param value 要判断得字符串
 @return 是/否
 */
extern BOOL isEmpty_XXBFE(id value) {
    if (!value) return YES;
    if ([value isKindOfClass:[NSNull class]]) return YES;
    if ([value isKindOfClass:[NSString class]]) return [value length] == 0;
    return NO;
}

extern XXBFileType getFileType_XXBFE(NSString *path) {
    BOOL isDir = NO;
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!isFileExist) {
        //文件不存在
        return XXBFileTypeUnknown;
    } else {
        if (isDir) {
            //是文件夹
            return XXBFileTypeFinder;
        } else {
            //不是文件夹
            return XXBFileTypeFile;
        }
    }
}

/**
 获取文件对应得Emoji
 
 @param fileType 文件得类型
 @return Emoji
 */
extern NSString* getEmojiString_XXBFE(XXBFileType fileType) {
    NSString *emojiString = @"🗂";
    switch (fileType) {
        case XXBFileTypeUnknown:
            emojiString = @"❓";
            break;
        case XXBFileTypeFile:
            emojiString = @"📑";
            break;
        case XXBFileTypeFinder:
            emojiString = @"🗂";
            break;
            
        default:
            break;
    }
    return emojiString;
}

/**
 获取当前路径得所有文件
 
 @param path 当前得路径
 @param error 错误信息
 @return 所有得字路径
 */
extern NSArray* getSubFilesFromPath_XXBFE(NSString *path, NSError **error) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subFiles = [fileManager contentsOfDirectoryAtPath:path error:error];
    return subFiles;
}

/**
 删除文件
 
 @param path 文件路径
 @param error error
 @return 删除成功/失败
 */
extern BOOL deleteFail_XXBFE(NSString *path, NSError **error) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:error];
}

@implementation XXBFileExplorerUtils

@end
