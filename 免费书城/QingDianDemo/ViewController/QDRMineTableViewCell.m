//
//  QDRMineTableViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/8.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRMineTableViewCell.h"

@implementation QDRMineTableViewCell

- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    return _backView;
}

- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [UIImageView new];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_backView addSubview:_titleImageView];
        [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
    }
    return _titleImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = kRGBColor(51, 51, 51);
        [_backView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleImageView.mas_right).mas_equalTo(11);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _titleLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = [UIFont fontWithName:@"iconfont" size:14];
        _rightLabel.textColor = kRGBColor(170, 170, 170);
        [_backView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(0);
            make.right.mas_equalTo(-10);
        }];
    }
    return _rightLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self backView];
        [self titleImageView];
        [self titleLabel];
        [self rightLabel];
       
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
