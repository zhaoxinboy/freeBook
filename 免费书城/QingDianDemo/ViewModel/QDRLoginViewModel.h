//
//  QDRLoginViewModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"

@interface QDRLoginViewModel : BaseViewModel

@property (nonatomic, strong) QDRFirstModel *firstModel;


// 第一次打开APP
- (void)postFirstRegistWithSign:(NSString *)sign andSerialnumber:(NSString *)serialnumber companyid:(NSString *)companyid NetCompleteHandle:(CompletionHandle)completionHandle;

// 第一次登陆登录
@property (nonatomic, strong) QDRLoginDataModel *LoginDataModel;

- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle;


//已登录
@property (nonatomic, strong) QDRIsLoginModel *isLoginModel;
- (void)getUserInfoByUserid:(NSInteger)userID NetCompleteHandle:(CompletionHandle)completionHandle;


// 登陆
- (void)postAppLoginWithMobile:(NSString *)mobile passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *successApp;




// 第三方登录登录
- (void)postOutherLoginWithOnlyid:(NSString *)onlyid serialnumber:(NSString *)serialnumber userid:(NSString *)userid type:(NSString *)type outerinfo:(NSString *)outerinfo nickname:(NSString *)nickname NetCompleteHandle:(CompletionHandle)completionHandle;

@property (nonatomic, strong) NSString *successOuther;

@end
