//
//  QDRUserFeedbackViewModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"

@interface QDRUserFeedbackViewModel : BaseViewModel

@property (nonatomic ,strong) NSString *isSuccess;  //是否成功保存字符串

- (void)postResetPasswordWithUserID:(NSString *)userid content:(NSString *)content NetCompleteHandle:(CompletionHandle)completionHandle;

@end
