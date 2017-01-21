//
//  QDRSetUpCollectionViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/12.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSetUpTableViewCell.h"

@implementation QDRSetUpTableViewCell

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = [UIFont systemFontOfSize:16];
        _leftLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = [UIFont fontWithName:@"iconfont" size:14];
        _rightLabel.textColor = kRGBColor(51, 51, 51);
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _rightLabel;
}

@end
