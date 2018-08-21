//
//  ViewController.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "ViewController.h"
#import "SNFileExplorer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatTestFile];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openFinder:(id)sender {
    NSString *rootPath = @"/Users/xiaobing5/Desktop";
    rootPath = NSHomeDirectory();
    SNFileExplorerController *fileExplorerController = [[SNFileExplorerController alloc] initWithRootPath:rootPath];
    [self.navigationController pushViewController:fileExplorerController animated:YES];
}

- (void)creatTestFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *testFinderPath = [documentPath stringByAppendingPathComponent:@"test"];
    NSString *testTilePath0 = [testFinderPath stringByAppendingPathComponent:@"test.txt"];
    NSString *testTilePath1 = [testFinderPath stringByAppendingPathComponent:@"dict.plist"];
    NSString *testTilePath2 = [testFinderPath stringByAppendingPathComponent:@"arry.plist"];
    
    [fileManager createDirectoryAtPath:testFinderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *content=@"测试写入内容！";
    [content writeToFile:testTilePath0 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *dict = @{
                           @"test":@"test",
                           @"array":@[@"a",@"b",@"c"]
                           };
    [dict writeToFile:testTilePath1 atomically:YES];
    
    NSArray *array = @[@(1),@(2),@(3)];
    [array writeToFile:testTilePath2 atomically:YES];
}
@end
