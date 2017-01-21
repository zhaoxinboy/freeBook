//
//  MMUBannerAdNetworkAdapter.h
//  MMUSDK
//
//  Created by hale on 15/8/3.
//  Updated by liufuyin on 16/4/25.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com


#import <Foundation/Foundation.h>


#ifndef AdapterTimeOut2
#define AdapterTimeOut2 2
#endif

#ifndef AdapterTimeOut5
#define AdapterTimeOut5 5
#endif

#ifndef AdapterTimeOut15
#define AdapterTimeOut15 15
#endif

#ifndef AdapterTimeOut30
#define AdapterTimeOut30 30
#endif

#define ADAPTER_ADDTION_INFO @"adapterAddtioninfo"

typedef enum {
    ST_MMUAapterNULL = 1,
    ST_MMUAapterLoading = 2,
    ST_MMUAapterReady = 3,
    ST_MMUAapterStop = 4,
    ST_MMUAapterFinish = 5
} MMUAdapterState;



@class MMURationController;
@interface MMUAdNetworkAdapter : NSObject

@property (nonatomic,strong) NSDictionary *ration;

- (void)getAd;
- (MMUAdapterState)getAdapterState;
- (void)stopAd;
- (void)stopBeingDelegate;
- (void)stopTimer;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
- (void)startTimeoutTimerWithInterval:(NSTimeInterval)time;

@end
