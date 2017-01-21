//
//  QDRHistoryCollectionViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/8.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRHistoryCollectionViewCell.h"

@implementation QDRHistoryCollectionViewCell

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(QDR_HISTORY_HEIGHT, QDR_HISTORY_HEIGHT));
        }];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kRGBColor(102, 102, 102);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imageView.mas_right).mas_equalTo(12);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self imageView];
        [self titleLabel];
    }
    return self;
}

@end
