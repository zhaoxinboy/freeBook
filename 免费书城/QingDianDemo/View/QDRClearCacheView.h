//
//  QDRClearCacheView.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/16.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol removeDelegate <NSObject>

- (void)removeClearView;

@end

@interface QDRClearCacheView : UIButton

@property (nonatomic, assign) id <removeDelegate> delegate;

@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, strong) UILabel *clearCacheLabel;

@property (nonatomic, strong) UILabel *isClearLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *determineBtn;

- (instancetype)initWithTarget:(id)target;

- (void)openSelf;

- (void)closeSelf;

@end
