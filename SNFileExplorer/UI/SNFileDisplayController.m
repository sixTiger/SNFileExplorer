//
//  SNFileDisplayController.m
//  SNFileExplorer
//
//  Created by xiaobing5 on 2018/8/21.
//

#import "SNFileDisplayController.h"
#import "SNFileModel.h"
#import "SNFileExplorerLoadingView.h"
#import <WebKit/WebKit.h>

@interface SNFileDisplayController ()<WKNavigationDelegate>

/**
 要打开的文件的详细信息
 */
@property(nonatomic, strong) SNFileModel                *fileModel;
@property(nonatomic, weak) SNFileExplorerLoadingView    *loadingView;
@property(nonatomic, weak) UITextView                   *textView;
@property(nonatomic, weak) UIButton                     *otherAppOpenButton;
@property(nonatomic, weak) UIImageView                  *imageView;
@property(nonatomic, weak) WKWebView                    *webview;
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
    [self initNavi];
    [self initView];
    [self loadFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *otherAppOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    otherAppOpenButton.frame = self.view.bounds;
    otherAppOpenButton.autoresizingMask = (1 << 6) - 1;
    [otherAppOpenButton setTitle:@"其他应用打开" forState:UIControlStateNormal];
    [otherAppOpenButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    otherAppOpenButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [otherAppOpenButton addTarget:self action:@selector(otherAppOpenButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    otherAppOpenButton.hidden = YES;
    [self.view addSubview:otherAppOpenButton];
    _otherAppOpenButton = otherAppOpenButton;
}

- (void)initNavi {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightNaviDidClick)];
}

- (void)loadFile {
    [self.loadingView startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfFile:self.fileModel.currentPath];
        if (data) {
            if ([self.fileModel.extension isEqualToString:@"txt"] || [self.fileModel.extension isEqualToString:@"log"]) {
                NSString *txtString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self updateText:txtString];
            } else if ([self.fileModel.extension isEqualToString:@"plist"]){
                NSObject *object = [NSDictionary dictionaryWithContentsOfFile:self.fileModel.currentPath];
                if (object == nil) {
                    object = [NSArray arrayWithContentsOfFile:self.fileModel.currentPath];
                }
                NSString *txtString = [NSString stringWithFormat:@"%@",object];
                [self updateText:txtString];
            }  else if ([self.fileModel.extension isEqualToString:@"png"] || [self.fileModel.extension isEqualToString:@"jpg"]) {
                UIImage *image = [UIImage imageWithContentsOfFile:self.fileModel.currentPath];
                [self updateImage:image];
            } else {
                //其他应用打开文件
                [self openByWebView];
            }
            
        } else {
            //其他应用打开文件
            [self openByWebView];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
        });
    });
}

- (void)updateText:(NSString *)txtString {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = txtString;
    });
}

- (void)updateImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
}

- (void)rightNaviDidClick {
    [SNFileExplorerUtils shareFile:self.fileModel withController:self];
}

- (void)otherAppOpenButtonDidClick:(UIButton *)clickedButton {
    if (clickedButton == self.otherAppOpenButton) {
        [SNFileExplorerUtils shareFile:self.fileModel withController:self];
    }
}


/**
 用webview打开文件
 */
- (void)openByWebView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL fileURLWithPath:self.fileModel.currentPath];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.webview loadRequest:request];
    });
}

/**
 其他用用打开文件
 */
- (void)openbyOtherApp {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.otherAppOpenButton.hidden = NO;
    });
}

- (SNFileExplorerLoadingView *)loadingView {
    if (_loadingView == nil) {
        SNFileExplorerLoadingView *loadingView = [[SNFileExplorerLoadingView alloc] initWithFrame:self.view.bounds];
        loadingView.autoresizingMask = (1 << 6) - 1;
        loadingView.hidesWhenStopped = YES;
        [self.view addSubview:loadingView];
        _loadingView = loadingView;
    }
    [self.view bringSubviewToFront:_loadingView];
    return _loadingView;
}

- (UITextView *)textView {
    if (_textView == nil) {
        UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        textView.alwaysBounceVertical = YES;
        textView.editable = NO;
        textView.autoresizingMask = (1 << 6) - 1;
        [self.view insertSubview:textView belowSubview:self.loadingView];
        _textView = textView;
    }
    return _textView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0.2];
        imageView.contentMode = UIViewContentModeCenter;
        [self.view insertSubview:imageView belowSubview:self.loadingView];
        _imageView = imageView;
    }
    return _imageView;
}

- (WKWebView *)webview {
    if (_webview == nil) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        webView.navigationDelegate = self;
        webView.autoresizingMask = (1 << 6) - 1;
        [self.view addSubview:webView];
        _webview = webView;
    }
    return _webview;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    webView.hidden = YES;
    [self openbyOtherApp];
}

- (void)dealloc {
    
}
@end
