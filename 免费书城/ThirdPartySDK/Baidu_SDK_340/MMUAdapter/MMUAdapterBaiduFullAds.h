//
//  MMUAdapterBaiduFullAds.h
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMUInterstitialAdNetworkAdapter.h"
#import "BaiduMobAdInterstitial.h"
@interface MMUAdapterBaiduFullAds : MMUInterstitialAdNetworkAdapter
{
//    BaiduMobAdInterstitial *baiduInterstitial;
    BOOL isLocationOn;
   
    BOOL isStop;
}
+ (MMUAdNetworkType)networkType;
@end
