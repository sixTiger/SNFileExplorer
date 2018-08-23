//
//  XXBExplorerModel.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "SNFileModel.h"

@implementation SNFileModel

- (instancetype)initWithPath:(NSString *)filePath andName:(NSString *)fileName andSuperFileMode:(SNFileModel *)superFileModel {
    if (self = [super init]) {
        self.superFileModel = superFileModel;
        self.currentName = fileName;
        self.currentPath = filePath;
        if (isNull_XXBFE(superFileModel)) {
            self.modelType = SNFileModelTypeRootFile;
        } else {
            self.modelType = SNFileModelTypeDefault;
        }
        self.fileType = getFileType_XXBFE(filePath);
        NSDictionary *attrib = [[NSFileManager defaultManager] attributesOfItemAtPath:self.currentPath error:nil];
        _createDate = attrib.fileCreationDate;
        _modifyDate = attrib.fileModificationDate;
        _size = attrib.fileSize;
        _extension = filePath.pathExtension;
    }
    return self;
}

/**
 刷新资源
 */
- (void)reloadResourceCompletion:(void (^)(BOOL finished))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *filesArray = [NSMutableArray array];
        if (!isNull_XXBFE(self.superFileModel)) {
            [filesArray addObject:self.superFileModel];
        }
        if (self.modelType == SNFileModelTypeDefault) {
            self.modelType = SNFileModelTypeSuperFile;
        }
        NSError *error;
        NSArray *subFileContentArray = getSubFilesFromPath_XXBFE(self.currentPath, &error);
        for (NSString *subFileName in subFileContentArray) {
            NSString *subFilePath = [self.currentPath stringByAppendingPathComponent:subFileName];
            SNFileModel *fileModel = [[SNFileModel alloc] initWithPath:subFilePath andName:subFileName andSuperFileMode:self];
            [filesArray addObject:fileModel];
        }
        [filesArray sortUsingComparator:^NSComparisonResult(SNFileModel *fileModel1, SNFileModel *fileModel2) {
            if (fileModel1.modelType == fileModel2.modelType) {
                //文件级别一样 按照文件夹，文件，未知排序
                if (fileModel1.fileType == fileModel2.fileType) {
                    //文件类型类型一样的话，按照文件名字排序
                    return [fileModel1.currentName compare:fileModel2.currentName options:NSCaseInsensitiveSearch];
                } else {
                    if (fileModel1.fileType > fileModel2.fileType) {
                        return NSOrderedAscending;
                    } else {
                        return NSOrderedDescending;
                    }
                }
                
            } else {
                if (fileModel1.modelType > fileModel2.modelType) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }
        }];
        self.subFileModels = filesArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(NO);
            } else {
                completion(YES);
            }
        });
    });
}

- (NSString *)readableSize {
    NSString *readableSizeString = @"NO SIZE";
    if( _size < 0 && _currentName ) {
        readableSizeString = @"TMF";
    }  else if( _size < 1024 ) {
        readableSizeString = [NSString stringWithFormat:@"%db", (int)_size];
    } else if( _size < 1024 * 1024 ) {
        readableSizeString = [NSString stringWithFormat:@"%.1fK", (CGFloat)_size / 1024];
    } else if( _size < 1024 * 1024 * 1024 ) {
        readableSizeString = [NSString stringWithFormat:@"%.1fM", (CGFloat)_size / (1024 * 1024)];
    } else {
        readableSizeString = [NSString stringWithFormat:@"%.1fG", (CGFloat)_size / (1024 * 1024 * 1024)];
    }
    return readableSizeString;
}

- (void)loadDetail:(void (^)(BOOL, NSDictionary *))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        /**
//         父级目录信息
//         */
//        @property(nonatomic, weak) SNFileModel                          *superFileModel;
//
//        /**
//         当前模型的类型
//         */
//        @property(nonatomic, assign) SNFileModelType                    modelType;
//
//
//        /**
//         当前模型的文件类型
//         */
//        @property(nonatomic, assign) SNFileType                         fileType;
//
//        /**
//         当前的module的标示
//         */
//        @property(nonatomic, assign) NSInteger                          tag;
//
//        /**
//         子目录
//         */
//        @property(nonatomic, strong) NSMutableArray<SNFileModel *>      *subFileModels;
//
//
//        /**
//         可读尺寸(..Mb)
//         */
//        @property (nonatomic, readonly) NSString                        *readableSize;
//
//        /**
//         创建日期
//         */
//        @property (nonatomic, copy) NSDate                              *createDate;
//
//        /**
//         修改日期
//         */
//        @property (nonatomic, copy) NSDate                              *modifyDate;
//
//        /**
//         扩展名
//         */
//        @property (nonatomic, copy) NSString                            *extension;
        
        NSDictionary *message = @{
                                  @"currentName"    :   self.currentName,
                                  @"currentPath"    :   self.currentPath,
                                  @"size"           :   @(self.size),
                                  @"readableSize"   :   self.readableSize,
                                  @"createDate"     :   self.createDate ? self.createDate : @"Unknown Creat Time",
                                  @"modifyDate"     :   self.createDate ? self.modifyDate : @"Unknown modifyDate Time",
                                  @"extension"      :   self.extension ? self.extension : @"Unknown Extension",
                                  };
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(YES, message);
            }
        });
    });
}

- (NSString *)modifyDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd a HH:mm:ss EEEE";
    NSString *modifyDateString = [dateFormatter stringFromDate:self.modifyDate];
    return modifyDateString;
}

- (NSString *)createDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd a HH:mm:ss EEEE";
    NSString *createDateString = [dateFormatter stringFromDate:self.createDate];
    return createDateString;
}
@end
