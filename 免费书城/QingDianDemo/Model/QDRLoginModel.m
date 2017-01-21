//
//  QDRLoginModel.m
//  QingDianDemo
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRLoginModel.h"

@implementation QDRLoginModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"kData":[QDRLoginDataModel class]};
}

@end

@implementation QDRLoginStatusModel

@end

@implementation QDRLoginDataModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userid":@"id"};
}

@end

@implementation QDRFirstModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userid":@"id"};
}

@end

@implementation QDRIsLoginModel


@end

@implementation QDRWXLgoinModel


@end

@implementation QDRQQLgoinModel


@end



