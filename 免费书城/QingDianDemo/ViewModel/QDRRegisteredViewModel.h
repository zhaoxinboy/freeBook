//
//  QDRRegisteredViewModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"

@interface QDRRegisteredViewModel : BaseViewModel

@property (nonatomic, strong)QDRLoginDataModel *loginModel;


@property (nonatomic, strong) NSString *status;
// 注册
- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode serialnumber:(NSString *)serialnumber codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle;


// 获取验证码
- (void)getVerfyCodeWithUserID:(NSString *)userid andMobile:(NSString *)mobile andType:(NSString *)type NetCompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *codeid;


@end
