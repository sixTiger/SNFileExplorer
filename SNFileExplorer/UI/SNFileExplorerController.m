//
//  XXBExplorerController.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "SNFileExplorerController.h"
#import "SNFileModel.h"
#import "SNFileCell.h"
#import "SNFileExplorerLoadingView.h"

@interface SNFileExplorerController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) UITableView                      *tableView;
@property(nonatomic, weak) SNFileExplorerLoadingView        *loadingView;
@property(nonatomic, strong) SNFileModel                    *rootFileModel;
@property(nonatomic, strong) SNFileModel                    *fileModel;


@end

@implementation SNFileExplorerController

static NSString *SNFileCellID = @"SNFileCellID";

- (instancetype)initWithHomePath {
    return [self initWithRootPath:NSHomeDirectory()];
}

- (instancetype)initWithRootPath:(NSString *)rootpath {
    if (self = [super init]) {
        self.rootFileModel = [[SNFileModel alloc] initWithPath:rootpath andName:@"ROOT" andSuperFileMode:nil];
        self.fileModel = self.rootFileModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self reloadResource];
}

- (void)initView {
    self.view.backgroundColor = [UIColor lightGrayColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[SNFileCell class] forCellReuseIdentifier:SNFileCellID];
    tableView.rowHeight = 60;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    SNFileExplorerLoadingView *loadingView = [[SNFileExplorerLoadingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:loadingView];
    loadingView.autoresizingMask = (1 << 6) - 1;
    loadingView.hidesWhenStopped = YES;
    _loadingView = loadingView;
}

- (void)reloadResource {
    [self.loadingView startAnimating];
    __weak typeof(self) weakSelf = self;
    [self.fileModel reloadResourceCompletion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.loadingView stopAnimating];
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SNFileModel *fileModel = self.fileModel.subFileModels[indexPath.row];
    if (fileModel.fileType == XXBFileTypeFinder) {
        self.fileModel = self.fileModel.subFileModels[indexPath.row];
        [self reloadResource];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNFileCell *cell = (SNFileCell *)[tableView dequeueReusableCellWithIdentifier:SNFileCellID];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0.5];
    cell.fileModel = self.fileModel.subFileModels[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileModel.subFileModels.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 添加一个删除按钮
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *shareFileAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"分享文件"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf shareFileWithCellIndexpath:indexPath];
    }];
    shareFileAction.backgroundColor = [UIColor orangeColor];
    
    // 修改资料按钮
    UITableViewRowAction *delegateFileAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf deleteFileWithCellIndexpath:indexPath];
        
    }];
  
    delegateFileAction.backgroundColor = [UIColor redColor];
    // 将设置好的按钮放到数组中返回
    return @[shareFileAction, delegateFileAction];
}

- (void)deleteFileWithCellIndexpath:(NSIndexPath *)indexPath {
    SNFileModel *fileModel = self.fileModel.subFileModels[indexPath.row];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除文件?" message:fileModel.currentName preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteFile = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSError *error = nil;
        if (deleteFail_XXBFE(fileModel.currentPath, &error)) {
            [self.fileModel.subFileModels removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }];
    [alertController addAction:deleteFile];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}


- (void)shareFileWithCellIndexpath:(NSIndexPath *)indexPath {
    SNFileModel *fileModel = self.fileModel.subFileModels[indexPath.row];
    NSURL *url = [NSURL fileURLWithPath:fileModel.currentPath];
    NSArray *items = [NSArray arrayWithObject:url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)dealloc {
}
@end