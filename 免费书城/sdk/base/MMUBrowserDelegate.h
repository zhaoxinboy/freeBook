//
//  MMUSSPBrowserDelegate.h
//  MMUSDK
//
//  Created by hale on 15/7/30.
//  Updated by liufuyin on 16/4/25.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>

/**
 支持平台：妈妈、谷歌admob
 */

@protocol MMUBrowserDelegate <NSObject>
@optional
// 浏览器将要展示
- (void)browserWillLoad;

// 浏览器将要消失
- (void)browserWillDismiss;

@end
