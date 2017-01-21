//
//  MMUFeeds.h
//  MMUSDK
//
//  Created by liuyu on 9/11/13.
//  Updated by liufuyin on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>


@class CLLocation;
@class MMUFeedsItem;

@protocol MMUFeedsDelegate;
@protocol MMUBrowserDelegate;

@interface MMUFeeds : NSObject

@property (nonatomic, copy) NSString *mTags; // 设置当前用户的标签信息
@property (nonatomic, copy) NSString *mSize; // 设置推广位的实际大小（in point）：推广位宽度x推广位高度，如 320x100
@property (nonatomic) NSInteger mAdcnt; //  设置期望返回的创意数

@property (nonatomic, readonly) BOOL mReadyToShown;      //shows whether data ready to show
@property (nonatomic) UIEdgeInsets mContentInsetForPromoterCell; //default UIEdgeInsetsZero, additional area around content

@property (nonatomic, weak) id<MMUFeedsDelegate> delegate; //delegate for datamanager
@property (nonatomic, weak) id<MMUBrowserDelegate>  browserDelegate;
 
- (NSArray*)getFeedsItems;

/**
 
 This method return a MMUFeeds object
 
 @param  slotId unique id for the releated promotion
 @param  controller view controller releated to the view that the promoter to be shown,whicth should not be nil.
 
 @return a MMUFeeds object
 
 */

- (instancetype)initWithSlotId:(NSString *)slotId
                viewController:(UIViewController *)controller;
/**
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/**
 
 This method set current location
 
 @param  location current location
 
 */

- (void)setLocation:(CLLocation *)location;

@end

@protocol MMUFeedsDelegate <NSObject>

@optional

- (void)feeds:(MMUFeeds *)feeds didLoadDataFinished:(NSInteger)promotersAmount; //called when promoter list loaded
- (void)feeds:(MMUFeeds *)feeds didLoadDataFailedWithError:(NSError *)error; //called when promoter list loaded failed for some reason
- (void)feeds:(MMUFeeds *)feeds didClickedPromoterAtIndex:(NSInteger)promoterIndex; //called when table cell clicked

- (void)feeds:(MMUFeeds *)feeds didUpdatedToPromoters:(NSInteger)newPromotersAmount;

@end
