//
//  NSObject+Common.h
//  FDPublic
//
//  Created by jiyingxin on 15/6/19.
//  Copyright (c) 2015年 timShadow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

//显示失败提示
- (void)showErrorMsg:(NSObject *)msg;

//显示成功提示
- (void)showSuccessMsg:(NSObject *)msg;

//显示忙
- (void)showProgress;

//隐藏提示
- (void)hideProgress;

- (NSString *)promptStrWithStatus:(NSString *)status;   // 网络提示信息

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image;

// 字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

// 截图成为image
- (UIImage *)screenView:(UIView *)view;

// 限制图片大小在32K以内
- (NSData *)dataWithShareImage:(NSURL *)url;

// sd缓存计算
- (CGFloat)sdFolderSize;

// sd清理缓存
- (void)sdCleanCache;

// 百度字符串搜索
+ (NSString *)keywordWithBaiDuUrl:(NSString *)keyword;

// cookie获取
+ (NSString *)loadRequestWithUrlString:(NSString *)urlString;

@end
