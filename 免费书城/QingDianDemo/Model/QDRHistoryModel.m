//
//  QDRHistoryModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRHistoryModel.h"

@implementation QDRHistoryModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[QDRHistoryArrModel class]};
}

@end


@implementation QDRHistoryArrModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"appID":@"id"};
}

@end
