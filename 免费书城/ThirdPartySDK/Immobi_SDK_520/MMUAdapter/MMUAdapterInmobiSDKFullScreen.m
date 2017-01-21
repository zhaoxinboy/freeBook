//
//  MMUAdapterInmobiSDKFullScreen.m
//  MMUSDK
//
//  Created by GaoBin on 16/2/29.
//  update by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUAdapterInmobiSDKFullScreen.h"
#import "MMUSDKInterstitialNetworkRegistry.h"
#import "NSDictionary+MMUExtension.h"
#import "IMSdk.h"

@implementation MMUAdapterInmobiSDKFullScreen

+ (MMUAdNetworkType)networkType
{
    return MMUAdNetworkTypeInMobi;
}

+ (void)load
{
    [[MMUSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd
{
    canRemove = YES;
    
    [IMSdk setLogLevel:kIMSDKLogLevelNone];
    NSDictionary *config = [self.ration mmuDictionaryValueForKey:@"netset"];
    NSString *accountID = [config mmuStringValueForKey:@"ACCOUNT_ID"];
    NSString *placementID = [config mmuStringValueForKey:@"PLACEMENT_ID"];
    [IMSdk initWithAccountID:accountID];
    
    self.interstitialAd = [[IMInterstitial alloc] initWithPlacementId:[placementID longLongValue] delegate:self];
    
    [self adInterstitialStartRequestWithInfo:@{KEY_INTERSTITIAL_ADAPTER:object_validate(self, KEY_INTERSTITIAL_NULL)}];
    [self.interstitialAd load];
}

-(void)stopAd
{
    [self stopBeingDelegate];
    [super stopAd];
}

-(void)stopBeingDelegate
{
    if (canRemove) {
        self.interstitialAd.delegate = nil;
        self.interstitialAd = nil;
    }
}

-(void)dealloc
{
    if (self.interstitialAd && canRemove) {
        self.interstitialAd.delegate = nil;
        self.interstitialAd = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer
{
    [self stopBeingDelegate];
    [super loadAdTimeOut:theTimer];
}


- (void)presentInterstitial
{
    // 呈现插屏广告
    if (self.interstitialAd.isReady) {
        [self.interstitialAd showFromViewController:[self.delegate viewControllerForPresentingInterstitialModalView]];
    } else {
        NSLog(@"%s ad is not ready",__FUNCTION__);
        NSLog(@"inmobi插屏广告还没有准备好");
    }
}

#pragma mark - Inmobi delegate
/**
 * Sent when an interstitial ad request succeeded.
 * @param ad The IMInterstitial instance which finished loading.
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial
{
    NSLog(@"inmobi插屏广告数据获取成功");
    
    [self adInterstitiaDidReceiveWithInfo:@{KEY_INTERST_OBJ:object_validate(_interstitialAd, KEY_INTERSTITIAL_NULL)}];
}

/**
 * Sent when an interstitial ad request failed
 * @param ad The IMInterstitial instance which failed to load.
 * @param error The IMError associated with the failure.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error
{
    NSLog(@"inMobi error-->%@",error);
    NSLog(@"inmobi插屏广告数据获取失败");
    
    [self stopBeingDelegate];
    [self adInterstitialFailWithError:MMUE_PFAdFailed];
}

/**
 * Sent just before presenting an interstitial.  After this method finishes the
 * interstitial will animate onto the screen.  Use this opportunity to stop
 * animations and save the state of your application in case the user leaves
 * while the interstitial is on screen (e.g. to visit the App Store from a link
 * on the interstitial).
 * @param ad The IMInterstitial instance which will present the screen.
 */
-(void)interstitialWillPresent:(IMInterstitial*)interstitial
{
    if ([self getAdapterState] >= ST_MMUAapterStop)
        return;
    
    canRemove = NO;
    NSLog(@"inmobi插屏广告将要展示");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if([self.delegate respondsToSelector:@selector(MMUEXT_InterstitialAdWillPresent)])
    {
        [self.delegate performSelector:@selector(MMUEXT_InterstitialAdWillPresent)];
    }
    
#pragma clang diagnostic pop
}

-(void)interstitialDidPresent:(IMInterstitial *)interstitial
{
    NSLog(@"inmobi插屏广告已经展示");
    [self adInterstitiaDidPresentWithInfo:@{}];
}

/**
 * Sent before the interstitial is to be animated off the screen.
 * @param ad The IMInterstitial instance which will dismiss the screen.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"inmobi插屏广告将要消失");
}

/**
 * Sent just after dismissing an interstitial and it has animated off the screen.
 * @param ad The IMInterstitial instance which was responsible for dismissing the screen.
 */
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial
{
    if ([self getAdapterState] >= ST_MMUAapterStop)
        return;
    
    canRemove = YES;
    NSLog(@"inmobi插屏广告已经消失");
    [self adInterstitialDismissScreenWithInfo:@{KEY_INTERST_OBJ:object_validate(interstitial, KEY_INTERSTITIAL_NULL)}];
}

/**
 * Callback sent just before the application goes into the background because
 * the user clicked on a link in the ad that will launch another application
 * (such as the App Store). The normal UIApplicationDelegate methods like
 * applicationDidEnterBackground: will immediately be called after this.
 * @param ad The IMInterstitial instance that is launching another application.
 */
-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial
{
    NSLog(@"inmobi插屏广告将要离开应用");
    NSLog(@"%s",__FUNCTION__);
}
/**
 * Called when the interstitial is tapped or interacted with by the user
 * Optional data is available to publishers to act on when using
 * monetization platform to render promotional ads.
 * @param ad The IMInterstitial instance which was responsible for this action.
 * @param dictionary The NSDictionary object which was passed from the ad.
 */
-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params
{
    NSLog(@"inmobi插屏广告被点击");
    NSLog(@"%s %@",__FUNCTION__,params);
    [self adInterstitialClickedWithInfo:@{}];
}
/**
 * Called when the interstitial failed to display.
 * This should normally occur if the state != kIMInterstitialStateReady.
 * @param ad The IMInterstitial instance responsible for this error.
 * @param error The IMError associated with this failure.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error
{
    NSLog(@"inmobi插屏广告展示失败");
    NSLog(@"%s",__FUNCTION__);
    [self adInterstitialFailWithError:MMUE_Interstitial_DisplayFailed];
}

-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards { }

@end
