//
//  QDRAddCollectionViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/17.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRAddCollectionViewCell.h"

@implementation QDRAddCollectionViewCell

- (UIView *)borderView
{
    if (!_borderView) {
        _borderView = [UIView new];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.masksToBounds = YES;
        _borderView.layer.cornerRadius = 8;
        _borderView.layer.borderColor = kRGBColor(188, 188, 188).CGColor;//边框颜色
        _borderView.layer.borderWidth = 1;//边框宽度
        [self.contentView addSubview:_borderView];
        [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
    }
    return _borderView;
}

- (UILabel *)addLabel
{
    if (!_addLabel) {
        _addLabel = [UILabel new];
        _addLabel.font = [UIFont fontWithName:@"iconfont" size:40];
        _addLabel.textColor = kRGBColor(188, 188, 188);
        _addLabel.textAlignment = NSTextAlignmentCenter;
        _addLabel.text = @"\U0000e621";
        [self.contentView addSubview:_addLabel];
        [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
    }
    return _addLabel;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        [self.contentView addSubview:_titleLable];
        _titleLable.font = [UIFont systemFontOfSize:11];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(57);
        }];
    }
    return _titleLable;
}

- (UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [UIImageView new];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.layer.masksToBounds = YES;
        _imageView1.layer.cornerRadius = 5;
        _imageView1.frame = CGRectMake(6, 6, APPWIDTH / 2 - 9, APPWIDTH / 2 - 9);
//        [self.contentView addSubview:_imageView1];
//        [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(APPWIDTH / 2 - 9, APPWIDTH / 2 - 9));
//            make.top.mas_equalTo(6);
//            make.left.mas_equalTo(6);
//        }];
    }
    return _imageView1;
}

- (UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [UIImageView new];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.layer.masksToBounds = YES;
        _imageView2.layer.cornerRadius = 5;
        _imageView2.frame = CGRectMake(APPWIDTH / 2 + 3, 6, APPWIDTH / 2 - 9, APPWIDTH / 2 - 9);
//        [self.contentView addSubview:_imageView2];
//        [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(APPWIDTH / 2 - 9, APPWIDTH / 2 - 9));
//            make.top.mas_equalTo(6);
//            make.left.mas_equalTo(APPWIDTH / 2 - 9 + 12);
//        }];
    }
    return _imageView2;
}

- (UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [UIImageView new];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
        _imageView3.layer.masksToBounds = YES;
        _imageView3.layer.cornerRadius = 5;
        _imageView3.frame = CGRectMake(6, APPWIDTH / 2 + 3, APPWIDTH / 2 - 9, APPWIDTH / 2 - 9);
//        [self.contentView addSubview:_imageView3];
//        [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(APPWIDTH / 2 - 9, APPWIDTH / 2 - 9));
//            make.top.mas_equalTo(APPWIDTH / 2 - 9 + 12);
//            make.left.mas_equalTo(6);
//        }];
    }
    return _imageView3;
}

- (UIImageView *)imageView4{
    if (!_imageView4) {
        _imageView4 = [UIImageView new];
        _imageView4.contentMode = UIViewContentModeScaleAspectFill;
        _imageView4.layer.masksToBounds = YES;
        _imageView4.layer.cornerRadius = 5;
        _imageView4.frame = CGRectMake(APPWIDTH / 2 + 3, APPWIDTH / 2 + 3, APPWIDTH / 2 - 9, APPWIDTH / 2 - 9);
//        [self.contentView addSubview:_imageView4];
//        [_imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(APPWIDTH / 2 - 9, APPWIDTH / 2 - 9));
//            make.top.mas_equalTo(APPWIDTH / 2 - 9 + 12);
//            make.left.mas_equalTo(APPWIDTH / 2 - 9 + 12);
//        }];
    }
    return _imageView4;
}

@end
