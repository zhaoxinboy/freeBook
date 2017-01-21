//
//  MMUAdapterBaiduMobAd.h
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUBannerAdNetworkAdapter.h"
#import "BaiduMobAdView.h"

@interface MMUAdapterBaiduMobAd : MMUBannerAdNetworkAdapter <BaiduMobAdViewDelegate>{
    BaiduMobAdView* sBaiduAdview;
}
- (void)loadAdTimeOut:(NSTimer*)theTimer;
+ (MMUAdNetworkType)networkType;
@end
