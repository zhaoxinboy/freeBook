//
//  QDRClearCacheView.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/16.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRClearCacheView.h"
#import "QDRSetUpViewController.h"

@implementation QDRClearCacheView{
    id selfTarget;
}

- (UIView *)btnView{
    if (!_btnView) {
        _btnView = [UIView new];
        _btnView.backgroundColor = [UIColor whiteColor];
        _btnView.layer.masksToBounds = YES;
        _btnView.layer.cornerRadius = 8;
        [self addSubview:_btnView];
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.size.mas_equalTo(CGSizeMake(kWindowW - 50, 160));
            make.top.mas_equalTo(250);
        }];
    }
    return _btnView;
}

- (UILabel *)clearCacheLabel{
    if (!_clearCacheLabel) {
        _clearCacheLabel = [UILabel new];
        _clearCacheLabel.font = [UIFont systemFontOfSize:21];
        _clearCacheLabel.textColor = kRGBColor(51, 51, 51);
        _clearCacheLabel.text = @"清除缓存";
        [_btnView addSubview:_clearCacheLabel];
        [_clearCacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(25);
        }];
    }
    return _clearCacheLabel;
}

- (UILabel *)isClearLabel{
    if (!_isClearLabel) {
        _isClearLabel = [UILabel new];
        _isClearLabel.font = [UIFont systemFontOfSize:18];
        _isClearLabel.textColor = kRGBColor(51, 51, 51);
        _isClearLabel.text = @"是否清除缓存";
        [_btnView addSubview:_isClearLabel];
        [_isClearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(_clearCacheLabel.mas_bottom).mas_equalTo(30);
        }];
    }
    return _isClearLabel;
}

- (UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [UIButton new];
        _determineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_determineBtn setTitle:@"确定" forState:UIControlStateHighlighted];
        [_determineBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_determineBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_btnView addSubview:_determineBtn];
        [_determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.bottom.mas_equalTo(-15);
        }];
    }
    return _determineBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
        [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_determineBtn.mas_left).mas_equalTo(-30);
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.bottom.mas_equalTo(-15);
        }];
    }
    return _cancelBtn;
}

- (instancetype)initWithTarget:(id)target
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWindowW, kWindowH);
        self.backgroundColor = [kRGBColor(51, 51, 51) colorWithAlphaComponent:0.2];
        [self addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        selfTarget = target;
        [self btnView];
        [self clearCacheLabel];
        [self isClearLabel];
        [self determineBtn];
        [self cancelBtn];
    }
    return self;
}

- (void)openSelf{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)closeSelf{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeClearView)]) {
            [self.delegate removeClearView];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
