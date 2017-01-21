//
//  MMUAdapterBaiduNative.m
//  MoGoPro
//
//  Created by liufuyin on 16/5/27.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUAdapterBaiduNative.h"
#import "MMUFeedsSDKAdapterRegistry.h"
#import "NSDictionary+MMUExtension.h"
#import "MMUMamaResponse.h"
#import "BaiduMobAdNative.h"
#import "BaiduMobAdNativeAdObject.h"
#import "BaiduMobAdNativeAdView.h"

#define BAIDUPID       @"AppID"
#define BAIDUPADPID    @"AdPlaceID"

@interface MMUAdapterBaiduNative()

@property(nonatomic)NSString *mAccType;
@property(nonatomic)NSDictionary *mAddParam;
@property(nonatomic,retain)BaiduMobAdNative *native;
@end

@implementation MMUAdapterBaiduNative

-(void)dealloc
{
    self.native.delegate = nil;
    self.native = nil;
}

+ (MMUAdNetworkType)networkType{
    return MMUAdNetworkTypeBaiduMobAd;
}

+ (void)load
{
    [[MMUFeedsSDKAdapterRegistry sharedRegistry] registerClass:self];
}

-(void)getAd
{
    NSDictionary *customReqPams  = object_validate([self.ration mmuDictionaryValueForKey:ADAPTER_ADDTION_INFO], @{});
    
    self.mAccType = object_validate([customReqPams mmuStringValueForKey:@"acct"], @"");
    self.mAddParam = object_validate([customReqPams mmuDictionaryValueForKey:@"addparam"], @{});
    if (!self.native) {
        self.native = [[BaiduMobAdNative alloc]init];
        self.native.delegate = (id<BaiduMobAdNativeAdDelegate>)self;
    }
    [self.native requestNativeAds];
    [self adDidStartRequestWithInfo:@{}];
}


#pragma mark BaiduMobAdNativeAdDelegate
- (NSString *)publisherId;
{
    NSDictionary* config = [self.ration mmuDictionaryValueForKey:@"netset"];
    NSString *publishId = [config mmuStringValueForKey:@"AppID"];
    return publishId;
}

-(NSString*)apId
{
    NSDictionary* config = [self.ration mmuDictionaryValueForKey:@"netset"];
    NSString* apId = [config mmuStringValueForKey:@"AdPlaceID"];
    return apId;
}

/**
 * 广告请求成功
 * @param 请求成功的BaiduMobAdNativeAdObject数组，如果只成功返回一条原生广告，数组大小为1
 */
- (void)nativeAdObjectsSuccessLoad:(NSArray*)nativeAds
{
    NSArray *creatives = @[];
    if (nativeAds && [nativeAds isKindOfClass:[NSArray class]])
    {
        creatives = [NSArray arrayWithArray:nativeAds];
    }
    NSDictionary *addInfo = [self platformInfoWithType:MMUAdNetworkTypeBaiduMobAd name:@"百度" addInfo:creatives];
    
    NSDictionary *mater = @{@"title":@""};
    MMUMamaResponse *response = [[MMUMamaResponse alloc] initWithAttributes:@{@"pInfo":addInfo,@"creatives":@[@{@"mater":mater}]}];
    [self adDidSuccess:response];
}
/**
 *  广告请求失败
 * @param 失败的BaiduMobAdNative
 * @param 失败的类型 BaiduMobFailReason
 */
- (void)nativeAdsFailLoad:(BaiduMobFailReason) reason
{
    [self adDidFailed:MMUE_DI_DataError];
}


/**
 *  广告详情页关闭
 */
-(void)didDismissLandingPage:(BaiduMobAdNativeAdView *)nativeAdView
{
    if ([self.browserDelegate respondsToSelector:@selector(browserWillDismiss)])
    {
        [self.browserDelegate performSelector:@selector(browserWillDismiss)];
    }
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
-(BOOL) enableLocation
{
    BOOL enable = [object_validate([self.mAddParam mmuNumberValueForKey:@"enableLocation"], @NO) boolValue];
    
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_enableLocation)])
    {
        enable = [(NSNumber*)[self.mPDelegate performSelector:@selector(MMUEXT_BD_enableLocation)] boolValue];
    }
    return enable;
}

/**
 * 模版高度，仅用于信息流模版广告
 */
-(NSNumber*)height
{
    NSNumber *height = object_validate([self.mAddParam mmuNumberValueForKey:@"height"],@270);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_height)])
    {
        height =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_height)] ;
    }
    return height;
}

/**
 * 模版宽度，仅用于信息流模版广告
 */
-(NSNumber*)width
{
    NSNumber *width = object_validate([self.mAddParam mmuNumberValueForKey:@"width"],@360);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_width)])
    {
        width =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_width)] ;
    }
    return width;
}


