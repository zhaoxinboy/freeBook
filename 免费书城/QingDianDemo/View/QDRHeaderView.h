//
//  QDRHeaderView.h
//  freeBook
//
//  Created by 杨兆欣 on 2016/11/25.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDRHeaderView : UIView


@property (nonatomic, strong) UIButton *readBtn;        // 续读按钮

@property (nonatomic, strong) UIButton *skinBtn;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UIView *textBordView;

@property (nonatomic, strong) UITextField *textFd;

@property (nonatomic, strong) UIButton *searchBtn;

@end
