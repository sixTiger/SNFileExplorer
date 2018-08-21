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
    SNFileModelTypeSuperFile,
    SNFileModelTypeRootFile,
} SNFileModelType;

@interface SNFileModel : NSObject

/**
 父级目录信息
 */
@property(nonatomic, weak) SNFileModel                          *superFileModel;

/**
 当前模型的类型
 */
@property(nonatomic, assign) SNFileModelType                    modelType;

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
 当前的module的标示
 */
@property(nonatomic, assign) NSInteger                          tag;

/**
 子目录
 */
@property(nonatomic, strong) NSMutableArray<SNFileModel *>      *subFileModels;

/**
 尺寸
 */
@property (nonatomic, assign) long long                         size;

/**
 可读尺寸(..Mb)
 */
@property (nonatomic, readonly) NSString                        *readableSize;

/**
 创建日期
 */
@property (nonatomic, strong) NSDate                            *createDate;
@property (nonatomic, copy) NSString                            *createDateString;

/**
 修改日期
 */
@property (nonatomic, strong) NSDate                            *modifyDate;
@property (nonatomic, copy) NSString                            *modifyDateString;

/**
 扩展名
 */
@property (nonatomic, copy) NSString                            *extension;


/**
 SNFileModel 初始化

 @param filePath 文件路径
 @param fileName 文件名字
 @param superFileModel 文件的府级目录
 @return SNFileModel
 */
- (instancetype)initWithPath:(NSString *)filePath andName:(NSString *)fileName andSuperFileMode:(SNFileModel *)superFileModel;

/**
 刷新资源

 @param completion 刷新成功的回调
 */
- (void)reloadResourceCompletion:(void (^)(BOOL finished))completion;

/**
 加载文件详情

 @param completion 加载成功的block
 */
- (void)loadDetail:(void(^)(BOOL finish, NSDictionary *message))completion;
@end
