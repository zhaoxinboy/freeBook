//
//  MMUMamaResponse.h
//  MMUSDK
//
//  Created by liuyu on 16/1/13.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com


#import <Foundation/Foundation.h>

@class MMUMamaPromoter;

@interface MMUMamaResponse : NSObject <NSCopying>

@property (nonatomic, readonly, assign) NSInteger landingWidth;   // 创意素材对应的宽度
@property (nonatomic, readonly, assign) NSInteger landingHeight;  // 创意素材对应的高度
@property (nonatomic, readonly, assign) NSInteger templateType;   // 创意数据对应的模板类型

- (nullable instancetype)initWithAttributes:(nonnull NSDictionary *)attributes;

- (nonnull NSArray<MMUMamaPromoter *> *)creatives; // 创意列表
- (nonnull NSDictionary *)settings; // 创意展现相关的一些控制信息
- (nullable NSDictionary *)azSettings; // 推广位相关的一些信息
- (nullable NSDictionary *)platformInfo; // 平台信息

@end
