//
//  MMUSplashAdNetworkAdapter.h
//  MMUSDK
//
//  Created by hale on 15/7/31.
//  Updated by liufuyin on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import "MMUAdNetworkType.h"
#import "MMUAdNetworkAdapter.h"
#import "MMUSplashs.h"
#import "MMUBrowserDelegate.h"
#import "MMUErrorType.h"

#define KEY_SPLASHOBJECT @"splashObject"
#define KEY_SPLASH_ADAPTER     @"adDIAdapter"
#define KEY_SPLASH_NULL       @""

#define KEY_SPLASH_SUPERVIEW @"viewForSplash"
#define KEY_SPLASH_SUPERWINDOW @"viewForWindow"
#define KEY_SPLASH_DEFAULTVIEW @"defaultView"

@class MMUSplashsRationController;
@interface MMUSplashAdNetworkAdapter : MMUAdNetworkAdapter

@property (nonatomic,weak) id<MMUSplashsDelegate> splashDelegate;
@property (nonatomic,weak) id<MMUBrowserDelegate> browserDelegate;
@property (nonatomic,readonly) NSTimeInterval rationEndTime;

/**
 开屏广告适配器初始化
 @param  delegate 开屏代理
 @param  browserDelegate 浏览器代理(第三方平台使用，暂时保留)
 @param  rationController 流量分配器
 @param  netConf 平台配置信息
 @return MMUSplashAdNetworkAdapter对象
 */

- (id)initWithSplashDelegate:(id<MMUSplashsDelegate>)delegate
             broswerDelegate:(id<MMUBrowserDelegate>)browserDelegate
            rationController:(MMUSplashsRationController *)rationController
               networkConfig:(NSDictionary *)netConf;

/**
 平台开屏是否支持缓存
 @return 是否支持缓存
 */
- (BOOL)isSupportSplashCache;

/**
 广告是否有效
 @return 有效性
 */
- (BOOL)isAdValid;


/**
 聚合平台通知开屏请求开始
 @param  splashInfo 附加信息
 */
- (void)adSplashStartRequestWithInfo:(NSDictionary*)splashInfo;

/**
 聚合平台通知开屏成功
 @param  splashInfo 附加信息
 */
- (void)adSplashSuccessWithInfo:(NSDictionary*)splashInfo;

/**
 聚合平台通知开屏失败
 @param  error 错误信息
 */
- (void)adSplashFailWithError:(MMUErrorType)error;

/**
 聚合平台通知已经展示
 @param  splashInfo 附加信息
 */
- (void)adSplashDidPresentWithInfo:(NSDictionary*)splashInfo;

/**
 聚合平台通知点击
 @param  splashAd 附加平台对象
 */
- (void)adSplashClickedWithInfo:(NSDictionary*)splashInfo;

@end
