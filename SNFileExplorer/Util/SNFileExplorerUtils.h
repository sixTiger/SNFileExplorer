//
//  XXBFileExplorerUtils.h
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNFileModel;

typedef enum : NSUInteger {
    SNFileTypeUnknown,     //文件不存在
    SNFileTypeFile,        //文件
    SNFileTypeFinder,      //文件夹
} SNFileType;


/**
 判断对象是否为空

 @param value 要判断得对象
 @return 是/否
 */
extern BOOL isNull_XXBFE(id value);

/**
 判断字符串是否为空

 @param value 要判断得字符串
 @return 是/否
 */
extern BOOL isEmpty_XXBFE(id value);

/**
 获取文件得类型

 @param path 文件得路径
 @return 当前文件的类型
 */
extern SNFileType getFileType_XXBFE(NSString *path);

/**
 获取文件对应得Emoji

 @param fileType 文件得类型
 @return Emoji
 */
extern NSString* getEmojiString_XXBFE(SNFileType fileType);

/**
 获取当前路径得所有文件

 @param path 当前得路径
 @param error 错误信息
 @return 所有得字路径
 */
extern NSArray* getSubFilesFromPath_XXBFE(NSString *path, NSError **error);

/**
 删除文件

 @param path 文件路径
 @param error error
 @return 删除成功/失败
 */
extern BOOL deleteFail_XXBFE(NSString *path, NSError **error);

@interface SNFileExplorerUtils : NSObject


/**
 分享文件

 @param fileModel 要分享的文件
 @param controller 分享这个文件的controller
 */
+ (void)shareFile:(SNFileModel *)fileModel withController:(UIViewController *)controller;
@end
