//
//  XXBExplorerModel.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "XXBFileModel.h"

@implementation XXBFileModel

- (instancetype)initWithPath:(NSString *)filePath andName:(NSString *)fileName andSuperFileMode:(XXBFileModel *)superFileModel {
    if (self = [super init]) {
        self.superFileModel = superFileModel;
        self.currentName = fileName;
        self.currentPath = filePath;
        if (isNull_XXBFE(superFileModel)) {
            self.modelType = XXBFileModelTypeRootFile;
        } else {
            self.modelType = XXBFileModelTypeDefault;
        }
        self.fileType = getFileType_XXBFE(filePath);
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
        NSError *error;
        NSArray *subFileContentArray = getSubFilesFromPath_XXBFE(self.currentPath, &error);
        for (NSString *subFileName in subFileContentArray) {
            NSString *subFilePath = [self.currentPath stringByAppendingPathComponent:subFileName];
            XXBFileModel *fileModel = [[XXBFileModel alloc] initWithPath:subFilePath andName:subFileName andSuperFileMode:self];
            [filesArray addObject:fileModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(NO);
            } else {
                self.subFileModels = filesArray;
                completion(YES);
            }
        });
    });
}

- (void)dealloc {
    NSLog(@"XXB | %s [Line %d] %@",__func__,__LINE__,[NSThread currentThread]);
}
@end
