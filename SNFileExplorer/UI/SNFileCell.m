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
@property(nonatomic, weak) UILabel      *subMessageLabel;
@property(nonatomic, weak) UILabel      *sizeLabel;
@property(nonatomic, weak) UILabel      *tagLabel;
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
    self.sizeLabel.text = fileModel.readableSize;
    self.tagLabel.text = fileModel.extension;
    switch (fileModel.modelType) {
        case SNFileModelTypeDefault:
        {
            NSString *modifyDateString = self.fileModel.modifyDateString;
            if (modifyDateString.length == 0) {
                modifyDateString = self.fileModel.createDateString;
            }
            self.subMessageLabel.text = modifyDateString;
            break;
        }
        case SNFileModelTypeSuperFile:
        {
            self.subMessageLabel.text = @"点击返回上一级";
            break;
        }
        case SNFileModelTypeRootFile:
        {
            self.subMessageLabel.text = @"点击返回根目录";
            break;
        }
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat selfHeight = CGRectGetHeight(self.contentView.bounds);
    CGFloat selfWidth = CGRectGetWidth(self.contentView.bounds);
    
    [self.tagLabel sizeToFit];
    CGFloat tagLabelWidth = self.tagLabel.frame.size.width;
    CGFloat tagLabelHeight = self.tagLabel.frame.size.height;
    [self.sizeLabel sizeToFit];
    CGFloat sizeLabelWidth = self.sizeLabel.frame.size.width;
    CGFloat sizeLabelHeight = self.sizeLabel.frame.size.height;
    
    CGFloat emojiLabelX = 10;
    CGFloat emojiLabelY = (selfHeight - 44) * 0.5;
    CGFloat emojiLabelW = 44;
    CGFloat emojiLabelH = 44;
    self.emojiLabel.frame = CGRectMake(emojiLabelX, emojiLabelY, emojiLabelW, emojiLabelH);
    
    CGFloat messageLabelX = emojiLabelX + emojiLabelW + 10;
    CGFloat messageLabelY = 0;
    CGFloat messageLabelW = selfWidth - messageLabelX - tagLabelWidth - 10;
    CGFloat messageLabelH = 35;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
    CGFloat messageLabelCenterY = self.messageLabel.center.y;
    
    CGFloat subMessageLabelH = selfHeight - messageLabelH;
    CGFloat subMessageLabelW = selfWidth - messageLabelX - sizeLabelWidth - 10;
    self.subMessageLabel.frame = CGRectMake(messageLabelX, messageLabelH, subMessageLabelW, subMessageLabelH);
    CGFloat subMessageLabelCenterY = self.subMessageLabel.center.y;
    
    self.tagLabel.frame = CGRectMake(selfWidth - tagLabelWidth - 5, messageLabelCenterY - tagLabelHeight * 0.5, tagLabelWidth, tagLabelHeight);
    
    self.sizeLabel.frame = CGRectMake(selfWidth - sizeLabelWidth - 5, subMessageLabelCenterY - sizeLabelHeight * 0.5, sizeLabelWidth, sizeLabelHeight);
}

- (void)loadFileMessage {
    
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

- (UILabel *)subMessageLabel {
    if (_subMessageLabel == nil) {
        UILabel *subMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.contentView addSubview:subMessageLabel];
        subMessageLabel.textAlignment = NSTextAlignmentLeft;
        subMessageLabel.font = [UIFont systemFontOfSize:10];
        subMessageLabel.textColor = [UIColor grayColor];
        _subMessageLabel = subMessageLabel;
    }
    return _subMessageLabel;
}

- (UILabel *)sizeLabel {
    if (_sizeLabel == nil) {
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        sizeLabel.clipsToBounds = YES;
        sizeLabel.layer.cornerRadius = 3;
        [self.contentView addSubview:sizeLabel];
        sizeLabel.textAlignment = NSTextAlignmentRight;
        sizeLabel.font = [UIFont systemFontOfSize:10];
        sizeLabel.textColor = [UIColor grayColor];
        _sizeLabel = sizeLabel;
    }
    return _sizeLabel;
}

- (UILabel *)tagLabel {
    if (_tagLabel == nil) {
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        tagLabel.clipsToBounds = YES;
        tagLabel.layer.cornerRadius = 3;
        [self.contentView addSubview:tagLabel];
        tagLabel.textAlignment = NSTextAlignmentRight;
        tagLabel.font = [UIFont systemFontOfSize:10];
        tagLabel.textColor = [UIColor grayColor];
        _tagLabel = tagLabel;
    }
    return _tagLabel;
}
@end
