//
//  QDRTabBar.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/7.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QDRItemType) {
    
    QDRItemTypeLaunch = 10,
    QDRItemTypeLive = 100,
    QDRItemTypeMe,
};


@class QDRTabBar;

typedef void(^TabBlock)(QDRTabBar * tabbar,QDRItemType idx);

@protocol QDRTabBarDelegate <NSObject>

- (void)tabbar:(QDRTabBar *)tabbar clickIndex:(QDRItemType)idx;

@end

@interface QDRTabBar : UIView

@property (nonatomic, weak) id<QDRTabBarDelegate> delegate;

@property (nonatomic, copy) TabBlock block;

@end
