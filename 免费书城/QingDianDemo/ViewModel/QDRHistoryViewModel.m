//
//  QDRHistoryViewModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRHistoryViewModel.h"

@implementation QDRHistoryViewModel

- (void)getHistoryByUseridWithUserid:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle{
    __weak QDRHistoryViewModel *wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/soil/getHistoryByUserid?userid=%@", URLPATH, userid];
    self.dataTask = [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _historyModel = [QDRHistoryModel mj_objectWithKeyValues:responseObj];
            NSLog(@"%@", _historyModel.data);
            if (wself.dataArr && _historyModel.data) {
                [wself.dataArr removeAllObjects];
            }
            if (_historyModel.data){
                [wself.dataArr addObjectsFromArray:_historyModel.data];
            }
        }else{
            NSString *errorStr = [wself promptStrWithStatus:[dic objectForKey:@"status"]];
            [wself showErrorMsg:errorStr];// 显示错误信息
        }
        completionHandle(error);
    }];
}

-(NSInteger)rowNumber{
    return self.dataArr.count;
}
- (QDRHistoryArrModel *)videoListModelForRow:(NSInteger)row{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]);
    NSLog(@"%@", self.dataArr);
    NSLog(@"%ld", (long)row);
    QDRHistoryArrModel *model = self.dataArr[row];
    NSLog(@"%ld", (long)[model.appID integerValue]);
    return model;
}
- (NSURL *)imageURLForRow:(NSInteger)row{
    NSString *path = [NSString stringWithFormat:@"%@%@", URLPATH, (NSString *)[self videoListModelForRow:row].applogopath];
    if ([path includeChinese]) {
        return [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return [NSURL URLWithString:path];
}
- (NSString *)addressURLForRow:(NSInteger)row{
    NSString *path = [self videoListModelForRow:row].appurl;
    return path;
}
- (NSString *)appNameForRow:(NSInteger)row{
    NSString *appname = [self videoListModelForRow:row].appname;
    return appname;
}
- (NSInteger)appIdForRow:(NSInteger)row{
    NSLog(@"%ld", (long)[[self videoListModelForRow:row].appID integerValue]);
    NSInteger appID = [[self videoListModelForRow:row].appID integerValue];
    return appID;
}
- (NSString *)superCodeForRow:(NSInteger)row{
    NSString *superCode = [self videoListModelForRow:row].supercode;
    return superCode;
}

@end
