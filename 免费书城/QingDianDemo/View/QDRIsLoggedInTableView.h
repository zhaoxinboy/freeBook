//
//  QDRIsLoggedInTableView.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDRIsLoggedInTableView : UITableView

@property (nonatomic, strong) UILabel *isLoginLable;          //已登录label

@property (nonatomic, strong) UILabel *phoneLabel;            // 手机号

@property (nonatomic, strong) UIButton *logOutBtn;              // 推出登录按钮

@property (nonatomic, assign) NSInteger KVOLogOutNum;           // 退出登录KVO

@property (nonatomic, strong) UIButton *userFeedbackBtn;            // 用户反馈按钮

@property (nonatomic, assign) NSInteger KVOFeedNum;                 // kvo用户反馈

@property (nonatomic, strong) UIButton *informationLalel;            // 底部信息

@end
