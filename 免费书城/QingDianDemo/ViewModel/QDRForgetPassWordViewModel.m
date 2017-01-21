//
//  QDRForgetPassWordViewModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRForgetPassWordViewModel.h"

@implementation QDRForgetPassWordViewModel

- (void)postResetPasswordWithPassWord:(NSString *)password mobile:(NSString *)mobile verfycode:(NSString *)verfycode codeid:(NSString *)codeid NetCompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/resetPassword", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:password forKey:@"password"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:verfycode forKey:@"verfycode"];
    [params setObject:codeid forKey:@"codeid"];
    __weak QDRForgetPassWordViewModel *wself = self;
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        _status = [dic objectForKey:@"status"];
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _loginModel = [QDRLoginDataModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
//            [[NSUserDefaults standardUserDefaults] setObject:_loginModel.usertype forKey:LOCAL_READ_USERTYPE];
//            // 保存用户ID
//            [[NSUserDefaults standardUserDefaults] setObject:_loginModel.userid forKey:LOCAL_READ_USERID];
//            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:LOCAL_READ_USERNAME];
//            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:LOCAL_READ_MOBILE];
//            [[NSUserDefaults standardUserDefaults] setObject:password forKey:LOCAL_READ_PASSWORD];
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}

@end
