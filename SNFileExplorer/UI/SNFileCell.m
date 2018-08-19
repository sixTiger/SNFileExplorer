//
//  SNFileCell.m
//  XXBExplorerDemo
//
//  Created by xiaobing5 on 2018/5/22.
//  Copyright © 2018年 xiaobing5. All rights reserved.
//

#import "SNFileCell.h"

@interface SNFileCell()

@property(nonatomic, weak) UILabel      *emojiLabel;
@property(nonatomic, weak) UILabel      *messageLabel;
@end

@implementation SNFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFileModel:(SNFileModel *)fileModel {
    _fileModel = fileModel;
    self.emojiLabel.text = getEmojiString_XXBFE(fileModel.fileType);
    self.messageLabel.text = fileModel.currentName;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat selfHeight = CGRectGetHeight(self.contentView.bounds);
    CGFloat selfWidth = CGRectGetWidth(self.contentView.bounds);
    
    CGFloat emojiLabelX = 10;
    CGFloat emojiLabelY = (selfHeight - 44) * 0.5;
    CGFloat emojiLabelW = 44;
    CGFloat emojiLabelH = 44;
    self.emojiLabel.frame = CGRectMake(emojiLabelX, emojiLabelY, emojiLabelW, emojiLabelH);
    CGFloat messageLabelX = emojiLabelX + emojiLabelW + 10;
    CGFloat messageLabelY = (selfHeight - 44) * 0.5;
    CGFloat messageLabelW = selfWidth - messageLabelX - 10;
    CGFloat messageLabelH = 44;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
}

- (UILabel *)emojiLabel {
    if (_emojiLabel == nil) {
        UILabel *emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.contentView addSubview:emojiLabel];
        emojiLabel.textAlignment = NSTextAlignmentCenter;
        _emojiLabel = emojiLabel;
    }
    return _emojiLabel;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.contentView addSubview:messageLabel];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}
@end
