//
//  MMUSDK.h
//  MMUSDK
//
//  Created by liuyu on 12/23/14.
//  Updated by liufuyin 16/4/25.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MMUSDK : NSObject

@property (nonatomic, assign) BOOL mEnableDebugLog; // 默认为NO

+ (MMUSDK *)sharedInstance;

/**
 
 广告全局初始化，请在App启动时调用
 
 */

- (void)globalInitialize;

/**
 
 双11红包初始化，如果不需要红包功能，则无需调用此接口
 
 */

- (void)globalInitializeTBAppLinkWithAppkey:(NSString *)appkey andAppSecret:(NSString *)appSecret;

/**
 
 用于处理从其它App回跳当前App的case
 
 @return 是否经过了MMUSDK的处理
 
 */

- (BOOL)handleOpenURL:(NSURL *)url;

/**
 
 当前版本SDK的版本信息，示例：5.6.0.20150520
 
 @return 返回SDK版本号
 
 */

- (NSString *)sdkVersionStr;

@end