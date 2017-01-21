//
//  MMUInMobiNativeAdapter.h
//  MMUSDK
//
//  Created by GaoBin on 16/2/29.
//  update by liufuyin on 16/3/8.
//  Copyright © 2016年 alimama. All rights reserved.
//

#import "MMUDataInterfaceAdapter.h"
#import "IMNative.h"

@interface MMUInMobiNativeAdapter : MMUDataInterfaceAdapter<IMNativeDelegate>

@property (nonatomic, strong) IMNative *nativeAd;
@property (nonatomic, strong) NSDictionary *keyMap;

@end
