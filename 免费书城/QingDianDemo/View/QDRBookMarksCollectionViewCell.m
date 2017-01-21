//
//  QDRBookMarksCollectionViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/10.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRBookMarksCollectionViewCell.h"

@implementation QDRBookMarksCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self titleLabel];
        [self titleContentView];
        [self bottomView];
        [self closeBtn];
    }
    return self;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)titleContentView{
    if (!_titleContentView) {
        _titleContentView = [UIImageView new];
        _titleContentView.contentMode = UIViewContentModeScaleAspectFill;
        _titleContentView.userInteractionEnabled = YES;
        [self.contentView addSubview:_titleContentView];
        [_titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
    }
    return _titleContentView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.alpha = 0.7;
        [self.contentView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    }
    return _bottomView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:16];
        _closeBtn.titleLabel.textColor = [UIColor blackColor];
        [_closeBtn setTitle:@"\U0000e6cc" forState:UIControlStateNormal];
        [_bottomView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _closeBtn;
}

@end
