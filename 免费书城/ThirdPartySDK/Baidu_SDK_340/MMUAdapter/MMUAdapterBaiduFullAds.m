//
//  MMUAdapterBaiduFullAds.m
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUAdapterBaiduFullAds.h"
#import "MMUSDKInterstitialNetworkRegistry.h"

#define kAdMoGoBaiduAppInterstitialIDKey @"AppID"
#define kAdMoGoBaiduAppInterstitialSecretKey @"AppSEC"


@interface MMUAdapterBaiduFullAds()<UIGestureRecognizerDelegate,BaiduMobAdInterstitialDelegate>{
    int clickCount;
}
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) BaiduMobAdInterstitial *baiduInterstitial;
@end

@implementation MMUAdapterBaiduFullAds

+ (MMUAdNetworkType)networkType{
    return MMUAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[MMUSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    
    clickCount = 0;
    isStop = NO;
    _baiduInterstitial = [[BaiduMobAdInterstitial alloc] init];
    self.baiduInterstitial.AdUnitTag = [self AdPlaceId];
    _baiduInterstitial.delegate = self;
    _baiduInterstitial.interstitialType = BaiduMobAdViewTypeInterstitialOther;
    [self adInterstitialStartRequestWithInfo:@{KEY_INTERSTITIAL_ADAPTER:self}];
    [_baiduInterstitial load];
}

-(void)stopBeingDelegate
{
    if(!_baiduInterstitial) return;
    
    _baiduInterstitial.delegate = nil;
    self.baiduInterstitial = nil;
}

- (void)presentInterstitial
{
    if (!_baiduInterstitial.isReady)
    {
        return;
    }
    UIViewController *viewController = [self.delegate viewControllerForPresentingInterstitialModalView];
    [_baiduInterstitial presentFromRootViewController:viewController];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [self stopBeingDelegate];
    [super loadAdTimeOut:theTimer];
}



#pragma mark BaiduMobAdInterstitialDelegate 
/**
 *  应用在mounion.baidu.com上的id
 */
- (NSString *)publisherId{
    NSDictionary* config = [self.ration mmuDictionaryValueForKey:@"netset"];
    NSString *publishId = [config mmuStringValueForKey:@"AppID"];
    return publishId;
}

- (NSString *)AdPlaceId {
    NSDictionary* config = [self.ration mmuDictionaryValueForKey:@"netset"];
    NSString* AdPlaceId = [config mmuStringValueForKey:@"AdPlaceID"];
    return AdPlaceId;
}

/**
 *  应用在mounion.baidu.com上的计费名
 */
- (NSString*) appSpec{
    NSDictionary* config = [self.ration objectForKey:@"netset"];
    NSString *appSpec = [config objectForKey:@"AppSEC"];
    return appSpec;

}

/**
 *  渠道id
 */
- (NSString*) channelId{
    return @"13b50d6f";
}



/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)_interstitial
{
      [self adInterstitiaDidReceiveWithInfo:nil];
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    [self adInterstitialFailWithError:MMUE_PFAdFailed];
}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    [self adInterstitiaWillPresentWithInfo:@{KEY_INTERST_OBJ:object_validate(_baiduInterstitial, KEY_INTERSTITIAL_NULL)}];
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    [self adInterstitiaDidPresentWithInfo:@{KEY_INTERST_OBJ:object_validate(_baiduInterstitial, KEY_INTERSTITIAL_NULL)}];
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)_interstitial withError:(BaiduMobFailReason) reason{
    if ([self.delegate respondsToSelector:@selector(interstitialFailPresentScreen:withError:)])
    {
        [self.delegate performSelector:@selector(interstitialFailPresentScreen:withError:) withObject:_interstitial withObject:[NSNumber numberWithInt:reason]];
    }
}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)_interstitial
{
    [self adInterstitialDismissScreenWithInfo:@{KEY_INTERST_OBJ:object_validate(_interstitial, KEY_INTERSTITIAL_NULL)}];
}

- (void)interstitialDidAdClicked:(BaiduMobAdInterstitial *)interstitial{
    [self adInterstitialClickedWithInfo:@{}];
}


@end
