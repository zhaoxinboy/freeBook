//
//  MMUAdapterGoogleAdMobAds.h
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUBannerAdNetworkAdapter.h"
#import <GoogleMobileAds/GADBannerViewDelegate.h>
@interface MMUAdapterGoogleAdMobAds : MMUBannerAdNetworkAdapter
<GADBannerViewDelegate> 
+ (MMUAdNetworkType)networkType;
@end
