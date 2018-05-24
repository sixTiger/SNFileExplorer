//
//  XXBExplorerModel.h
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXBFileExplorerUtils.h"

typedef enum : NSUInteger {
    XXBFileModelTypeDefault,
    XXBFileModelTypeRootFile,
} XXBFileModelType;

@interface XXBFileModel : NSObject

/**
 父级目录信息
 */
@property(nonatomic, weak) XXBFileModel                         *superFileModel;

/**
 当前模型的类型
 */
@property(nonatomic, assign) XXBFileModelType                   modelType;

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
@property(nonatomic, assign) XXBFileType                        fileType;


/**
 子目录
 */
@property(nonatomic, strong) NSMutableArray<XXBFileModel *>     *subFileModels;

- (instancetype)initWithPath:(NSString *)filePath andName:(NSString *)fileName andSuperFileMode:(XXBFileModel *)superFileModel;

/**
 刷新资源
 */
- (void)reloadResourceCompletion:(void (^)(BOOL finished))completion;
@end
