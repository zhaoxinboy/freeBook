//
//  QDRSearchViewModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/6.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"
#import "QDRSearchPromptView.h"

@interface QDRSearchViewModel : BaseViewModel

// 添加APP
- (void)postAddAppInfoToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle;

// 删除APP
- (void)postDeleteCollectAppByUserid:(NSString *)userid appid:(NSString *)appid CompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) NSString *errorStr;


// 主页网址数据
@property (nonatomic, strong) QDRHomeAddressModel *SearchResultModel;
//获取搜索结果
- (void)getSearchResultFromNetWithStr:(NSString *)str withsearchView:(QDRSearchPromptView *)searchView CompleteHandle:(CompletionHandle)completionHandle;

@end
