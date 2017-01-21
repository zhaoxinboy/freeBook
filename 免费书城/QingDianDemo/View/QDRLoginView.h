//
//  QDRLoginView.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDRLoginView : UITableView

@property (nonatomic, strong) UIImageView *logoImageView;           // logo

@property (nonatomic, strong) UITextField *phoneTF;                 // 手机号输入框

@property (nonatomic, strong) UITextField *passWordTF;              // 密码输入框

@property (nonatomic, strong) UIButton *rememberBtn;                // 记住密码复选

@property (nonatomic, strong) TTTAttributedLabel *forgotPassword;   // 忘记密码富文本

@property (nonatomic, strong) UIButton *forgotBtn;                  // 忘记密码

@property (nonatomic, assign) NSInteger KVOForgotNum;               // KVO监听忘记密码

@property (nonatomic, strong) UIButton *loginBtn;                   // 登录按钮

@property (nonatomic, assign) NSInteger KVOLoginNum;                // KVO监听登录

@property (nonatomic, strong) TTTAttributedLabel *registered;       // 注册

@property (nonatomic, strong) UIButton *registerBtn;                // 注册按钮

@property (nonatomic, assign) NSInteger KVORegisterNum;             //KVO监听注册

@property (nonatomic, strong) UIButton *qqLogin;                    // QQ登录

@property (nonatomic, assign) NSInteger qqKVO;                      // QQ kvo

@property (nonatomic, strong) UIButton *wxLogin;                    // 微信登陆

@property (nonatomic, assign) NSInteger KVOweixin;                     // 微信 kvo
 
@property (nonatomic, strong) UIView *fastView;                     // 快速登录显示

@end
