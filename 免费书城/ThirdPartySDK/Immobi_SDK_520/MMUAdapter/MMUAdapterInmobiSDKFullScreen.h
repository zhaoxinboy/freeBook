//
//  MMUAdapterInmobiSDKFullScreen.h
//  MMUSDK
//
//  Created by GaoBin on 16/2/29.
//  update by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"
#import "MMUInterstitialAdNetworkAdapter.h"

@interface MMUAdapterInmobiSDKFullScreen : MMUInterstitialAdNetworkAdapter<IMInterstitialDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    BOOL canRemove;
}

@property (nonatomic, strong) IMInterstitial *interstitialAd;

@end
