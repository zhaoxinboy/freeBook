//
//  MMUDataInterfaceAdapter.h
//  MMUSDK
//
//  Created by liufuyin on 16/2/20.
//  Created by liufuyin on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>
#import "MMUAdNetworkType.h"
#import "MMUAdNetworkAdapter.h"
#import "MMUNativePromoterManager.h"
#import "MMUBrowserDelegate.h"
#import "MMUErrorType.h"

#define FeedTimerOut 8
#define KEY_ADDI_OBJECT      @"adDIObject"
#define KEY_ADDI_ADAPTER     @"adDIAdapter"
#define KEY_ADDI_NULL       @""


@class MMUDataInterfaceAdapter;
@class MMUMamaResponse;
@class MMUMamaPromoter;
@class MMUDIRationController;
@interface MMUDataInterfaceAdapter : MMUAdNetworkAdapter
// 保存每个平台数据
@property (nonatomic, retain) NSDictionary * appKeys;
@property (nonatomic, weak) id<MMUNativePromoterManagerDelegate> mPDelegate;
@property (nonatomic, weak) id<MMUBrowserDelegate> browserDelegate;

- (id)initWithRationController:(MMUDIRationController *)rationController
                     netConfig:(NSDictionary*)config
        nativePromoterDelegate:(id<MMUNativePromoterManagerDelegate>)pDelegate
               browserDelegate:(id<MMUBrowserDelegate>)browserDelegate
                  adLayoutType:(MMULayoutType)layoutType;

/**
 获取平台信息
 @param type 平台类型
 @param name 平台名字
 @param addInfo 附加信息
 @return 有效性
 */
- (NSDictionary*)platformInfoWithType:(MMUAdNetworkType)type
                                 name:(NSString*)pName
                              addInfo:(id)pInfo;

/**
 广告是否有效
 @return 有效性
 */
- (BOOL)isAdValid;

- (UIView*)getRenderView;

//展示广告
- (void)adDidPresentWithPromoters:(NSArray<MMUMamaPromoter *> *)promoters fromResponse:(MMUMamaResponse *)response;
//点击广告
- (void)adDidClickWithPromoter:(MMUMamaPromoter*)promoter fromResponse:(MMUMamaResponse *)response;

//平台请求开始
- (void)adDidStartRequestWithInfo:(NSDictionary *)info;

//平台返回成功
- (void)adDidSuccess:(MMUMamaResponse *)response;

//平台返回失败
- (void)adDidFailed:(MMUErrorType)errorType;


@end


