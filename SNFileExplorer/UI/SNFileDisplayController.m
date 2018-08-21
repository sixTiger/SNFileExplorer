//
//  SNFileDisplayController.m
//  SNFileExplorer
//
//  Created by xiaobing5 on 2018/8/21.
//

#import "SNFileDisplayController.h"
#import "SNFileModel.h"
#import "SNFileExplorerLoadingView.h"

@interface SNFileDisplayController ()

/**
 要打开的文件的详细信息
 */
@property(nonatomic, strong) SNFileModel                *fileModel;
@property(nonatomic, weak) SNFileExplorerLoadingView    *loadingView;
@property(nonatomic, weak) UITextView                   *textView;
@property(nonatomic, weak) UIButton                     *otherAppOpenButton;

@end

@implementation SNFileDisplayController
- (instancetype)initWithFileModel:(SNFileModel *)fileModel {
    if (self = [super init]) {
        _fileModel = fileModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    [self loadFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.editable = NO;
    [self.view addSubview:textView];
    _textView = textView;
    
    UIButton *otherAppOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherAppOpenButton setTitle:@"其他应用打开" forState:UIControlStateNormal];
    [otherAppOpenButton addTarget:self action:@selector(otherAppOpenButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    otherAppOpenButton.hidden = YES;
    [self.view addSubview:otherAppOpenButton];
    _otherAppOpenButton = otherAppOpenButton;
    
    
    SNFileExplorerLoadingView *loadingView = [[SNFileExplorerLoadingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:loadingView];
    loadingView.autoresizingMask = (1 << 6) - 1;
    loadingView.hidesWhenStopped = YES;
    _loadingView = loadingView;
}

- (void)loadFile {
    [self.loadingView startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfFile:self.fileModel.currentPath];
        if (data) {
            NSString *txtString = @"";
            if ([self.fileModel.extension isEqualToString:@"txt"]) {
                txtString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            } else if ([self.fileModel.extension isEqualToString:@"plist"]){
                NSObject *object = [NSDictionary dictionaryWithContentsOfFile:self.fileModel.currentPath];
                if (object == nil) {
                    object = [NSArray arrayWithContentsOfFile:self.fileModel.currentPath];
                }
                txtString = [NSString stringWithFormat:@"%@",object];
            } else if ([self.fileModel.extension isEqualToString:@"log"]){
                txtString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            } else {
                //其他应用打开文件
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.otherAppOpenButton.hidden = NO;
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = txtString;
            });
        } else {
            //其他应用打开文件
            dispatch_async(dispatch_get_main_queue(), ^{
                self.otherAppOpenButton.hidden = NO;
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
        });
    });
}

- (void)otherAppOpenButtonDidClick:(UIButton *)clickedButton {
    if (clickedButton == self.otherAppOpenButton) {
        [SNFileExplorerUtils shareFile:self.fileModel withController:self];
    }
}
@end
