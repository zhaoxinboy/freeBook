//
//  QDRMineTwoTableViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/8.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRMineTableHeaderView.h"

@implementation QDRMineTableHeaderView

//- (UIImageView *)headerImageView{
//    if (!_headerImageView) {
//        _headerImageView = [UIImageView new];
//        _headerImageView.userInteractionEnabled = YES;
//        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:_headerImageView];
//        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.mas_equalTo(0);
//            make.size.mas_equalTo(CGSizeMake(kWindowW, QDR_HOME_HEADER_HEIGHT));
//        }];
//    }
//    return _headerImageView;
//}

- (UILabel *)userLabel{
    if (!_userLabel) {
        _userLabel = [UILabel new];
        _userLabel.textColor = [UIColor whiteColor];
        _userLabel.textAlignment = NSTextAlignmentCenter;
        _userLabel.font = [UIFont systemFontOfSize:16];
        _userLabel.text = @"";
        [self addSubview:_userLabel];
        [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(160, 33));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(111);
        }];
    }
    return _userLabel;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 2;
        _loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        _loginBtn.layer.borderWidth = 1.0f;
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor clearColor];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 33));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(111);
        }];
    }
    return _loginBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
//        [self headerImageView];
        
    }
    return self;
}




@end
