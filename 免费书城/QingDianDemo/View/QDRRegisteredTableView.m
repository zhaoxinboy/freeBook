//
//  QDRRegisteredTableView.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRRegisteredTableView.h"
#import "NSString+CLExtention.h"
#import "QDRRegisteredViewModel.h"


@interface QDRRegisteredTableView () <UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate>

@property (nonatomic, strong) QDRRegisteredViewModel *registeredVM;

@end

@implementation QDRRegisteredTableView

- (QDRRegisteredViewModel *)registeredVM
{
    if (!_registeredVM) {
        _registeredVM = [QDRRegisteredViewModel new];
    }
    return _registeredVM;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = kRGBColor(236, 236, 236);
        self.delegate = self;
        self.dataSource = self;
        // 隐藏cell分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 去掉多余cell
        self.tableFooterView = [UIView new];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRRegisteredTableView"];
    }
    return self;
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRRegisteredTableView" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    switch (indexPath.row) {
        case 0:
            cell.backgroundColor = [UIColor whiteColor];
            if (!_phoneTF) {
                _phoneTF = [UITextField new];
                _phoneTF.placeholder = @"请输入手机号";
                _phoneTF.returnKeyType = UIReturnKeyNext;
                [_phoneTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                _phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                _phoneTF.borderStyle = UITextBorderStyleNone;
                _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:_phoneTF];
                [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-120);
                }];
                UIView *view = [UIView new];
                view.backgroundColor = kRGBColor(236, 236, 236);
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(1);
                }];
            }
            break;
        case 1:
            cell.backgroundColor = [UIColor whiteColor];
            if (!_verificationCodeTF) {
                _verificationCodeTF = [UITextField new];
                _verificationCodeTF.placeholder = @"请输入6位短信验证码";
                _verificationCodeTF.returnKeyType = UIReturnKeyNext;
                [_verificationCodeTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                _verificationCodeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                _verificationCodeTF.borderStyle = UITextBorderStyleNone;
                _verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:_verificationCodeTF];
                [_verificationCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-120);
                }];
                UIView *view = [UIView new];
                view.backgroundColor = kRGBColor(236, 236, 236);
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.bottom.right.mas_equalTo(0);
                    make.height.mas_equalTo(1);
                }];
            }
            if (!_verificationCodeBtn) {
                _verificationCodeBtn = [[JKCountDownButton alloc] init];
                [_verificationCodeBtn addTarget:self action:@selector(yanzhengma) forControlEvents: UIControlEventTouchUpInside];
                [_verificationCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                [_verificationCodeBtn setTitleColor:QDR_FIRST_COLOR forState:UIControlStateNormal];
                [_verificationCodeBtn setTitleColor:QDR_FIRST_COLOR forState:UIControlStateHighlighted];
                [_verificationCodeBtn.layer setMasksToBounds:YES];
                [_verificationCodeBtn.layer setCornerRadius:5];
                _verificationCodeBtn.backgroundColor = [UIColor whiteColor];
                
                _verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:_verificationCodeBtn];
                [_verificationCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(0);
                    make.centerY.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(105, 30));
                }];
                UIView *view = [UIView new];
                view.backgroundColor = kRGBColor(236, 236, 236);
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(1, 30));
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-105);
                }];
            }
            break;
        case 2:
            cell.backgroundColor = [UIColor whiteColor];
            if (!_passWordTF) {
                _passWordTF = [UITextField new];
                _passWordTF.placeholder = @"请输入8位以上大小写字母、数字组合";
                _passWordTF.returnKeyType = UIReturnKeyNext;
                [_passWordTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                _passWordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                _passWordTF.borderStyle = UITextBorderStyleNone;
                _passWordTF.keyboardType = UIKeyboardTypeDefault;
                _passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                _passWordTF.secureTextEntry = YES;
                _passWordTF.delegate = self;
                [cell.contentView addSubview:_passWordTF];
                [_passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-25);
                }];
                UIView *view = [UIView new];
                view.backgroundColor = kRGBColor(236, 236, 236);
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(1);
                }];
            }
            break;
        case 3:
            cell.backgroundColor = [UIColor whiteColor];
            if (!_confirmPWTF) {
                _confirmPWTF = [UITextField new];
                _confirmPWTF.placeholder = @"请再次输入密码";
                [_confirmPWTF setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
                _confirmPWTF.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
                _confirmPWTF.clearButtonMode = UITextFieldViewModeWhileEditing;
                _confirmPWTF.borderStyle = UITextBorderStyleNone;
                _confirmPWTF.keyboardType = UIKeyboardTypeDefault;
                _confirmPWTF.returnKeyType = UIReturnKeyGo;
                _confirmPWTF.secureTextEntry = YES;
                _confirmPWTF.delegate = self;
                [cell.contentView addSubview:_confirmPWTF];
                [_confirmPWTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-25);
                }];
            }
            break;
        case 4:
            
            break;
        case 5:
            if (!_loginBtn) {
                _loginBtn = [UIButton new];
                [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
                _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_loginBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [_loginBtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                _loginBtn.backgroundColor = QDR_FIRST_COLOR;
                _loginBtn.layer.masksToBounds = YES;
                _loginBtn.layer.cornerRadius = 22;
                
                [cell.contentView addSubview:_loginBtn];
                [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(25);
                    make.right.mas_equalTo(-25);
                    make.height.mas_equalTo(44);
                    make.centerY.mas_equalTo(0);
                }];
            }
            break;
        case 6:
            if (!_readBtn) {
                _readBtn = [UIButton new];
                [_readBtn setImage:[UIImage imageNamed:@"reg_agreement_nor"] forState:UIControlStateNormal];
                [_readBtn setImage:[UIImage imageNamed:@"reg_agreement_press"] forState:UIControlStateSelected];
                _readBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,_readBtn.titleLabel.bounds.size.width);
                [_readBtn setTitle:@" 我已阅读并同意遵守" forState:UIControlStateNormal];
                _readBtn.titleLabel.font = [UIFont systemFontOfSize:10];
                _readBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [_readBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [_readBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
                _readBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_readBtn.titleLabel.bounds.size.width, 0, 0);
                [_readBtn addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
                _readBtn.selected = YES;
                [cell.contentView addSubview:_readBtn];
                [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(86);
                    make.centerY.mas_equalTo(0);
                }];
            }
            if (!_termsBtn) {
                _termsBtn = [UIButton new];
                [_termsBtn setTitle:@"《免费书城用户协议》" forState:UIControlStateNormal];
                _termsBtn.titleLabel.font = [UIFont systemFontOfSize:10];
                [_termsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [_termsBtn addTarget:self action:@selector(readterms) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_termsBtn];
                [_termsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_readBtn.mas_right).mas_equalTo(5);
                    make.centerY.mas_equalTo(_readBtn.mas_centerY).mas_equalTo(0);
                }];
            }
            break;
            
        default:
            break;
    }
    
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)jump2web
{
    NSLog(@"跳转到web页面");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

// 表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

- (void)check:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

// 验证码
- (void)yanzhengma
{
    NSString *phoneStr = _phoneTF.text;
    if ([phoneStr isMobilePhoneNumber]) {// 如果手机号正确
        __weak QDRRegisteredTableView *wself = self;
        [self.registeredVM getVerfyCodeWithUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] andMobile:phoneStr  andType:@"1" NetCompleteHandle:^(NSError *error) {
            if (wself.registeredVM.codeid) {//获取验证码成功
                
                // 获取验证码成功后试验证码输入框为第一响应者
                if ([wself.phoneTF isFirstResponder]) {
                    [wself.phoneTF resignFirstResponder];
                }else if ([wself.passWordTF isFirstResponder]) {
                    [wself.passWordTF resignFirstResponder];
                }else if ([wself.confirmPWTF isFirstResponder]) {
                    [wself.confirmPWTF resignFirstResponder];
                }
                [wself.verificationCodeTF becomeFirstResponder];
                
                wself.verificationCodeStr = wself.registeredVM.codeid;// 保存验证码
                
                _verificationCodeBtn.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
                _verificationCodeBtn.enabled = NO;
                [_verificationCodeBtn startWithSecond:60];
                [_verificationCodeBtn didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                    NSString *title = [NSString stringWithFormat:@"%d秒", second];
                    return title;
                }];
                [_verificationCodeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    countDownButton.backgroundColor = kRGBColor(255, 75, 59);
                    return @"重新获取";
                }];
            }else{// 获取验证码失败
                
            }
            
        }];
        
        
    }else{
        // 手机号不正确
        [self showErrorMsg:@"请输入正确的手机号"];
    };
    
}
//  登录按钮普通状态下的背景色及点击事件
- (void)button1BackGroundNormal:(UIButton *)sender
{
    _loginBtn.backgroundColor = QDR_FIRST_COLOR;
    if (![_phoneTF.text isMobilePhoneNumber]) {
        [self showErrorMsg:@"手机号不正确"];
    }else if (![_passWordTF.text isEqualToString:_confirmPWTF.text]) {
        [self showErrorMsg:@"两次输入密码不一致，请重新输入"];
    }else if (_passWordTF.text.length < 8 || _confirmPWTF.text.length < 8) {
        [self showErrorMsg:@"密码长度不够，请重新输入"];
    }else if (!_readBtn.selected) {
        [self showErrorMsg:@"阅读并接受条款"];
    }else{
        self.KVOlogin += 1;
    }
}
//  登录按钮高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor grayColor];
}

