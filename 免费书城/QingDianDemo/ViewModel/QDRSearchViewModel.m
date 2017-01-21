//
//  QDRSearchViewModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/6.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSearchViewModel.h"

@implementation QDRSearchViewModel

// 添加用户APP
- (void)postAddAppInfoToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/addAppInfoToUser", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)urlID] forKey:@"appid"];
    [params setObject:userid forKey:@"userid"];
    __weak QDRSearchViewModel *wself = self;
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            NSString *str = [dic objectForKey:@"data"];
            if ([str isEqualToString:@"success"]) {
                [wself showSuccessMsg:@"添加成功"];
            }else{
                [wself showErrorMsg:@"添加失败"];
            }
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}

- (void)getSearchResultFromNetWithStr:(NSString *)str withsearchView:(QDRSearchPromptView *)searchView CompleteHandle:(CompletionHandle)completionHandle{
    __weak QDRSearchViewModel *wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/getSearchResult?key=%@", URLPATH, str];
    [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _SearchResultModel = [QDRHomeAddressModel mj_objectWithKeyValues:responseObj];
            [searchView.dataArr removeAllObjects];
            [searchView.dataArr addObjectsFromArray:_SearchResultModel.data];
            NSLog(@"%@", searchView.dataArr);
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}


// 删除APP
- (void)postDeleteCollectAppByUserid:(NSString *)userid appid:(NSString *)appid CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/deleteCollectAppByUserid", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:appid forKey:@"appid"];
    [params setObject:userid forKey:@"userid"];
    __weak QDRSearchViewModel *wself = self;
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            NSString *str = [dic objectForKey:@"data"];
            if ([str isEqualToString:@"success"]) {
                [wself showSuccessMsg:@"删除成功"];
            }else{
                [wself showErrorMsg:@"删除失败"];
            }
        }else{
            wself.errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:wself.errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}

@end
