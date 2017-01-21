//
//  MMUAdapterBaiduMobAd.m
//  MMUSDK
//
//  Created by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//
#import "MMUAdapterBaiduMobAd.h"
#import "MMUSDKBannerNetworkRegistry.h"
#import "NSDictionary+MMUExtension.h"
#import "MMUErrorType.h"


#define ASPECT_RATIO    6.4 // 320/50

#define kAdMoGoBaiduAppIDKey @"AppID"
#define kAdMoGoBaiduAppSecretKey @"AppSEC"
@interface MMUAdapterBaiduMobAd()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL issuccess;
@property (nonatomic,assign) BOOL isfail;

@end

@implementation MMUAdapterBaiduMobAd

+ (MMUAdNetworkType)networkType{
    return MMUAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[MMUSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    
    NSString* sizeInfoStr = [(NSDictionary*)[self.ration objectForKey:KEY_AZSET] objectForKey:KEY_BANNER_SIZE];
    NSDictionary* sizeInfo = [self typeInfoWithDescription:sizeInfoStr];
    NSNumber* typeInfo = [sizeInfo objectForKey:KEY_BANNER_TYPE];
    MMUBannerType type = (typeInfo && [typeInfo isKindOfClass:[NSNumber class]])?(MMUBannerType)[typeInfo intValue]:MMUBannerUnknow;
    
    CGSize size = CGSizeZero;
    switch (type)
    {
        case MMUBannerNormal:
            size = kBaiduAdViewBanner320x48;
            break;
        case MMUBannerRectangle:
            size = kBaiduAdViewSquareBanner300x250;
            break;
        case MMUBannerMedium:
            size = kBaiduAdViewBanner468x60;
            break;
        case MMUBannerLarger:
            size = kBaiduAdViewBanner728x90;
            break;
        case MMUBannerCustomSize:
        {
            CGFloat theWidth = [(NSNumber*)[sizeInfo objectForKey:KEY_BANNER_WIDTH] intValue];
            CGFloat theHeight = [(NSNumber*)[sizeInfo objectForKey:KEY_BANNER_HEIGHT] intValue];
            size = CGSizeMake(theWidth, theHeight);
            break;
        }
        default:
        {
            [self adBannerFailWithError:MMUE_Banner_SizeInvalid];
            return;
        }
    }

    sBaiduAdview = [[BaiduMobAdView alloc] init];
    sBaiduAdview.hidden = YES;
    sBaiduAdview.frame = CGRectMake(0.0, 0, size.width, size.height);
    
    sBaiduAdview.AdUnitTag = [self AdPlaceId];
    
    sBaiduAdview.delegate = self;
    [self adBannerStartRequestWithInfo:@{KEY_BANNEROBJECT:object_validate(sBaiduAdview, KEY_BANNERNULL)}];
    [sBaiduAdview start];
}

- (void)stopBeingDelegate{
	if (sBaiduAdview != nil) {
        sBaiduAdview.delegate = nil;
        sBaiduAdview = nil;
    }
}

- (BOOL)isSupportClickDelegate{
    return YES;
}


/**
 *  应用在mounion.baidu.com上的id
 */
- (NSString *)publisherId {
    NSDictionary* config = [self.ration mmuDictionaryValueForKey:KEY_NETSET];
    id key = config;
    id appID;
    NSString *appIDStr = NULL;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appID = [key objectForKey:kAdMoGoBaiduAppIDKey];
        if (appID != nil && ([appID isKindOfClass:[NSString class]])) {
            appIDStr = [NSString stringWithString:appID];
        }
    }
    return appIDStr;
}

- (NSString *)AdPlaceId {
    NSDictionary* config = [self.ration mmuDictionaryValueForKey:KEY_NETSET];
    NSString* AdPlaceId = [config objectForKey:@"AdPlaceID"];
    return AdPlaceId;
}

/**
 *  应用在mounion.baidu.com上的计费名
 */
- (NSString*) appSpec {
    NSDictionary* config = [self.ration mmuDictionaryValueForKey:KEY_NETSET];
    id key = config;
    id appSpec;
    NSString *appSpecStr = NULL;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appSpec = [key objectForKey:kAdMoGoBaiduAppSecretKey];
        if (appSpec != nil && ([appSpec isKindOfClass:[NSString class]])) {
            appSpecStr = [NSString stringWithString:appSpec];
        }
    }
    return appSpecStr;
}

/**
 *  设置成聚合平台的渠道id
 */
- (NSString*) channelId
{
    return @"13b50d6f";
}
/**
 *  广告将要被载入
 */
-(void) willDisplayAd:(BaiduMobAdView*) adview {
    adview.hidden = NO;
    [self adBannerSuccessWithInfo:@{KEY_BANNEROBJECT:object_validate(adview, KEY_BANNERNULL)}];
}

//展现，
-(void) didAdImpressed {
    [self adBannerDidReceiveBannerView:@{KEY_BANNEROBJECT:object_validate(sBaiduAdview, KEY_BANNERNULL)}];
}
-(void) didAdClicked{
    [self adBannerClicked:@{KEY_BANNEROBJECT:object_validate(sBaiduAdview, KEY_BANNERNULL)}];
    [self adBannerSuspend:@{KEY_BANNEROBJECT:object_validate(sBaiduAdview, KEY_BANNERNULL)}];
}

-(void) didDismissLandingPage
{
    [self adBannerResumed:@{KEY_BANNEROBJECT:object_validate(sBaiduAdview, KEY_BANNERNULL)}];
}

/**
 *  广告载入失败
 */
-(void) failedDisplayAd:(BaiduMobFailReason) reason {
    
    if ([sBaiduAdview superview] != NULL) {
        [sBaiduAdview removeFromSuperview];
    }
    
    [self adBannerFailWithError:MMUE_PFAdFailed];
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [self stopBeingDelegate];
    [super loadAdTimeOut:theTimer];
}



@end