//阅读条款
- (void)readterms
{
    // KVO监听
    self.KVOreadNum += 1;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![[touches anyObject].view isEqual:self.phoneTF]) {
        if ([self.phoneTF isFirstResponder]) {
            [self.phoneTF resignFirstResponder];
        }
    }
    if (![[touches anyObject].view isEqual:self.passWordTF]) {
        if ([self.passWordTF isFirstResponder]) {
            [self.passWordTF resignFirstResponder];
        }
    }
    if (![[touches anyObject].view isEqual:self.confirmPWTF]) {
        if ([self.confirmPWTF isFirstResponder]) {
            [self.confirmPWTF resignFirstResponder];
        }
    }
    if (![[touches anyObject].view isEqual:self.verificationCodeTF]) {
        if ([self.verificationCodeTF isFirstResponder]) {
            [self.verificationCodeTF resignFirstResponder];
        }
    }
    
}

// 键盘代理方法：右下角按钮点击方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_passWordTF == textField) {  //密码输入框
        if ([self.passWordTF isFirstResponder]) {
            [self.passWordTF resignFirstResponder];
            [self.confirmPWTF becomeFirstResponder];
        }
    }else{ // 确认密码输入框
        if (![_phoneTF.text isMobilePhoneNumber]) {
            [self showErrorMsg:@"手机号不正确"];
        }else if (![_passWordTF.text isEqualToString:_confirmPWTF.text]) {
            [self showErrorMsg:@"两次输入密码不一致，请重新输入"];
        }else if (_passWordTF.text.length < 8 || _confirmPWTF.text.length < 8) {
            [self showErrorMsg:@"密码长度不够，请重新输入"];
        }else if (!_readBtn.selected) {
            [self showErrorMsg:@"阅读并接受条款"];
        }else{
            self.KVOlogin += 1;
        }
    }
    
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
