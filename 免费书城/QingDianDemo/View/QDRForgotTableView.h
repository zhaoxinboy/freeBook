//
//  QDRForgotTableView.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QDRForgotTableView : UITableView

@property (nonatomic, strong) UILabel *forgotPasswordLable;          //忘记密码label

@property (nonatomic, strong) UILabel *phoneLabel;                  // 手机号label

@property (nonatomic, strong) UITextField *phoneTF;                 // 手机号输入框

@property (nonatomic, strong) UILabel *verificationCodeLable;       // 验证码Label

@property (nonatomic, strong) UITextField *verificationCodeTF;      //验证码输入框

@property (nonatomic, strong) NSString *verificationCodeStr;        //保存codeid

@property (nonatomic, strong) JKCountDownButton *verificationCodeBtn;   // 倒计时按钮

@property (nonatomic, strong) UILabel *passWordLabel;               // 密码label

@property (nonatomic, strong) UITextField *passWordTF;              // 密码输入框

@property (nonatomic, strong) UILabel *confirmPWLB;                // 确认密码

@property (nonatomic, strong) UITextField *confirmPWTF;         // 确认密码输入框

@property (nonatomic, strong) UIButton *loginBtn;                   // 登录按钮

@property (nonatomic, assign) NSInteger KVOlogin;                   // KVO登录监听

@property (nonatomic, strong) TTTAttributedLabel *registered;       // 注册

@property (nonatomic, assign) NSInteger KVOnum;                     //KVO监听，注册按钮点击一次加一

@property (nonatomic, strong) UIButton *userFeedbackBtn;            // 用户反馈按钮

@property (nonatomic, assign) NSInteger KVOFeedNum;                 // kvo用户反馈

@property (nonatomic, strong) UIButton *informationLalel;            // 底部信息

@end
