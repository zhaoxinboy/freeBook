//
//  MMUInterstitials.h
//  MMUSDK
//
//  Created by hale on 15/8/2.
//  Updated by liufuyin on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMUBrowserDelegate.h"


@protocol MMUInterstitialDelegate;
@class MMUInterstitialAdNetworkAdapter;
@interface MMUInterstitials : NSObject

@property (nonatomic, weak, readonly) id<MMUInterstitialDelegate> delegate;
@property (nonatomic, weak, readonly) id<MMUBrowserDelegate> browserDelegate;
@property (nonatomic, copy) NSString *mTags; // 设置当前用户的标签信息
/**
 初始化方法
 @param  slotID 广告位ID
 @param  isManualRefresh 是否手动刷新
 @param  delegate 插屏回调对象
 @param  browserDelegate 浏览器(二跳页面)回调对象
 @return 开屏广告对象
 */
- (id)initInterstitialWithSlotID:(NSString *)slotID
                 isManualRefresh:(BOOL)isManualRefresh
                        delegate:(id<MMUInterstitialDelegate>)delegate
                 broswerDelegate:(id<MMUBrowserDelegate>)broswerDelegate;


/**
 开屏请求并展示
 */
- (void)interstitialLoadAndShow;

/*
 插屏加载
 */
- (void)interstitialLoad;

/*
 展示插屏
 */
- (void)showInterstitial;

/**
 取消开屏展示
 */
- (void)interstitialCancel;

/*
 关闭插屏
 支持平台：阿里妈妈
 */
- (void)closeInterstitial;


@end

@protocol MMUInterstitialDelegate <NSObject>

/**
 @return 所需UIViewController,不能为空
 */
- (UIViewController *)viewControllerForPresentingInterstitialModalView;

/*
 插屏请求成功
 */
- (void)interstitialRequestAdSuccess;

/*
 插屏失败
 */
- (void)interstitialFailWithError:(NSError *)error;

/*
 插屏展现
 */
- (void)interstitialAdDidPresent;

/*
 插屏点击
 */
- (void)interstitialAdClick;

/*
 插屏关闭
 */
- (void)interstitialViewClose;

@end
