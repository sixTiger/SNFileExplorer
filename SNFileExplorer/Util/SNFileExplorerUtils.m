//
//  XXBFileExplorerUtils.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "SNFileExplorerUtils.h"
#import "SNFileModel.h"

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

extern SNFileType getFileType_XXBFE(NSString *path) {
    BOOL isDir = NO;
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!isFileExist) {
        //文件不存在
        return SNFileTypeUnknown;
    } else {
        if (isDir) {
            //是文件夹
            return SNFileTypeFinder;
        } else {
            //不是文件夹
            return SNFileTypeFile;
        }
    }
}

/**
 获取文件对应得Emoji
 
 @param fileType 文件得类型
 @return Emoji
 */
extern NSString* getEmojiString_XXBFE(SNFileType fileType) {
    NSString *emojiString = @"🗂";
    switch (fileType) {
        case SNFileTypeUnknown:
            emojiString = @"❓";
            break;
        case SNFileTypeFile:
            emojiString = @"📑";
            break;
        case SNFileTypeFinder:
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
extern BOOL deleteFile_XXBFE(NSString *path, NSError **error) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:error];
}

/**
 删除文件 级联删除(这个从操作比较耗时，会遍历当前目录的所有z子目录，挨个删除)
 
 @param path 文件路径
 */
extern void deleteFile_r_f_XXBFE(NSString *path) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //直接删除
    [fileManager removeItemAtPath:path error:nil];
    //判断字符串是否为文件/文件夹
    BOOL dir = NO;
    BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&dir];
    //文件/文件夹不存在
    if (exists == NO) {
        return;
    }
    //path是文件夹
    if (dir) {
        // 删除文件夹失败，删除文件夹里边的内容
        //遍历文件夹中的所有内容
        NSArray *subpaths = [fileManager subpathsAtPath:path];
        //计算文件夹大小
        for (NSString *subpath in subpaths) {
            //拼接全路径
            NSString *fullSubPath = [path stringByAppendingPathComponent:subpath];
            [fileManager removeItemAtPath:fullSubPath error:nil];
        }
    }
}

/**
 获取文件的真实大小
 
 @param path 文件路径
 @return 文件的真实大小
 */
extern unsigned long long getFileSize_XXBFE(NSString *path) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断字符串是否为文件/文件夹
    BOOL dir = NO;
    BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&dir];
    //文件/文件夹不存在
    if (exists == NO) {
        return 0;
    }
    //path是文件夹
    if (dir) {
        //遍历文件夹中的所有内容
        NSArray *subpaths = [fileManager subpathsAtPath:path];
        //计算文件夹大小
        unsigned long long totalByteSize = 0;
        for (NSString *subpath in subpaths) {
            //拼接全路径
            NSString *fullSubPath = [path stringByAppendingPathComponent:subpath];
            //判断是否为文件
            BOOL dir = NO;
            [fileManager fileExistsAtPath:fullSubPath isDirectory:&dir];
            if (dir == NO){//是文件
                NSDictionary *attr = [fileManager attributesOfItemAtPath:fullSubPath error:nil];
                totalByteSize += attr.fileSize;
            } else {
                //如果还是文件夹不需要处理
                //例如 "Documents"是文件夹，会有"Documents/***"得子项再下边
            }
        }
        return totalByteSize;
    } else {
        //是文件
        NSDictionary *attr = [fileManager attributesOfItemAtPath:path error:nil];
        return attr.fileSize;
    }
}
@implementation SNFileExplorerUtils

/**
 分享文件
 
 @param fileModel 要分享的文件
 @param controller 分享这个文件的controller
 */
+ (void)shareFile:(SNFileModel *)fileModel withController:(UIViewController *)controller {
    NSURL *url = [NSURL fileURLWithPath:fileModel.currentPath];
    NSArray *items = [NSArray arrayWithObject:url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [controller presentViewController:activityViewController animated:YES completion:nil];
}
@end
