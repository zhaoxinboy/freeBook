//
//  MMUHeadlineView.h
//  MMUSDK
//
//  Created by liuyu on 16/1/24.
//  Updated by liufuyin on 16/8/31.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@class CLLocation;
@protocol MMUHeadlineViewDelegate;
@protocol MMUBrowserDelegate;

@interface MMUHeadlineView : UIView

@property (nonatomic, copy) NSString *mTags;      //tags for the current user, default is @""
@property (nonatomic, weak) id<MMUHeadlineViewDelegate> delegate;
@property (nonatomic, weak) id<MMUBrowserDelegate> browserDelegate;

/**
 
 This method return a MMUHeadlineView object
 
 @param  frame frame for the headView view
 @param  slotId
 @param  controller view controller releated to the view that the headView view added into,whicth should not be nil.
 
 @return a MMUHeadlineView object
 */

- (instancetype)initWithFrame:(CGRect)frame
                       slotId:(NSString *)slotId
               viewController:(UIViewController *)controller;

/**
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/**
 
 This method reset the default auto switching between promoters
 
 */

- (void)reScheduleAutoSwitching;

/**
 
 This method set current location
 
 @param  location current location
 
 */

- (void)setLocation:(CLLocation *)location;

@end

@protocol MMUHeadlineViewDelegate <NSObject>

@required

- (void)headlineView:(MMUHeadlineView *)view didLoadDataFinished:(NSInteger)promotersAmount;
- (void)headlineView:(MMUHeadlineView *)view didLoadDataFailedWithError:(NSError *)error;
- (void)headlineView:(MMUHeadlineView *)view didClickedPromoterAtIndex:(NSInteger)index;

@end
