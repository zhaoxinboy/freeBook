//
//  QDRLoginViewModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRLoginViewModel.h"

@implementation QDRLoginViewModel

// 首次打开APP
- (void)postFirstRegistWithSign:(NSString *)sign andSerialnumber:(NSString *)serialnumber companyid:(NSString *)companyid NetCompleteHandle:(CompletionHandle)completionHandle{
    __weak QDRLoginViewModel *wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/soil/firstRegist", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *mdStr = [NSString stringWithFormat:@"%@%@", sign, LOCAL_READ_MD5];
    NSString *md = [mdStr encryptWithMD5];
    [params setObject:md forKey:@"sign"];
    [params setObject:serialnumber forKey:@"serialnumber"];
    [params setObject:companyid forKey:@"companyid"];
    
    NSLog(@"params %@", params);
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _firstModel = [QDRFirstModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
            // 保存用户已经打开第一次
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:LOCAL_READ_FIRST];
            NSLog(@"LOCAL_READ_USERID  %@", [NSString stringWithFormat:@"%@", _firstModel.userid]);
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _firstModel.userid] forKey:LOCAL_READ_USERID];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _firstModel.token] forKey:LOCAL_READ_TOKEN];
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}


// 登录页面相关
- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle{
    __weak QDRLoginViewModel *wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/userlogin", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:userName forKey:@"username"];
//    [params setObject:passWord forKey:@"password"];
    [params setObject:LOCAL_READ_UUID forKey:@"serialnumber"];
    
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _LoginDataModel = [QDRLoginDataModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
            NSLog(@"%@", _LoginDataModel.token);
            // 保存用户token权限
            [[NSUserDefaults standardUserDefaults] setObject:_LoginDataModel.token forKey:LOCAL_READ_TOKEN];
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN]);
            // 保存用户ID
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _LoginDataModel.userid] forKey:LOCAL_READ_USERID];
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        
        completionHandle(error);
    }];
}

- (void)getUserInfoByUserid:(NSInteger)userID NetCompleteHandle:(CompletionHandle)completionHandle
{
    NSString *path = [NSString stringWithFormat:@"%@/soil/getUserInfoByUserid?userid=%@", URLPATH, @(userID)];
    self.dataTask = [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
        _isLoginModel = [QDRIsLoginModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
        // 把头像地址拼接起来
        _isLoginModel.avatar = [NSString stringWithFormat:@"%@%@", URLPATH, _isLoginModel.avatar];
        }
        completionHandle(error);
    }];
}

//登陆
- (void)postAppLoginWithMobile:(NSString *)mobile passWord:(NSString *)passWord NetCompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/appLogin", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:passWord forKey:@"password"];
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            self.successApp = [dic objectForKey:@"status"];
        }
        completionHandle(error);
    }];

    
}


// 第三方登录
- (void)postOutherLoginWithOnlyid:(NSString *)onlyid serialnumber:(NSString *)serialnumber userid:(NSString *)userid type:(NSString *)type outerinfo:(NSString *)outerinfo nickname:(NSString *)nickname NetCompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/soil/outerLogin", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:onlyid forKey:@"onlyid"];
    [params setObject:serialnumber forKey:@"serialnumber"];
    [params setObject:userid forKey:@"userid"];
    [params setObject:type forKey:@"type"];
    [params setObject:outerinfo forKey:@"outerinfo"];
    [params setObject:nickname forKey:@"nickname"];
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            self.successOuther = [dic objectForKey:@"status"];
        }
        completionHandle(error);
    }];
}

@end
