//
//  QDRRegisteredViewModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRRegisteredViewModel.h"

@implementation QDRRegisteredViewModel

// 注册
- (void)postDataFromWithUserName:(NSString *)userName passWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode serialnumber:(NSString *)serialnumber codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle
{
    NSString *path = [NSString stringWithFormat:@"%@/userregist", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:verfycode forKey:@"verfycode"];
    [params setObject:serialnumber forKey:@"serialnumber"];
    [params setObject:codeid forKey:@"codeid"];
    
    __weak QDRRegisteredViewModel *wself = self;
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        _status = [dic objectForKey:@"status"];
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _loginModel = [QDRLoginDataModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
            // 保存用户ID
            [[NSUserDefaults standardUserDefaults] setObject:_loginModel.userid forKey:LOCAL_READ_USERID];
            
            [[NSUserDefaults standardUserDefaults] setObject:_loginModel.username forKey:LOCAL_READ_USERNAME];
            [[NSUserDefaults standardUserDefaults] setObject:_loginModel.mobile forKey:LOCAL_READ_MOBILE];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:LOCAL_READ_PASSWORD];
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}


// 验证码
- (void)getVerfyCodeWithUserID:(NSString *)userid andMobile:(NSString *)mobile andType:(NSString *)type NetCompleteHandle:(CompletionHandle)completionHandle{
    __weak QDRRegisteredViewModel *wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/getVerfyCode?userid=%@&mobile=%@&type=%@", URLPATH, userid, mobile, type];
    self.dataTask = [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            wself.codeid = [dic objectForKey:@"data"];
            NSLog(@"%@", wself.codeid);
            [wself showSuccessMsg:@"验证码已发送"];
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        
        completionHandle(error);
    }];
}

@end
