//
//  QDRUserFeedbackViewModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRUserFeedbackViewModel.h"

@implementation QDRUserFeedbackViewModel

- (void)postResetPasswordWithUserID:(NSString *)userid content:(NSString *)content NetCompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/addFeedBackByUserid", URLPATH];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    [params setObject:content forKey:@"content"];
    __weak QDRUserFeedbackViewModel *wself = self;
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            wself.isSuccess = [dic objectForKey:@"data"];
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}


@end
