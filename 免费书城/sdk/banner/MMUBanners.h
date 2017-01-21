//
//  MMUBanners.h
//  MMUSDK
//
//  Created by hale on 15/7/30.
//  Update by liufuyin on 16/3/16.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMUBrowserDelegate.h"

typedef NS_OPTIONS(NSUInteger, PositionType) {
    PositionTypeTop_left       = 1 << 0,
    PositionTypeTop_middle     = 1 << 1,
    PositionTypeTop_right      = 1 << 2,
    
    PositionTypeMiddle_left    = 1 << 3,
    PositionTypeMiddle_middle  = 1 << 4,
    PositionTypeMiddle_right   = 1 << 5,
    
    PositionTypeDown_left      = 1 << 6,
    PositionTypeDown_middle    = 1 << 7,
    PositionTypeDown_right     = 1 << 8,
    PositionTypeCustom         = 1 << 9,
};

typedef enum {
    MMUBannerNormal = 1,
    MMUBannerLarger = 2,
    MMUBannerMedium = 3,
    MMUBannerRectangle = 4,
    MMUBannerCustomSize = 5,
    MMUBannerUnknow = 1000, // 位置类型
} MMUBannerType;

@protocol MMUBannersDelegate;

@interface MMUBanners : UIView

@property (nonatomic, weak, readonly) id<MMUBannersDelegate> delegate;
@property (nonatomic, weak, readonly) id<MMUBrowserDelegate> browserDelegate;
@property (nonatomic, copy) NSString *mTags; // 设置当前用户的标签信息
@property (nonatomic, assign) float mPreferredWidth; // 用于设置在当前设备上期望的banner宽度，设置该属性后，将按照此宽度等比计算banner的高度，默认为-1，即不对banner的宽高做等比适配

/**
 初始化方法
 @param  adid 广告位ID
 @param  delegate 横幅回调代理
 @param  browserDelegate 横幅回调浏览器代理
 @return 开屏广告对象
 */
- (id)initWithSlotId:(NSString *)adid
     bannersDelegate:(id<MMUBannersDelegate>) delegate
     browserDelegate:(id<MMUBrowserDelegate>) browserDelegate
        positionType:(PositionType) positionType;

/**
 返回广告相对位
 */
- (PositionType)getViewPositiontType;

/**
 设置广告相对位置
 */
- (void)setViewPointType:(PositionType)positionType;

@end

@protocol MMUBannersDelegate <NSObject>

@required
/**
 @return 所需UIViewController,不能为空
 */
- (UIViewController *)bannerViewControllerForPresentingModalView;

@optional
// 横幅成功
- (void)bannerAdsSuccess:(MMUBanners *)bannerAds;
// 横幅失败
- (void)bannerAdsAllAdFail:(MMUBanners *)bannerAds
                 withError:(NSError *)err;
// 横幅展现
- (void)bannerAdsAppear:(MMUBanners *)bannerAds;
// 横幅点击
- (void)bannerClick:(MMUBanners *)bannerAds;
// 横幅关闭
- (void)bannerClosed:(MMUBanners *)bannerAds;

/**
 *Banner关闭回调
 返回 YES 表示由开发者处理关闭广告事件
 返回 NO 表示由sdk处理关闭广告事件
 */
- (BOOL)dealCloseAd:(MMUBanners *)bannerAds;

@end