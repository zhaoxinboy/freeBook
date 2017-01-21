//
//  MMUNativePromoterManager.h
//  MMUSDK
//
//  Created by liuyu on 16/1/24.
//  Updated by liuyu on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com


#import <Foundation/Foundation.h>

@interface MMUMamaPromoter : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *promoterId; // 创意ID

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSDictionary *)materials; // 创意元信息，key会根据创意的类型有所变化
- (NSDictionary*)effects;
- (NSDictionary *)providerInfo;

@end
