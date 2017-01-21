//
//  MMUInMobiNativeAdapter.m
//  MMUSDK
//
//  Created by GaoBin on 16/2/29.
//  update by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//


#import "MMUInMobiNativeAdapter.h"
#import "IMNative.h"
#import "IMSdk.h"
#import "MMUFeedsSDKAdapterRegistry.h"
#import "NSDictionary+MMUExtension.h"
#import "MMUMamaResponse.h"

@implementation MMUInMobiNativeAdapter

+ (MMUAdNetworkType)networkType
{
    return MMUAdNetworkTypeInMobi;
}

+ (void)load
{
    [[MMUFeedsSDKAdapterRegistry sharedRegistry] registerClass:self];
}

- (void)getAd
{
    [IMSdk setLogLevel:kIMSDKLogLevelNone];
    NSDictionary *config = [self.ration mmuDictionaryValueForKey:@"netset"];
    self.keyMap = [self dictionaryFromJsonString:[config mmuStringValueForKey:@"attr"]];
    NSString *accountID = [config mmuStringValueForKey:@"ACCOUNT_ID"];
    NSString *placementID = [config mmuStringValueForKey:@"PLACEMENT_ID"];
    [IMSdk initWithAccountID:accountID];
    
    self.nativeAd = [[IMNative alloc] initWithPlacementId:[placementID longLongValue] delegate:self];
    [self adDidStartRequestWithInfo:@{KEY_ADDI_ADAPTER:self}];
    [self.nativeAd load];
}

-(void)nativeDidFinishLoading:(IMNative*)native
{
    NSString *adContent = native.adContent;
    NSData *adDatas = [adContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:adDatas
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
    if (![dictionary isKindOfClass:[NSDictionary class]] || [dictionary count] == 0) {
        [self adDidFailed:MMUE_DI_DataError];
        return;
    }
    
    NSMutableDictionary *mamaDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *mater = [NSMutableDictionary dictionary];
    NSString *titleKey = object_validate([self.keyMap mmuStringValueForKey:@"title"], @"");
    NSString *iconKey = object_validate([self.keyMap mmuStringValueForKey:@"icon"], @"");
    NSString *descKey = object_validate([self.keyMap mmuStringValueForKey:@"description"], @"");
    NSString *imageKey = object_validate([self.keyMap mmuStringValueForKey:@"screenshots"], @"");
    NSString *ratingKey = object_validate([self.keyMap mmuStringValueForKey:@"rating"], @"");
    NSString *landingURLKey = object_validate([self.keyMap mmuStringValueForKey:@"url"], @"");

    
    NSString *title = object_validate([dictionary mmuStringValueForKey:titleKey], @"");
    NSString *icon = object_validate([[dictionary mmuDictionaryValueForKey:iconKey] mmuStringValueForKey:@"url"], @"");
    NSNumber *iconWidth = object_validate([[dictionary mmuDictionaryValueForKey:iconKey] mmuNumberValueForKey:@"width"], nil);
    NSNumber *iconHeight = object_validate([[dictionary mmuDictionaryValueForKey:iconKey] mmuNumberValueForKey:@"height"], nil);
    NSString *descriptioin = object_validate([dictionary mmuStringValueForKey:descKey], @"");
    NSString *image = object_validate([[dictionary mmuDictionaryValueForKey:imageKey] mmuStringValueForKey:@"url"], @"");
    NSNumber *imageWidth = object_validate([[dictionary mmuDictionaryValueForKey:imageKey] mmuNumberValueForKey:@"width"], nil);
    NSNumber *imageHeight = object_validate([[dictionary mmuDictionaryValueForKey:imageKey] mmuNumberValueForKey:@"height"], nil);
    NSString *rating = object_validate([dictionary mmuStringValueForKey:@"rating"], @"");
    NSString *landingURL = object_validate([dictionary mmuStringValueForKey:landingURLKey], @"");
    
    NSNumber *templateNumber = [[self.ration mmuDictionaryValueForKey:@"netset"] mmuNumberValueForKey:@"rtid"];
    NSInteger template= -1;
    if (templateNumber != nil) {
        template = [templateNumber integerValue];
    }
    NSLog(@"%@,%@,%@,%@,%@,%@,%@",ratingKey,iconWidth,iconHeight,imageWidth,imageHeight,rating, landingURL);
    BOOL templateValid = YES;
    switch (template) {
        case 1:
            [mamaDictionary setObject:@1 forKey:@"rtid"];
            [mater setObject:image forKey:@"img_url"];
            [mater setObject:title forKey:@"title"];
            break;
        case 2:
            [mamaDictionary setObject:@2 forKey:@"rtid"];
            [mater setObject:icon forKey:@"img_url"];
            [mater setObject:title forKey:@"title"];
            [mater setObject:descriptioin forKey:@"sub_title"];
            break;
        default:
            break;
    }
    
    if (templateValid) {
        [mamaDictionary setObject:@[@{@"mater":mater}] forKey:@"creatives"];
        [self adDidSuccess:[[MMUMamaResponse alloc] initWithAttributes:mamaDictionary]];
    } else {
        [self adDidFailed:MMUE_DI_DataError];
    }
}

-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error
{
    [self stopAd];
    [self adDidFailed:MMUE_PFAdFailed];
}


//展示广告
-(void)adDidPresentWithPromoters:(NSArray<MMUMamaPromoter *> *)promoters fromResponse:(MMUMamaResponse *)response
{
    [super adDidPresentWithPromoters:promoters fromResponse:response];
    [IMNative bindNative:self.nativeAd toView:[self getRenderView]];
}

//点击广告
-(void)adDidClickWithPromoter:(MMUMamaPromoter*)promoter fromResponse:(MMUMamaResponse *)response
{
    [super adDidClickWithPromoter:promoter fromResponse:response];
    [self.nativeAd reportAdClickAndOpenLandingURL:nil];
}

-(void)nativeWillDismissScreen:(IMNative*)native;
{
    if ([self.mPDelegate respondsToSelector:@selector(nativeWillDismissScreen:)])
    {
        [self.mPDelegate performSelector:@selector(nativeWillDismissScreen:)
                              withObject:native];
    }
}

-(void)nativeWillPresentScreen:(IMNative*)native
{
    if ([self.mPDelegate respondsToSelector:@selector(nativeWillPresentScreen:)])
    {
        [self.mPDelegate performSelector:@selector(nativeWillPresentScreen:)
                              withObject:native];
    }
}

-(void)nativeDidPresentScreen:(IMNative*)native
{
    if ([self.mPDelegate respondsToSelector:@selector(nativeDidPresentScreen:)])
    {
        [self.mPDelegate performSelector:@selector(nativeDidPresentScreen:)
                              withObject:native];
    }
}

-(void)nativeDidDismissScreen:(IMNative*)native
{
    if ([self.mPDelegate respondsToSelector:@selector(nativeDidDismissScreen:)])
    {
        [self.mPDelegate performSelector:@selector(nativeDidDismissScreen:)
                              withObject:native];
    }
}

-(void)userWillLeaveApplicationFromNative:(IMNative*)native
{
    if ([self.mPDelegate respondsToSelector:@selector(nativeDidDismissScreen:)])
    {
        [self.mPDelegate performSelector:@selector(nativeDidDismissScreen:)
                              withObject:native];
    }
}

- (void)stopBeingDelegate
{
    self.nativeAd.delegate = nil;
}

- (void)dealloc
{
    self.nativeAd.delegate = nil;
}

#pragma mark utility method

- (NSDictionary *)dictionaryFromJsonString:(NSString *)string
{
    if (string == nil)
        return nil;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    return dict;
}

@end
