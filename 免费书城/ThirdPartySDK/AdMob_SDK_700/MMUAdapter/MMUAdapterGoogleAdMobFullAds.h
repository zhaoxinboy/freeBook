//
//  MMUAdapterGoogleAdMobFullAds.h
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//


#import "MMUInterstitialAdNetworkAdapter.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>

@interface MMUAdapterGoogleAdMobFullAds : MMUInterstitialAdNetworkAdapter<GADInterstitialDelegate> {
     GADInterstitial *gadinterstitial;
}

+ (MMUAdNetworkType)networkType;

@end
