//
//  MMUAdapterBaiduSplash.m
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  update by liufuyin on 16/8/31.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "BaiduMobAdSplash.h"
#import "MMUAdapterBaiduSplash.h"
#import "MMUSDKSplashNetworkRegistry.h"
#import "MMUErrorType.h"

@implementation MMUSplashsBgView

- (BOOL) isHidden
{
    return NO;
}

@end

@interface MMUAdapterBaiduSplash()

@property (nonatomic,strong) BaiduMobAdSplash *splash;
@property  (nonatomic,strong) NSTimer *timer;
@property(nonatomic, strong) UIView *mBgView;
@end
@implementation MMUAdapterBaiduSplash

+ (MMUAdNetworkType)networkType{
    return MMUAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[MMUSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    _splash = [[BaiduMobAdSplash alloc] init];
    self.splash.AdUnitTag = [self AdPlaceId];
    _splash.delegate = self;
    _splash.canSplashClick = YES;
    NSDictionary *customReqPams = [self.ration valueForKey:ADAPTER_ADDTION_INFO];
    UIWindow *window = [customReqPams objectForKey:KEY_SPLASH_SUPERWINDOW];
    UIView *splashSuperView = [customReqPams objectForKey:KEY_SPLASH_SUPERVIEW];
    UIView *defaultView = [customReqPams objectForKey:KEY_SPLASH_DEFAULTVIEW];
   
    if(splashSuperView.window)
    {
        if (window && window != splashSuperView.window) {
            [self adSplashFailWithError:MMUE_Splash_WindowNeed];
            return;
        }
        if (!window) {
            window = splashSuperView.window;
        }
    }
    
    if (!window || ![window isKindOfClass:[UIWindow class]])
    {
        [self adSplashFailWithError:MMUE_Splash_WindowNeed];
        return;
    }
    
    //如果defaultView和splashSuperView两者都为nil
    if (!defaultView && !splashSuperView)
    {
        [_splash loadAndDisplayUsingKeyWindow:window];
        [self adSplashStartRequestWithInfo:@{}];
        return;
    }
    
    //不能有父视图
    if (defaultView && [defaultView superview])
    {
        [self adSplashFailWithError:MMUE_Splash_ReserveViewSuper];
        return;
    }
    
    CGFloat dWidth = 0;
    CGFloat dHeight = 0;
    //尺寸必须合法
    if (defaultView)
    {
        dWidth = defaultView.bounds.size.width;
        dHeight = defaultView.bounds.size.height;
        if (dWidth <= 0 || dHeight <= 0)
        {
            [self adSplashFailWithError:MMUE_Splash_ReserveViewSizeInvalid];
            return;
        }
    }
    
    self.mBgView = [[MMUSplashsBgView alloc] initWithFrame:window.bounds];
    self.mBgView.backgroundColor = [UIColor whiteColor];
    _mBgView.hidden = YES;
    
    UIView *containerView = nil;
    if (splashSuperView){
        containerView = splashSuperView;
        if(!splashSuperView.window)
        {
            splashSuperView.frame = splashSuperView.bounds;
            [_mBgView addSubview:splashSuperView];
        }
    }else if (defaultView){
        defaultView.frame = CGRectMake(0,_mBgView.bounds.size.height - dHeight*(_mBgView.bounds.size.width/dWidth),_mBgView.bounds.size.width,dHeight*(_mBgView.bounds.size.width/dWidth));
        [_mBgView addSubview:defaultView];
        
        CGRect containerFrame = CGRectMake(0,0 , _mBgView.bounds.size.width, _mBgView.bounds.size.height - defaultView.bounds.size.height);
        containerView = [[UIView alloc] initWithFrame:containerFrame];
        [_mBgView addSubview:containerView];
        [window addSubview:_mBgView];
    }
    
    if (containerView) {
        [_splash loadAndDisplayUsingContainerView:containerView];
        [self adSplashStartRequestWithInfo:@{}];
    }else{
        [self adSplashFailWithError:MMUE_Splash_ReserveViewSizeInvalid];
        return;
    }
}

-(void)stopBeingDelegate
{
    if(!_splash) return;
    _splash.delegate = nil;
    self.splash = nil;
}

- (void)loadAdTimeOut:(NSTimer*)theTimer
{
    [self stopBeingDelegate];
    [super loadAdTimeOut:theTimer];
}

#pragma mark BaiduMobAdInterstitialDelegate
/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString *)publisherId{
    NSDictionary* config = [self.ration objectForKey:@"netset"];
    NSString *publishId = [config objectForKey:@"AppID"];
    return publishId;
}

- (NSString *)AdPlaceId {
    NSDictionary* config = [self.ration objectForKey:@"netset"];
    NSString* AdPlaceId = [config objectForKey:@"AdPlaceID"];
    return AdPlaceId;
}

/**
 *  渠道id
 */
- (NSString*) channelId{
    return @"13b50d6f";
}

/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{

    NSDictionary *splashInfo = nil;
    if (splash) {
        splashInfo = @{KEY_SPLASHOBJECT:splash};
    }
    _mBgView.hidden = NO;
    
    [self adSplashSuccessWithInfo:splashInfo];
    if ([self.splashDelegate respondsToSelector:@selector(splashSuccess:)]) {
        [self.splashDelegate splashSuccess:splash];
    }
    
    [self adSplashDidPresentWithInfo:splashInfo];
    if ([self.splashDelegate respondsToSelector:@selector(splashDidPresent:)])
    {
        [self.splashDelegate splashDidPresent:splash];
    }
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash
                       withError:(BaiduMobFailReason) reason
{
    if (_mBgView.superview) [_mBgView removeFromSuperview];
    [self adSplashFailWithError:MMUE_PFAdFailed];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash
{
    if (_mBgView.superview) [_mBgView removeFromSuperview];
    if ([self.splashDelegate respondsToSelector:@selector(splashDidDismiss:)])
    {
        [self.splashDelegate splashDidDismiss:splash];
    }
}

@end
