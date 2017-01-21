//
//  MMUAdapterInmobiSDK.h
//  MMUSDK
//
//  Created by GaoBin on 16/2/29.
//  update by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "IMSdk.h"
#import "IMBanner.h"
#import "IMBannerDelegate.h"
#import "MMUBannerAdNetworkAdapter.h"

@interface MMUAdapterInmobiSDK : MMUBannerAdNetworkAdapter<IMBannerDelegate>
{
}

@property (nonatomic, strong) IMBanner *bannerView;

@end
