//
//  QDRWebNaviView.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/13.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDRWebNaviView : UIView

@property (nonatomic, strong) UIImageView *appImageView;        //图标

@property (nonatomic, assign) NSInteger appImageKVO;            // 监听图标点击事件（刷新）

@property (nonatomic, strong) UILabel *naviTitleLabel;          // 导航的标题

@property (nonatomic, strong) UIButton *rightBtn;               // 右侧按钮

@property (nonatomic, assign) NSInteger rightKVO;               // 监听右侧按钮点击（书签）

@property (nonatomic, strong) UILabel *rightLabel;              // 右侧按钮下方文字
@end
