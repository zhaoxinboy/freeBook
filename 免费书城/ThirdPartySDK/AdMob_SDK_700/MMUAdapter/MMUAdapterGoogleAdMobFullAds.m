//
//  MMUAdapterGoogleAdMobFullAds.m
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUAdapterGoogleAdMobFullAds.h"
#import "MMUSDKInterstitialNetworkRegistry.h"

@implementation MMUAdapterGoogleAdMobFullAds

+ (MMUAdNetworkType)networkType
{
    return MMUAdNetworkTypeAdMob;
}

+ (void)load
{
    [[MMUSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd
{
    id key_id = [self.ration objectForKey:@"netset"];
    NSString *key = nil;
    if (key_id && [key_id isKindOfClass:[NSDictionary class]]) {
        key = (NSString *)[key_id objectForKey:@"ID"];
    }
    
    gadinterstitial = [[GADInterstitial alloc] initWithAdUnitID:key];
    gadinterstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [self adInterstitialStartRequestWithInfo:@{KEY_INTERSTITIAL_ADAPTER:object_validate(self, KEY_INTERSTITIAL_NULL)}];
    [gadinterstitial loadRequest:request];
}

- (void)stopBeingDelegate {
    if (!gadinterstitial) return;
    gadinterstitial.delegate = nil;
    gadinterstitial = nil;
}

- (void)stopAd {
    [self stopBeingDelegate];
    [super stopAd];
}

- (void)presentInterstitial {
    [gadinterstitial presentFromRootViewController:[self.delegate viewControllerForPresentingInterstitialModalView]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSDictionary *dic = @{KEY_INTERST_OBJ:object_validate(ad, KEY_INTERSTITIAL_NULL)};
    [self adInterstitiaDidReceiveWithInfo:dic];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self adInterstitialFailWithError:MMUE_PFAdFailed];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    
    [self adInterstitialClickedWithInfo:@{KEY_INTERSTITIAL_ADAPTER:object_validate(self, KEY_INTERSTITIAL_NULL)}];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    NSDictionary *dic = @{KEY_INTERST_OBJ:object_validate(ad, KEY_INTERSTITIAL_NULL)};
    [self adInterstitialDismissScreenWithInfo:dic];
}


- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    NSDictionary *dic = @{KEY_INTERST_OBJ:object_validate(ad, KEY_INTERSTITIAL_NULL)};
    [self adInterstitiaWillPresentWithInfo:dic];
    [self adInterstitiaDidPresentWithInfo:dic];
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [self stopBeingDelegate];
    [super loadAdTimeOut:theTimer];
}
@end
