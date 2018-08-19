//
//  XXBExplorerModel.h
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNFileExplorerUtils.h"

typedef enum : NSUInteger {
    SNFileModelTypeDefault,
    SNFileModelTypeRootFile,
} SNFileModelType;

@interface SNFileModel : NSObject

/**
 父级目录信息
 */
@property(nonatomic, weak) SNFileModel                         *superFileModel;

/**
 当前模型的类型
 */
@property(nonatomic, assign) SNFileModelType                   modelType;

/**
 当前模型的名字
 */
@property(nonatomic, copy) NSString                             *currentName;

/**
 当前模型的路径
 */
@property(nonatomic, copy) NSString                             *currentPath;

/**
 当前模型的文件类型
 */
@property(nonatomic, assign) SNFileType                         fileType;


/**
 子目录
 */
@property(nonatomic, strong) NSMutableArray<SNFileModel *>     *subFileModels;

- (instancetype)initWithPath:(NSString *)filePath andName:(NSString *)fileName andSuperFileMode:(SNFileModel *)superFileModel;

/**
 刷新资源
 */
- (void)reloadResourceCompletion:(void (^)(BOOL finished))completion;
@end
