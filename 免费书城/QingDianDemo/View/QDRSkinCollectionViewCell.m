//
//  QDRSkinCollectionViewCell.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/9.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSkinCollectionViewCell.h"

@implementation QDRSkinCollectionViewCell

- (UIView *)bView{
    if (!_bView) {
        _bView = [UIView new];
        [self.contentView addSubview:_bView];
        [_bView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(108, 160));
        }];
    }
    return _bView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_bView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(108, 160));
        }];
    }
    return _imageView;
}

- (UIImageView *)determineImageView{
    if (!_determineImageView) {
        _determineImageView = [UIImageView new];
        _determineImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_bView addSubview:_determineImageView];
        [_determineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _determineImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UIView *view = [UIView new];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_bView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(24);
        }];
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self bView];
        [self imageView];
        [self determineImageView];
        [self titleLabel];
    }
    return self;
}

-(void)UpdateCellWithState:(BOOL)select{
    if (select) {
        self.bView.layer.borderWidth = 2;
        self.bView.layer.borderColor = kRGBColor(255, 98, 81).CGColor;
    }else{
        self.bView.layer.borderWidth = 0;
        self.bView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    _isSelected = select;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    if (selected) {
        
        self.bView.layer.borderWidth = 2;
        self.bView.layer.borderColor = kRGBColor(255, 98, 81).CGColor;
        
    }
    
}



- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.bView.layer.borderWidth = 2;
        self.bView.layer.borderColor = kRGBColor(255, 98, 81).CGColor;
    } else {
        self.bView.layer.borderWidth = 0;
        self.bView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
