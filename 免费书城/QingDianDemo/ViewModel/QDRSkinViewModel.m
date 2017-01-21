//
//  QDRSkinViewModel.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/16.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSkinViewModel.h"

@implementation QDRSkinViewModel

- (void)getSkinByUserid:(NSString *)userid NetCompleteHandle:(CompletionHandle)completionHandle{
    __weak typeof (self) wself = self;
    NSString *path = [NSString stringWithFormat:@"%@/soil/getSkinByUserid?userid=%@", URLPATH, userid];
    [QDRNetManager GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObj;
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            _skinModel = [QDRSkinModel mj_objectWithKeyValues:responseObj];
            NSLog(@"%@", _skinModel.data);
            if (wself.dataArr && _skinModel.data) {
                [wself.dataArr removeAllObjects];
            }
            if (_skinModel.data){
                [wself.dataArr addObjectsFromArray:_skinModel.data];
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
- (QDRSkinDataModel *)skinListModelForRow:(NSInteger)row{
    return self.dataArr[row];
}

- (NSString *)skinIdForRow:(NSInteger)row{
    NSString *skinId = [NSString stringWithFormat:@"%@", [self skinListModelForRow:row].skinId];
    return skinId;
}
- (NSString *)skinNameForRow:(NSInteger)row{
    NSString *skinName = [NSString stringWithFormat:@"%@", [self skinListModelForRow:row].name];
    return skinName;
}
- (NSURL *)skinPicaddrForRow:(NSInteger)row{
    NSString *skinPicaddr = [NSString stringWithFormat:@"%@%@", URLPATH,[self skinListModelForRow:row].picaddr];
    NSURL *url = [NSURL URLWithString:skinPicaddr];
    return url;
}

@end
