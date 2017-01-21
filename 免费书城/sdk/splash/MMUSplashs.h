//
//  MMUSplashs.h
//  MMUSDK
//
//  Created by hale on 15/7/31.
//  Updated by liufuyin on 16/6/1.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMUSplashs.h"
#import "MMUBrowserDelegate.h"

@protocol MMUSplashsDelegate;
@class MMUSplashAdNetworkAdapter;

@interface MMUSplashs : NSObject
@property (nonatomic,weak,readonly) id<MMUSplashsDelegate> delegate;
@property (nonatomic,weak,readonly) id<MMUBrowserDelegate> browserDelegate;

@property (nonatomic, copy) NSString *mTags; // 设置当前用户的标签信息
@property (nonatomic, weak) UIView *mViewForSplash;     //用户创建，用于展示开屏广告
@property (nonatomic, weak) UIWindow *mWindowForSplash; //开屏所在Window
@property (nonatomic, strong) UIView *mReserveView;     //App Logo或者底边view

/**
 初始化方法
 @param  slotId 广告位ID
 @param  delegate 开屏回调代理
 @param  browserDelegate 开屏回调浏览器代理
 @return 开屏广告对象
 */
- (id) initWithSlotId:(NSString *)slotId
       splashDelegate:(id<MMUSplashsDelegate>)delegate
      broswerDelegate:(id<MMUBrowserDelegate>)browserDelegate;

/**
 请求开屏
 */
- (void)requestSplashAd;

@end

@protocol MMUSplashsDelegate <NSObject>
@required

/**
 @return 所需UIViewController,不能为空
 */
- (UIViewController *)splashAdsViewControllerForPresentingModalView;
@optional

/**
 开屏成功
 @param  splashAds 开屏对象
 */
- (void)splashSuccess:(id)splashAds;

/**
 开屏失败
 @param  splashAds 开屏对象
 @param  err 错误信息
 */
- (void)splashAllAdFail:(id)splashAds
              withError:(NSError *)err;

/**
 开屏展示的回调
 @param  splashAds 开屏对象
 */
- (void)splashDidPresent:(id)splashAds;

/**
 开屏点击
 @param  splashAds 开屏对象
 */
- (void)splashDidClicked:(id)splashAds;

/**
 开屏消失的回调
 @param  splashAds 开屏对象
 */
- (void)splashDidDismiss:(id)splashAds;

@end
