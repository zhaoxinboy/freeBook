//
//  MMUAdapterGoogleAdMobAds.m
//  MMUSDK
//
//  Created by liufuyin on 16/8/31.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUAdapterGoogleAdMobAds.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "MMUSDKBannerNetworkRegistry.h"
#import "MMUBanners.h"
#import "NSDictionary+MMUExtension.h"
#import "MMUErrorType.h"

@interface MMUAdapterGoogleAdMobAds()
{
    GADBannerView *_view;
}
@end

@implementation MMUAdapterGoogleAdMobAds

+ (MMUAdNetworkType)networkType {
    
    return MMUAdNetworkTypeAdMob;
}

+ (void)load {
    
    [[MMUSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
	GADRequest *request = [GADRequest request];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSString *gender = [self.delegate respondsToSelector:@selector(gender)]?(NSString*)[self.delegate performSelector:@selector(gender)]:nil;
    if ([gender isEqualToString:@"m"]) {
        request.gender = kGADGenderMale;
    }else if([gender isEqualToString:@"f"]){
        request.gender = kGADGenderFemale;
    }else{
        request.gender = kGADGenderUnknown;
    }
    
    NSDate *date = [self.delegate respondsToSelector:@selector(dateOfBirth)]?(NSDate*)[self.delegate performSelector:@selector(dateOfBirth)]:nil;
    if (date) request.birthday = date;
    
    NSArray *keywords = [self.delegate respondsToSelector:@selector(keywords)]?(NSArray*)[self.delegate performSelector:@selector(keywords)]:nil;
    if (keywords) request.keywords = [NSMutableArray arrayWithArray:(NSArray *)keywords];
    
#pragma clang diagnostic pop
    
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    if (testMode) {
        request.testDevices = [NSArray arrayWithObjects:@"Simulator",nil];
    }
	
    NSString* sizeInfoStr = [(NSDictionary*)[self.ration objectForKey:KEY_AZSET] objectForKey:KEY_BANNER_SIZE];
    NSDictionary *sizeInfo = [self typeInfoWithDescription:sizeInfoStr];
    NSNumber *typeInfo = [sizeInfo objectForKey:KEY_BANNER_TYPE];
    MMUBannerType theType = (typeInfo && [typeInfo isKindOfClass:[NSNumber class]])?(MMUBannerType)[typeInfo intValue]:MMUBannerUnknow;
    
    GADAdSize size = kGADAdSizeBanner;
    switch (theType) {
        case MMUBannerNormal:
            size = kGADAdSizeBanner;
            break;
        case MMUBannerRectangle:
            size = kGADAdSizeMediumRectangle;
            break;
        case MMUBannerMedium:
            size = kGADAdSizeFullBanner;
            break;
        case MMUBannerLarger:
            size = kGADAdSizeLeaderboard;
            break;
        default:
        {
            [self adBannerFailWithError:MMUE_Banner_SizeInvalid];
            return;
        }
            break;
    }

	_view = [[GADBannerView alloc] initWithAdSize:size];
	_view.adUnitID = [[self.ration mmuDictionaryValueForKey:@"netset"] mmuStringValueForKey:@"ID"];
	_view.delegate = self;
	_view.rootViewController = [self.delegate bannerViewControllerForPresentingModalView];
    
    [self adBannerStartRequestWithInfo:@{KEY_BANNEROBJECT:object_validate(_view, KEY_BANNERNULL)}];
	[_view loadRequest:request];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer
{
    [self stopBeingDelegate];
    [super loadAdTimeOut:theTimer];
}

- (void)stopBeingDelegate
{
	GADBannerView *_adMobView = _view;
    if (_adMobView != nil)
    {
        [_adMobView performSelector:@selector(setDelegate:)
                         withObject:nil];
        [_adMobView performSelector:@selector(setRootViewController:)
                         withObject:nil];
    }
}

#pragma mark Ad Request Lifecycle Notifications
- (void)adViewDidReceiveAd:(GADBannerView *)adView {

    [self adBannerSuccessWithInfo:@{KEY_BANNEROBJECT:object_validate(adView, KEY_BANNERNULL)}];
    [self adBannerDidReceiveBannerView:@{KEY_BANNEROBJECT:object_validate(adView, KEY_BANNERNULL)}];
}
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    [self adBannerFailWithError:MMUE_PFAdFailed];
}

#pragma mark Click-Time Lifecycle Notifications
- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    if ([self getAdapterState] >= ST_MMUAapterStop) {
        return;
    }
    
    if ([self.browserDelegate respondsToSelector:@selector(browserWillLoad)]) {
        [self.browserDelegate browserWillLoad];
    }
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    if ([self getAdapterState] >= ST_MMUAapterStop) {
        return;
    }
    if ([self.browserDelegate respondsToSelector:@selector(browserWillDismiss)]) {
        [self.browserDelegate browserWillDismiss];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    if ([self getAdapterState] >= ST_MMUAapterStop) {
        return;
    }
    
    if ([self.browserDelegate respondsToSelector:@selector(MMUEXT_BrowserDidDismiss)])
    {
        [self.browserDelegate performSelector:@selector(MMUEXT_BrowserDidDismiss)];
    }
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    if ([self getAdapterState] >= ST_MMUAapterStop) {
        return;
    }
    
    if ([self.browserDelegate respondsToSelector:@selector(MMUEXT_AdViewWillLeaveApplication)])
    {
        [self.browserDelegate performSelector:@selector(MMUEXT_AdViewWillLeaveApplication)];
    }
}


#pragma clang diagnostic pop
@end