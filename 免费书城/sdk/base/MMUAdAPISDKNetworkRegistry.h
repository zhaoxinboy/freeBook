//
//  MMUAdAPISDKNetworkRegistry.h
//  MMUSDK
//
//  Created by liufuyin on 16/2/20.
//  Created by liufuyin on 16/3/16.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>

@interface MMUAdAPISDKNetworkRegistry : NSObject {
    NSMutableDictionary *adapterDict;
}
- (NSMutableDictionary *)getAdapterDict;
- (void)setAdapterDict:(NSMutableDictionary *)adapterDict;
- (void)registerClass:(Class)adapterClass;

- (Class)adapterClassFor:(NSInteger)adNetworkType;
@end
