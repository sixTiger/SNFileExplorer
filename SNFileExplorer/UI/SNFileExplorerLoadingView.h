//
//  SNFileExplorerLoadingView.h
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNFileExplorerLoadingView : UIView

@property(nonatomic) BOOL   hidesWhenStopped;
- (void)startAnimating;
- (void)stopAnimating;
@end