/**
 * 广告点击类型
 */
-(NSString*)actType DEPRECATED_ATTRIBUTE;
{
    NSString *actType = object_validate([self.mAddParam mmuStringValueForKey:@"actType"],nil);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_actType)])
    {
        actType =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_actType)] ;
    }
    return actType;
}
/**
 * 对于视频广告，展现一张视频预览图，点击可选择开始播放视频
 */
- (void)nativeAdVideoAreaClick:(BaiduMobAdNativeAdView*)nativeAdView
{
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_nativeAdVideoAreaClick:)])
    {
         [self.mPDelegate performSelector:@selector(MMUEXT_BD_nativeAdVideoAreaClick:)
                               withObject:nativeAdView] ;
    }
}

/**
 *  广告点击
 */
- (void)nativeAdClicked:(BaiduMobAdNativeAdView*)nativeAdView
{
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_nativeAdClicked:)])
    {
        [self.mPDelegate performSelector:@selector(MMUEXT_BD_nativeAdClicked:)
                              withObject:nativeAdView] ;
    }
}

///---------------------------------------------------------------------------------------
/// @name 人群属性板块
///---------------------------------------------------------------------------------------

/**
 *  关键词数组
 */
-(NSArray*) keywords
{
    NSArray *keywords = object_validate([self.mAddParam mmuArrayValueForKey:@"keywords"],nil);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_keywords)])
    {
        keywords =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_keywords)] ;
    }
    return keywords;
}

/**
 * 附加字段
 */
-(NSDictionary*) extraDic
{
    NSDictionary *extraDic = object_validate([self.mAddParam mmuDictionaryValueForKey:@"extraDic"],nil);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_extraDic)])
    {
        extraDic =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_extraDic)] ;
    }
    return extraDic;
}
/**
 *  用户性别
 */
-(BaiduMobAdUserGender) userGender
{
    NSNumber *userGender = object_validate([self.mAddParam mmuNumberValueForKey:@"userGender"],nil);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userGender)])
    {
        userGender =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userGender)] ;
    }
    return (BaiduMobAdUserGender)[userGender integerValue];
}

/**
 *  用户生日
 */
-(NSDate*) userBirthday
{
    NSDate *userBirthday = [self.mAddParam objectForKey:@"userBirthday"];
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userGender)])
    {
        userBirthday =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userGender)] ;
    }
    return userBirthday;
}

/**
 *  用户城市
 */
-(NSString*) userCity
{
    NSString *userCity = object_validate([self.mAddParam mmuStringValueForKey:@"userCity"],nil);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userCity)])
    {
        userCity =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userCity)] ;
    }
    return userCity;
}

/**
 *  用户邮编
 */
-(NSString*) userPostalCode
{
    NSString *userPostalCode = object_validate([self.mAddParam mmuStringValueForKey:@"userPostalCode"],nil);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userPostalCode)])
    {
        userPostalCode =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userPostalCode)] ;
    }
    return userPostalCode;
}



/**
 *  用户职业
 */
-(NSString*) userWork
{
    NSString *userWork = object_validate([self.mAddParam mmuStringValueForKey:@"userWork"],nil);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userWork)])
    {
        userWork =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userWork)] ;
    }
    return userWork;
}

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0代表小学，1代表初中，2代表中专/高中，3代表专科
 *  - 4代表本科，5代表硕士，6代表博士
 */
-(NSInteger) userEducation
{
    NSNumber *userEducation = object_validate([self.mAddParam mmuNumberValueForKey:@"userEducation"],@-1);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userEducation)])
    {
        userEducation =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userEducation)] ;
    }
    return [userEducation integerValue];
}


/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary
{
    NSNumber *userSalary =  object_validate([self.mAddParam mmuNumberValueForKey:@"userSalary"],@-1);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userSalary)])
    {
        userSalary =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userSalary)] ;
    }
    return [userSalary integerValue];
}


/**
 *  用户爱好
 */
-(NSArray*) userHobbies
{
    NSArray *userHobbies =  object_validate([self.mAddParam mmuArrayValueForKey:@"userHobbies"],@[]);
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userHobbies)])
    {
        userHobbies =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userHobbies)] ;
    }
    return userHobbies;
}

/**
 *  其他自定义字段,key以及value都为NSString
 */
-(NSDictionary*) userOtherAttributes
{
    NSDictionary *userOtherAttributes =  object_validate([self.mAddParam mmuDictionaryValueForKey:@"userOtherAttributes"],@{});
    if ([self.mPDelegate respondsToSelector:@selector(MMUEXT_BD_userOtherAttributes)])
    {
        userOtherAttributes =  [self.mPDelegate performSelector:@selector(MMUEXT_BD_userOtherAttributes)] ;
    }
    return userOtherAttributes;
}


#pragma clang diagnostic pop


@end
