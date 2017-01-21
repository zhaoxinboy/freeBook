//
//  QDRIsLoggedInTableView.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRIsLoggedInTableView.h"

@interface QDRIsLoggedInTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation QDRIsLoggedInTableView



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        // 隐藏cell分割线
        self.separatorStyle = NO;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRIsLoggedInTableView"];
    }
    return self;
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRIsLoggedInTableView" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            if (!_isLoginLable) {
                _isLoginLable = [UILabel new];
                _isLoginLable.text = @"已登录";
                _isLoginLable.font = [UIFont systemFontOfSize:38 weight:1.5];
                [cell.contentView addSubview:_isLoginLable];
                [_isLoginLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(kWindowW / 5.5);
                    make.bottom.mas_equalTo(-10);
                }];
                
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor blackColor];
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(_isLoginLable.mas_left).mas_equalTo(-3);
                    make.top.mas_equalTo(_isLoginLable.mas_top).mas_equalTo(4);;
                    make.bottom.mas_equalTo(_isLoginLable.mas_bottom).mas_equalTo(-4);
                    make.width.mas_equalTo(5);
                }];
                
            }
            break;
        case 1:
            if (!_phoneLabel) {
                _phoneLabel = [UILabel new];
                _phoneLabel.font = [UIFont systemFontOfSize:16 weight:1.5];
                [cell.contentView addSubview:_phoneLabel];
                [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(kWindowW / 5.5);
                    make.centerY.mas_equalTo(cell.contentView.mas_centerY).mas_equalTo(0);
                }];
            }
            break;
        case 2:
            if (!_logOutBtn) {
                _logOutBtn = [UIButton new];
                [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
                _logOutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [_logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_logOutBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [_logOutBtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                _logOutBtn.backgroundColor = kRGBColor(255, 75, 59);
                _logOutBtn.layer.masksToBounds = YES;
                _logOutBtn.layer.cornerRadius = 5;
                
                [cell.contentView addSubview:_logOutBtn];
                [_logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(kWindowW / 5.5);
                    make.right.mas_equalTo(-kWindowW / 5.5);
                    make.height.mas_equalTo(35);
                    make.bottom.mas_equalTo(-120);
                }];
            }
            if (!_userFeedbackBtn) {
                _userFeedbackBtn = [UIButton new];
                _userFeedbackBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
                [_userFeedbackBtn setTitle:@"用户反馈 \U0000e6ad" forState:UIControlStateNormal];
                [_userFeedbackBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [_userFeedbackBtn addTarget:self action:@selector(userfeedback) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_userFeedbackBtn];
                [_userFeedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(- kWindowW / 5.5 + 20);
                    make.bottom.mas_equalTo(-70);
                }];
            }
            if (!_informationLalel) {
                _informationLalel = [UIButton new];
                _informationLalel.titleLabel.font = [UIFont systemFontOfSize:10];
                [_informationLalel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [_informationLalel setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_RECORD] forState:UIControlStateNormal];
                [_informationLalel setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_RECORD] forState:UIControlStateHighlighted];
                [_informationLalel addTarget:self action:@selector(jump2web) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_informationLalel];
                [_informationLalel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.bottom.mas_equalTo(-20);
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 44;
    switch (indexPath.row) {
        case 0:
            rowHeight = kWindowH * 0.21;
            break;
        case 1:
            rowHeight = (kWindowH - kWindowH *0.21 - 64) / 2;
            break;
        case 2:
            rowHeight = (kWindowH - kWindowH *0.21 - 64) / 2;
            break;
            
        default:
            break;
    }
    return rowHeight;
}

- (void)userfeedback
{
    //用户反馈KVO
    self.KVOFeedNum += 1;
}

//  登录按钮普通状态下的背景色及点击事件
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = kRGBColor(186, 174, 174);
    
    // 友盟退出登录
    [MobClick profileSignOff];
    
    // 登录状态设为3表示退出登录
    [[NSUserDefaults standardUserDefaults] setObject:NOLOGIN forKey:LOCAL_READ_ISLOGIN];
    
    self.KVOLogOutNum += 1;
    
    [self showSuccessMsg:@"退出成功!"];
}

//  登录按钮高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor grayColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
