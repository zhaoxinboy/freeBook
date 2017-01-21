//
//  MMUInterstitialAdNetworkAdapter.h
//  MMUSDK
//
//  Created by hale on 15/8/5.
//  Updated by liufuyin on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import "NSDictionary+MMUExtension.h"
#import "MMUAdNetworkType.h"
#import "MMUAdNetworkAdapter.h"
#import "MMUBrowserDelegate.h"
#import "MMUInterstitials.h"
#import "MMUErrorType.h"


#define KEY_INTERSTITIAL_ADAPTER        @"IntersAdapter"
#define KEY_INTERSTITIAL_NULL           @""
#define KEY_INTERST_ADDINFO             @"IntersAddInfo"
#define KEY_INTERST_OBJ                 @"IntersObject"


typedef enum {
    ST_MMUInterstitialAapterNULL = 1,    //
    ST_MMUInterstitialAapterRequest = 2,
    ST_MMUInterstitialAapterReady = 3,
    ST_MMUInterstitialAapterShow = 4,
    ST_MMUInterstitialAapterClosed = 5,
    ST_MMUInterstitialAapterEnd = 6,
    ST_MMUInterstitialAapterTimeOut = 7
} MMUInterstitialAdapterState;

@class MMUInterstitialsRationController;
@interface MMUInterstitialAdNetworkAdapter : MMUAdNetworkAdapter
@property (nonatomic,weak) id<MMUInterstitialDelegate> delegate;
@property (nonatomic,weak) id<MMUBrowserDelegate> browserDelegate;

@property (nonatomic) MMUInterstitialAdapterState mInterstitialState;


/*
 插屏广告适配器
 */
- (id)initWithAdsMoGoInterstitialDelegate:(id<MMUInterstitialDelegate>)delegate
                          broswerDelegate:(id<MMUBrowserDelegate>)browserDelegate
                         rationController:(MMUInterstitialsRationController*)interstitial
                            networkConfig:(NSDictionary *)netConf;

- (void)presentInterstitial;
- (void)closeInterstitial;
// 是否支持预加载
- (BOOL)isSupportCache;
 

/**
 聚合平台通知插屏请求开始
 @param  info 附加信息包括插屏view KEY_INTERST_OBJ
 */
- (void)adInterstitialStartRequestWithInfo:(NSDictionary*)info;

/**
 聚合平台通知插屏数据获取失败
 @param  error 错误信息
 */
- (void)adInterstitialFailWithError:(MMUErrorType)error;


/**
 聚合平台通知将要展示
 @param  info 附加信息包括插屏view KEY_INTERST_OBJ
 */
- (void)adInterstitiaWillPresentWithInfo:(NSDictionary*)info;

/**
 聚合平台通知将要展示
 @param  info 附加信息包括插屏view KEY_INTERST_OBJ
 */
- (void)adInterstitiaDidReceiveWithInfo:(NSDictionary*)info;

/**
 聚合平台通知已经展示
 @param  info 附加信息包括插屏view KEY_INTERST_OBJ
 */
- (void)adInterstitiaDidPresentWithInfo:(NSDictionary*)info;

/**
 聚合平台通知点击
 @param  info 附加信息包括插屏view KEY_INTERST_OBJ
 */
- (void)adInterstitialClickedWithInfo:(NSDictionary*)info;

/**
 聚合平台通知关闭
 @param  info 附加信息包括插屏view KEY_INTERST_OBJ
 */
- (void)adInterstitialDismissScreenWithInfo:(NSDictionary*)info;
@end
