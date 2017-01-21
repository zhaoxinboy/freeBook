//
//  QDRForgetPassWordViewModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"

@interface QDRForgetPassWordViewModel : BaseViewModel


@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong)QDRLoginDataModel *loginModel;
// 忘记密码
- (void)postResetPasswordWithPassWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle;

@end
