//
//  QDRWebNaviView.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/13.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRWebNaviView.h"

@implementation QDRWebNaviView

- (UIImageView *)appImageView{
    if (!_appImageView) {
        _appImageView = [UIImageView new];
        _appImageView.userInteractionEnabled = YES;
        _appImageView.contentMode = UIViewContentModeScaleAspectFill;
        _appImageView.layer.masksToBounds = YES;
        _appImageView.layer.cornerRadius = 15;
        [self addSubview:_appImageView];
        [_appImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        UIButton* leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = [UIColor clearColor];
        [leftBtn addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
        [_appImageView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _appImageView;
}

// 刷新操作
- (void)refreshWebView{
    self.appImageKVO +=1;
}

- (UILabel *)naviTitleLabel{
    if (!_naviTitleLabel) {
        _naviTitleLabel= [UILabel new];
        _naviTitleLabel.textColor = [UIColor blackColor];
        _naviTitleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_naviTitleLabel];
        [_naviTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(kWindowW - 110);
        }];
    }
    return _naviTitleLabel;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_rightBtn setTitle:@"\U0000e615" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"\U0000e651" forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(addBookViewFMDB) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 40));
        }];
    }
    return _rightBtn;
}

// 添加书签操作
- (void)addBookViewFMDB{
    self.rightKVO += 1;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:8];
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_rightBtn.mas_centerX).mas_equalTo(0);
            make.top.mas_equalTo(_rightBtn.mas_bottom).mas_equalTo(-10);
        }];
    }
    return _rightLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self appImageView];
        [self naviTitleLabel];
        [self rightBtn];
        [self rightLabel];
        
        UIView *navilineView = [UIView new];
        navilineView.backgroundColor = [UIColor grayColor];
        [self addSubview:navilineView];
        [navilineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
