//
//  QDRSearchTableViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/23.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSearchTableViewCell.h"

@implementation QDRSearchTableViewCell

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 15;
        [self.contentView addSubview:_headerImageView];
        __weak QDRSearchTableViewCell *wself = self;
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.centerY.mas_equalTo(wself.contentView.mas_centerY).mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(APPWIDTH, APPWIDTH));
        }];
    }
    return _headerImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = kRGBColor(120, 120, 120);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_headerImageView.mas_centerY).mas_equalTo(0);
            make.left.mas_equalTo(_headerImageView.mas_right).mas_equalTo(5);
        }];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self headerImageView];
        [self titleLabel];
        
        //        [self addressLabel];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
