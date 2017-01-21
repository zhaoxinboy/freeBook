//
//  MMUAdapterInmobiSDK.m
//  MMUSDK
//
//  Created by GaoBin on 16/2/29.
//  update by liufuyin on 16/8/31.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUAdapterInmobiSDK.h"
#import "MMUSDKBannerNetworkRegistry.h"
#import "NSDictionary+MMUExtension.h"
#import "IMSdk.h"
#import "IMCommonConstants.h"
#import "MMUErrorType.h"

@implementation MMUAdapterInmobiSDK
+ (MMUAdNetworkType)networkType
{
    return MMUAdNetworkTypeInMobi;
}

+ (void)load
{
    [[MMUSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd
{
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    NSDictionary *config = [self.ration mmuDictionaryValueForKey:KEY_NETSET];
    
    NSString* sizeInfoStr = [(NSDictionary*)[self.ration objectForKey:KEY_AZSET] objectForKey:KEY_BANNER_SIZE];
    NSDictionary *sizeInfo = [self typeInfoWithDescription:sizeInfoStr];
    NSNumber *typeInfo = [sizeInfo objectForKey:KEY_BANNER_TYPE];
    MMUBannerType type = (typeInfo && [typeInfo isKindOfClass:[NSNumber class]])?(MMUBannerType)[typeInfo intValue]:MMUBannerUnknow;
    
    CGRect rect = CGRectZero;
    switch (type) {
        case MMUBannerNormal:
            rect = CGRectMake(0, 0, 320, 48);
            break;
        case MMUBannerRectangle:
            rect = CGRectMake(0, 0, 300, 250);
            break;
        case MMUBannerMedium:
            rect = CGRectMake(0, 0, 468, 60);
            break;
        case MMUBannerLarger:
            rect = CGRectMake(0, 0, 728, 90);
            break;
        case MMUBannerCustomSize:
        {
            CGFloat theWidth = [(NSNumber*)[sizeInfo objectForKey:KEY_BANNER_WIDTH] intValue];
            CGFloat theHeight = [(NSNumber*)[sizeInfo objectForKey:KEY_BANNER_HEIGHT] intValue];
            rect = CGRectMake(0,0,theWidth,theHeight);
            break;
        }
        default:
            [self adBannerFailWithError:MMUE_Banner_SizeInvalid];
            return;
            break;
    }
    
    [IMSdk setLogLevel:kIMSDKLogLevelNone];
    NSString *accountID = [config mmuStringValueForKey:@"ACCOUNT_ID"];
    NSString *placementID = [config mmuStringValueForKey:@"PLACEMENT_ID"];
    [IMSdk initWithAccountID:accountID];
    
    self.bannerView = [[IMBanner alloc] initWithFrame:rect placementId:[placementID longLongValue]];
    [self.bannerView shouldAutoRefresh:NO];
    self.bannerView.delegate = self;
    [self adBannerStartRequestWithInfo:@{KEY_BANNEROBJECT:object_validate(_bannerView, KEY_BANNERNULL)}];
    [self.bannerView load];
}

- (void)stopAd
{
    [self stopBeingDelegate];
    [super stopAd];
}

- (void)stopBeingDelegate
{
    self.bannerView.delegate = nil;
}

- (void)dealloc
{
    self.bannerView.delegate = nil;
}

- (BOOL)isSupportClickDelegate
{
    return YES;
}

#pragma mark InMobiAdDelegate methods
/**
 * Callback sent when an ad request loaded an ad. This is a good opportunity
 * to add this view to the hierarchy if it has not yet been added.
 * @param banner The IMBanner instance which finished loading the ad request.
 */
-(void)bannerDidFinishLoading:(IMBanner*)banner
{
    [self adBannerSuccessWithInfo:@{KEY_BANNEROBJECT:object_validate(_bannerView, KEY_BANNERNULL)}];
    [self adBannerDidReceiveBannerView:@{KEY_BANNEROBJECT:object_validate(_bannerView, KEY_BANNERNULL)}];
}

/**
 * Callback sent when an ad request failed. Normally this is because no network
 * connection was available or no ads were available (i.e. no fill).
 * @param banner The IMBanner instance that failed to load the ad request.
 * @param error The error that occurred during loading.
 */
-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error
{
    banner.delegate = nil;
    [self adBannerFailWithError:MMUE_PFAdFailed];
}
/**
 * Called when the banner is tapped or interacted with by the user
 * Optional data is available to publishers to act on when using
 * monetization platform to render promotional ads.
 * @param banner The IMBanner instance that presents the screen.
 * @param dictionary The NSDictionary containing the parameters as passed by the creative
 */
-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params
{
    [self adBannerClicked:@{}];
}

/**
 * Callback sent just before when the banner is presenting a full screen view
 * to the user. Use this opportunity to stop animations and save the state of
 * your application in case the user leaves while the full screen view is on
 * screen (e.g. to visit the App Store from a link on the full screen view).
 * @param banner The IMBanner instance that presents the screen.
 */
-(void)bannerWillPresentScreen:(IMBanner*)banner
{
}

-(void)bannerDidPresentScreen:(IMBanner*)banner
{
    
}
/**
 * Callback sent just before dismissing the full screen view.
 * @param banner The IMBanner instance that dismisses the screen.
 */
-(void)bannerWillDismissScreen:(IMBanner*)banner
{
}
/**
 * Callback sent just after dismissing the full screen view.
 * Use this opportunity to restart anything you may have stopped as part of
 * bannerWillPresentScreen: callback.
 * @param banner The IMBanner instance that dismissed the screen.
 */
-(void)bannerDidDismissScreen:(IMBanner*)banner
{
}
/**
 * Callback sent just before the application goes into the background because
 * the user clicked on a link in the ad that will launch another application
 * (such as the App Store). The normal UIApplicationDelegate methods like
 * applicationDidEnterBackground: will immediately be called after this.
 * @param banner The IMBanner instance that is launching another application.
 */
-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner
{
}

-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards
{
    if([self.delegate respondsToSelector:@selector(banner:rewardActionCompletedWithRewards:)])
    {
        [self.delegate performSelector:@selector(banner:rewardActionCompletedWithRewards:)
                            withObject:banner
                            withObject:rewards];
    }
}


- (void)loadAdTimeOut:(NSTimer*)theTimer
{
    self.bannerView.delegate = nil;
    [super loadAdTimeOut: theTimer];
}

@end
