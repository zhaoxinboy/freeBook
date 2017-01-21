//
//  QDRLoginCollectionViewCell.m
//  freeBook
//
//  Created by 随看 on 16/10/3.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRLoginCollectionViewCell.h"

@implementation QDRLoginCollectionViewCell

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 8;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 42));
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _imgView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_titleLable];
        _titleLable.font = [UIFont systemFontOfSize:11];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(57);
            make.left.mas_equalTo(-10);
            make.right.mas_equalTo(10);
        }];
    }
    return _titleLable;
}

- (UILabel *)addAppLabel{
    if (!_addAppLabel) {
        _addAppLabel = [UILabel new];
        _addAppLabel.font = [UIFont fontWithName:@"iconfont" size:22];
        _addAppLabel.text = @"\U0000e604";
        _addAppLabel.textColor = kRGBColor(0, 187, 132);
        _addAppLabel.hidden = YES;
        [self.contentView addSubview:_addAppLabel];
        [_addAppLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(-10);
        }];
    }
    return _addAppLabel;
}

- (UIButton *)deleBtn{
    if (!_deleBtn) {
        _deleBtn = [UIButton new];
        _deleBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:22];
        [_deleBtn setTitle:@"\U0000e66b" forState:UIControlStateNormal];
        [_deleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_deleBtn setTitle:@"\U0000e66b" forState:UIControlStateHighlighted];
        [_deleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _deleBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        _deleBtn.hidden = YES;
        [self.contentView addSubview:_deleBtn];
        [_deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(10);
            make.top.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _deleBtn;
}



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self imgView];
        [self titleLable];
        [self addAppLabel];
        [self deleBtn];
    }
    return self;
}
@end
