//
//  QDRHomePageViewModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRHomePageViewModel.h"

@implementation QDRHomePageViewModel


// 主页相关
- (void)getDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/getCompanyInfoByUserid?userid=%@", URLPATH, @(userID)];
    
    __weak QDRHomePageViewModel *wself = self;
    self.dataTask = [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _HomeDataModel = [QDRHomeDataModel mj_objectWithKeyValues:[dic objectForKey:@"data"]];
        // 保存底部信息
        [[NSUserDefaults standardUserDefaults] setObject:_HomeDataModel.record forKey:LOCAL_READ_RECORD];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@", URLPATH, _HomeDataModel.logo] forKey:LOCAL_READ_HEADERURL];
        [[NSUserDefaults standardUserDefaults] setObject:_HomeDataModel.legal forKey:LOCAL_READ_LEGAL];//法律条款
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}

// 主页网址信息
- (void)getAddressDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle{
    
    NSString *path = [NSString stringWithFormat:@"%@/getAppInfoByUserid?userid=%@", URLPATH, @(userID)];
    __weak QDRHomePageViewModel *wself = self;
    self.dataTask = [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        _homeAddressModel = [QDRHomeAddressModel mj_objectWithKeyValues:responseObj];
        [wself.dataArr removeAllObjects];
        [wself.dataArr addObjectsFromArray:_homeAddressModel.data];
        completionHandle(error);
    }];
}
-(NSInteger)rowNumber{
    return self.dataArr.count;
}
- (QDRHomeAddressDataModel *)videoListModelForRow:(NSInteger)row{
    return self.dataArr[row];
}

- (NSString *)titleForRow:(NSInteger)row{
    NSString *title = [NSString stringWithFormat:@"%@",[self videoListModelForRow:row].appname];
    return title;
}
- (NSURL *)imageURLForRow:(NSInteger)row{
    NSString *path = [NSString stringWithFormat:@"%@%@", URLPATH, [self videoListModelForRow:row].applogopath];
    return [NSURL URLWithString:path];
}
- (NSURL *)addressURLForRow:(NSInteger)row{
    NSString *path = [self videoListModelForRow:row].appurl;
    return [NSURL URLWithString:path];
}
- (NSInteger)urlIDForRow:(NSInteger)row{
    NSInteger urlid = [[self videoListModelForRow:row].qdrid integerValue];
    return urlid;
}

- (NSString *)supercodeForRow:(NSInteger)row{
    NSString *supercode = [self videoListModelForRow:row].supercode;
    return supercode;
}

// 添加历史记录，在点击之后调用
- (void)postAddHistoryToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/addHistoryToUser", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)urlID] forKey:@"appid"];
    [params setObject:userid forKey:@"userid"];
    __weak QDRHomePageViewModel *wself = self;
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            NSString *str = [dic objectForKey:@"data"];
            if ([str isEqualToString:@"success"]) {
                //            [wself showSuccessMsg:@"历史记录添加成功"];
            }else{
                [wself showErrorMsg:@"历史记录添加失败"];
            }
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}


// 地理位置
- (void)postAddLocationByUserid:(NSString *)userID itude:(NSString *)itude location:(NSString *)location CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/addLocationByUserid", URLPATH];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userID forKey:@"userid"];
    [params setObject:itude forKey:@"itude"];
    [params setObject:location forKey:@"location"];
    __weak QDRHomePageViewModel *wself = self;
    self.dataTask = [QDRNetManager POST:path parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            NSLog(@"地理位置上传成功");
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            NSLog(@"地理位置   %@", errorStr);// 显示错误信息
        }
        completionHandle(error);
    }];
}


// 分类
- (void)getAllCategoryApps:(NSString *)userID CompleteHandle:(CompletionHandle)completionHandle{
    NSString *path = [NSString stringWithFormat:@"%@/getAllCategoryApps?userid=%@", URLPATH, userID];
    __weak QDRHomePageViewModel *wself = self;
    self.dataTask = [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _classModel = [QDRclassificationModel mj_objectWithKeyValues:responseObj];
            [wself.classArr removeAllObjects];
            [wself.classArr addObjectsFromArray:_classModel.data];
            
            [wself.classDataArr removeAllObjects];
            if (wself.classArr.count != 0) {
                for (int i = 0; i < wself.classArr.count; i++) {
                    [wself.classDataArr addObject:[wself classModelForRow:i].appinfo];
                }
            }
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}

- (NSMutableArray *)classArr{
    if (!_classArr) {
        _classArr = [NSMutableArray new];
    }
    return _classArr;
}

- (NSInteger)classRowNumber{
    return self.classArr.count;
}
- (QDRclassiModel *)classModelForRow:(NSInteger)row{
    return self.classArr[row];
}
- (NSString *)classTitleForRow:(NSInteger)row{
    NSString *title = [NSString stringWithFormat:@"%@",[self classModelForRow:row].categoryname];
    return title;
}

- (NSMutableArray *)classArrNumForRow:(NSInteger)row{
    NSMutableArray *arr = [self classModelForRow:row].appinfo;
    return arr;
}


- (NSInteger)classClassDataArrNumForRow:(NSInteger)row{
    return self.classDataArr.count;
}

- (NSInteger)classNumForRow:(NSInteger)row{
    [self.classDataArr removeAllObjects];
    [self.classDataArr addObjectsFromArray:[self classModelForRow:row].appinfo];
    NSLog(@"%@", self.classDataArr);
    return self.classDataArr.count;
}

- (NSMutableArray *)classDataArr{
    if (!_classDataArr) {
        _classDataArr = [NSMutableArray new];
    }
    return _classDataArr;
}

- (QDRclassiDataModel *)classDataModelForRow:(NSInteger)row{
    NSLog(@"%@", self.classDataArr);
    return self.classDataArr[row];
}

- (NSString *)classiDataTitleForRow:(NSInteger)row{
    NSString *title = [NSString stringWithFormat:@"%@",[self classDataModelForRow:row].appname];
    return title;
}
- (NSString *)classiDataIscollectedForRow:(NSInteger)row{
    NSString *iscollected = [NSString stringWithFormat:@"%@",[self classDataModelForRow:row].iscollected];
    NSLog(@"iscollected  %@", iscollected);
    return iscollected;
}
- (NSURL *)classiDataimageURLForRow:(NSInteger)row{
    
    NSString *path = [NSString stringWithFormat:@"%@%@", URLPATH, [self classDataModelForRow:row].applogopath];
    return [NSURL URLWithString:path];
}
- (NSURL *)classiDataaddressURLForRow:(NSInteger)row{
    NSString *path = [self classDataModelForRow:row].appurl;
    return [NSURL URLWithString:path];
}
- (NSInteger)classiDataurlIDForRow:(NSInteger)row{
    NSInteger urlid = [[self classDataModelForRow:row].qdrid integerValue];
    return urlid;
}

- (NSString *)classiDataSuperCodeForRow:(NSInteger)row{
    NSString *superCode = [self classDataModelForRow:row].supercode;
    return superCode;
}








@end
