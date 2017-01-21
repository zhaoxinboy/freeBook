//
//  QDRHomePage.m
//  QingDianDemo
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRHomePageModel.h"


@implementation QDRHomePageModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"kData":[QDRHomeDataModel class]};
}

@end


@implementation QDRHomeStatusModel



@end

@implementation QDRHomeDataModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"qdrid":@"id"};
}

@end

@implementation QDRHomeAddressModel

//定义两个数组对象中的元素，对应的解析类
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data":[QDRHomeAddressDataModel class]};
}

@end

@implementation QDRHomeAddressDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"qdrid":@"id"};
}


@end

@implementation QDRclassificationModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : [QDRclassiModel class]};
}
@end

@implementation QDRclassiModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"appinfo" : [QDRclassiDataModel class]};
}
@end

@implementation QDRclassiDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"qdrid":@"id"};
}

@end

@implementation QDRSkinModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data" : [QDRSkinDataModel class]};
}

@end

@implementation QDRSkinDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"skinId":@"id"};
}

@end
