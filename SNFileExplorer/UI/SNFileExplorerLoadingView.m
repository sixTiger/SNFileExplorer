//
//  SNFileExplorerLoadingView.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "SNFileExplorerLoadingView.h"

@interface SNFileExplorerLoadingView()

@property(nonatomic, weak) UIActivityIndicatorView      *activityIndicatorView;
@end

@implementation SNFileExplorerLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0.3];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.color = [UIColor orangeColor];
        [self addSubview:activityIndicatorView];
        _activityIndicatorView = activityIndicatorView;
    }
    return _activityIndicatorView;
}

- (void)startAnimating {
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
    [self.activityIndicatorView startAnimating];
}
- (void)stopAnimating {
    [self.activityIndicatorView stopAnimating];
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}
@end
