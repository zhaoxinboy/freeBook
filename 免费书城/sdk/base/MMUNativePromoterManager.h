//
//  MMUNativePromoterManager.h
//  MMUSDK
//
//  Created by liuyu on 1/24/16.
//  Updated by liufuyin 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MMUMamaPromoter;
@class MMUMamaResponse;
@protocol MMUBrowserDelegate;
@protocol MMUNativePromoterManagerDelegate;

typedef NS_ENUM(NSInteger, MMULayoutType) {
    MMULayoutTypeSplash       = 9,   // 开屏
    MMULayoutTypeFeeds        = 12,  // 信息流
    MMULayoutTypeHeadlineView = 43,  // 焦点图
};

@interface MMUNativePromoterManager : NSObject

@property (nonatomic, copy) NSString *mSize; // 用以渲染创意数据的容器的实际大小（in point）：容器宽度x推广位高度，如 320x100
@property (nonatomic, copy) NSString *mTags; // 当前用户的标签信息
@property (nonatomic, weak) UIView *mRenderView; // 用以渲染创意数据的容器
@property (nonatomic, readonly, copy) NSString *mSlotId; // 推广位的ID
@property (nonatomic, copy) NSDictionary *mAddParam; // 附加参数
@property (nonatomic, weak) id<MMUNativePromoterManagerDelegate> delegate;
@property (nonatomic, weak) id<MMUBrowserDelegate> browserDelegate;
@property (nonatomic) NSInteger mAdcnt; // 设置期望返回的创意数

/**
 
 创建管理创意数据的实例
 
 @param  slotId 推广位的ID
 @param  layoutType 推广位对应的类型
 
 @return MMUNativePromoterManager 实例
 */

- (instancetype)initWithSlotId:(NSString *)slotId
                    layoutType:(MMULayoutType)layoutType;

- (void)requestPromoterDataInBackground;

#pragma mark - Action

/**
 
 发送创意展现的report
 
 @param promoters promoter list
 @param response
 
 */

- (void)sendImpressionReportForPromoters:(NSArray<MMUMamaPromoter *> *)promoters
                            fromResponse:(MMUMamaResponse *)response;

/**
 
 处理创意被点击事件，默认会自动完成点击事件上报及点击后的跳转处理，特例：
 当下发的创意属于 “动态模板” 时（0 == response.templateType），本方法只完成点击事件上报，点击的处理需要您自行完成
 
 @param promoter 被点击的创意
 @param response
 
 */

- (void)didClickedPromoter:(MMUMamaPromoter *)promoter
              fromResponse:(MMUMamaResponse *)response;

/**
 自定义事件上报
 */
- (void)sendCustomeEvent:(MMUMamaPromoter*)promoter id:(NSString*)eventID data:(NSString*)eventData;

@end

@protocol MMUNativePromoterManagerDelegate <NSObject>

@required

/**
 设置view controller 返回值不能为nil;
 */

- (UIViewController *)viewControllerForPresentingModalView;

@optional

- (void)promoterManager:(MMUNativePromoterManager *)manager didLoadDataFinishedWithPromoters:(MMUMamaResponse *)promoters;
- (void)promoterManager:(MMUNativePromoterManager *)manager didUpdateToPromoters:(MMUMamaResponse *)newPromoters fromPromoters:(MMUMamaResponse *)oldPromoters;
- (void)promoterManager:(MMUNativePromoterManager *)manager didLoadDataFailedWithError:(NSError *)error;

@end
