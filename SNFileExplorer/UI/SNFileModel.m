//
//  XXBExplorerModel.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "SNFileModel.h"
#import "SNFileExplorerUtils.h"

@interface SNFileModel()
@property(nonatomic, assign) BOOL isLoadingSize;

@end
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
    unsigned long long fileSize = self.realSize > 0 ? self.realSize : self.size;
    NSString *readableSizeString = @"NO SIZE";
    if( fileSize < 0 && _currentName ) {
        readableSizeString = @"TMF";
    }  else if( fileSize < 1024 ) {
        readableSizeString = [NSString stringWithFormat:@"%db", (unsigned long long)fileSize];
    } else if( fileSize < 1024 * 1024 ) {
        readableSizeString = [NSString stringWithFormat:@"%.1lfK", (double)fileSize / 1024];
    } else if( fileSize < 1024 * 1024 * 1024 ) {
        readableSizeString = [NSString stringWithFormat:@"%.1lfM", (double)fileSize / (1024 * 1024)];
    } else {
        readableSizeString = [NSString stringWithFormat:@"%.1lfG", (double)fileSize / (1024 * 1024 * 1024)];
    }
    return readableSizeString;
}

- (void)loadDetail:(void (^)(BOOL, NSDictionary *))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
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

/**
 获取文件的真实大小
 
 @param completion 获取完成的回调
 */
- (void)loadFileSize:(void(^)(NSString *path, unsigned long long size))completion {
    self.loadSizeCompletion = completion;
    if (self.isLoadingSize) {
        return;
    }
    self.isLoadingSize = YES;
    if (self.realSize != 0) {
        self.isLoadingSize = NO;
        if (self.loadSizeCompletion != nil) {
            self.loadSizeCompletion(self.currentPath, self.realSize);
        }
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *currentPath = self.currentPath;
            self.realSize = getFileSize_XXBFE(self.currentPath);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isLoadingSize = NO;
                if (self.loadSizeCompletion != nil) {
                    self.loadSizeCompletion(currentPath, self.realSize);
                }
            });
        });
    }
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
