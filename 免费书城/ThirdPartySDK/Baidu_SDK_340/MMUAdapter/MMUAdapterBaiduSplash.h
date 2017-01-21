//
//  MMUAdapterBaiduSplash.h
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUSplashAdNetworkAdapter.h"
#import "BaiduMobAdSplashDelegate.h"

@interface MMUSplashsBgView : UIView
- (BOOL) isHidden;
@end

@interface MMUAdapterBaiduSplash : MMUSplashAdNetworkAdapter<BaiduMobAdSplashDelegate>

+ (MMUAdNetworkType)networkType;

@end
