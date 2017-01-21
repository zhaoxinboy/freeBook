//
//  MMUBannerAdNetworkAdapter.h
//  MMUSDK
//
//  Created by hale on 15/8/3.
//  Updated by liufuyin on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import "MMUAdNetworkType.h"
#import "MMUAdNetworkAdapter.h"
#import "MMUBanners.h"
#import "MMUErrorType.h"

#define KEY_BANNEROBJECT    @"bannerObject"
#define KEY_BANNERNULL      @"bannerNull"
#define KEY_BANNERPLATFORM     @"bannerPlatfrom"
#define KEY_PRESENTMSG_COUNT     @"presentMsgCount"


#define DEF_MULTIPSIGN             @"x"    //乘号
//ration asseting
#define KEY_BANNER_SIZE            @"asz"
#define KEY_NETSET                 @"netset"
#define KEY_AZSET                  @"azset"
//userdefine
#define KEY_BANNER_TYPE            @"type"
#define KEY_BANNER_WIDTH           @"width"
#define KEY_BANNER_HEIGHT          @"height"
//pattern add info
#define KEY_BANNER_PWIDTH          @"preferredWidth"


@protocol MMUBannersAdapterDelegate;
@class MMUBannerRationController;
@interface MMUBannerAdNetworkAdapter : MMUAdNetworkAdapter
@property (nonatomic,weak) id<MMUBannersDelegate> delegate;
@property (nonatomic,weak) id<MMUBrowserDelegate> browserDelegate;

/*
 横幅广告适配器
 */
- (id)initWithBannerDelegate:(id<MMUBannersDelegate>)delegate
             broswerDelegate:(id<MMUBrowserDelegate>)browserDelegate
            rationController:(MMUBannerRationController *)rationController
               networkConfig:(NSDictionary *)netConf;

/*
 横幅适配器是否支持点击回调
 */
- (BOOL)isSupportClickDelegate;

/*
 调整banner的大小
 */
- (CGSize)adjustWithSize:(CGSize)size;

//计算banner的类型
- (NSDictionary*)typeInfoWithDescription:(NSString*)sizeInfo;

/**
 聚合平台通知横幅请求开始
 @param  BannerInfo 附加信息
 */
- (void)adBannerStartRequestWithInfo:(NSDictionary*)bannerInfo;

/**
 聚合平台通知横幅成功
 @param  BannerInfo 附加信息
 */
- (void)adBannerSuccessWithInfo:(NSDictionary*)bannerInfo;

/**
 聚合平台通知横幅失败
 @param  error 错误类型
 */
- (void)adBannerFailWithError:(MMUErrorType)error;

/**
 聚合通知获取平台Banner
 @param  error 附加信息
 */
- (void)adBannerDidReceiveBannerView:(NSDictionary *)bannerInfo;

/**
 聚合通知,平台横幅被点击
 @param  error 附加信息
 */
- (void)adBannerClicked:(NSDictionary *)bannerInfo;

/**
 聚合通知,平台横幅被挂起
 @param  error 附加信息
 */
- (void)adBannerSuspend:(NSDictionary *)bannerInfo;

/**
 聚合通知,平台横幅恢复
 @param  error 附加信息
 */
- (void)adBannerResumed:(NSDictionary *)bannerInfo;





@end
