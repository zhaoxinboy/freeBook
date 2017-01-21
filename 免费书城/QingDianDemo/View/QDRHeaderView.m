//
//  QDRHeaderView.m
//  freeBook
//
//  Created by 杨兆欣 on 2016/11/25.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRHeaderView.h"

@implementation QDRHeaderView

- (UIButton *)readBtn{
    if (!_readBtn) {
        _readBtn = [UIButton new];
        _readBtn.layer.masksToBounds = YES;
        _readBtn.layer.cornerRadius = 16;
        _readBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_readBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_readBtn setTitle:@"续读" forState:UIControlStateNormal];
        [_readBtn setTitle:@"续读" forState:UIControlStateHighlighted];
        _readBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _readBtn;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [UIImageView new];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.frame = CGRectMake(0, -20, kWindowW, self.frame.size.height);
        [self addSubview:_backImageView];
    }
    return _backImageView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = QDR_FIRST_COLOR;
        _maskView.alpha = 0;
        _maskView.frame = CGRectMake(0, -20, kWindowW, self.frame.size.height);
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.frame = CGRectMake(kWindowW / 2 - 30, 80, 60, 60);
        [self addSubview:_headerImageView];
    }
    return _headerImageView;
}

- (UIView *)textBordView{
    if (!_textBordView) {
        _textBordView = [UIView new];
        _textBordView.backgroundColor = [UIColor whiteColor];
        _textBordView.alpha = 0.8;
        _textBordView.layer.masksToBounds = YES;
        _textBordView.layer.cornerRadius = 6.0;
        _textBordView.layer.borderWidth = 1;
        _textBordView.layer.borderColor = kRGBColor(222, 222, 222).CGColor;
        _textBordView.backgroundColor = kRGBColor(235, 235, 235);
        _textBordView.frame = CGRectMake(15, QDR_HOME_HEADER_HEIGHT - 24 - 41, kWindowW - 30, 41);
        [self addSubview:_textBordView];
    }
    return _textBordView;
}

- (UITextField *)textFd{
    if (!_textFd) {
        _textFd = [UITextField new];
        _textFd.font = [UIFont systemFontOfSize:13];
        _textFd.placeholder = @"请输入小说名";
        [_textFd setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        _textFd.returnKeyType = UIReturnKeySearch;
        _textFd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFd.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [_textBordView addSubview:_textFd];
        [_textFd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(_textBordView.mas_centerY).mas_equalTo(0);
            make.right.mas_equalTo(-35);
        }];
    }
    return _textFd;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton new];
        _searchBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:22];
        _searchBtn.titleLabel.textColor = [UIColor blackColor];
        [_searchBtn setTitle:@"\U0000e633" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:kRGBColor(150, 150, 150) forState:UIControlStateNormal];
        _searchBtn.backgroundColor = kRGBColor(235, 235, 235);
        [_textBordView addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.width.mas_equalTo(40);
        }];
    }
    return _searchBtn;
}

- (UIButton *)skinBtn{
    if (!_skinBtn) {
        _skinBtn = [UIButton new];
        [_skinBtn setImage:[UIImage imageNamed:@"nav_icon_skin-1"] forState:UIControlStateNormal];
        [self addSubview:_skinBtn];
        [_skinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(46, 46));
            make.top.mas_equalTo(7);
            make.right.mas_equalTo(-15);
        }];
    }
    return _skinBtn;
}




- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self backImageView];
        [self maskView];
        //        [self headerImageView];
        [self textBordView];
        [self textFd];
        [self searchBtn];
        [self skinBtn];
        [self readBtn];
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
