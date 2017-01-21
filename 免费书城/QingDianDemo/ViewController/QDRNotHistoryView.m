//
//  QDRNotHistoryView.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/8.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRNotHistoryView.h"

@implementation QDRNotHistoryView

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.image = [UIImage imageNamed:@"browse_nor"];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(123);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
    }
    return _imageView;
}

- (UILabel *)browseLabel{
    if (!_browseLabel) {
        _browseLabel = [UILabel new];
        _browseLabel.textColor = kRGBColor(153, 153, 153);
        _browseLabel.font = [UIFont systemFontOfSize:13];
        _browseLabel.text = @"暂时无浏览记录";
        [self addSubview:_browseLabel];
        [_browseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageView.mas_bottom).mas_equalTo(22);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _browseLabel;
}

- (UIButton *)browseBtn{
    if (!_browseBtn) {
        _browseBtn = [UIButton new];
        [_browseBtn setTitle:@"去浏览" forState:UIControlStateNormal];
        [_browseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_browseBtn setBackgroundImage:[UIImage imageNamed:@"browse_bg"] forState:UIControlStateNormal];
        [_browseBtn setBackgroundImage:[UIImage imageNamed:@"login_import"] forState:UIControlStateHighlighted];
        [self addSubview:_browseBtn];
        [_browseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_browseLabel.mas_bottom).mas_equalTo(55);
            make.height.mas_equalTo(44);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _browseBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kRGBColor(227, 227, 227);
        [self imageView];
        [self browseLabel];
        [self browseBtn];
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
