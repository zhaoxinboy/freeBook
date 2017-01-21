//
//  QDRTabBarViewController.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/7.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDRBookMarkView.h"
#import "QDRMarkButton.h"

@interface QDRTabBarViewController : UITabBarController

@property (nonatomic, strong) QDRBookMarkView *bookView;  // 书签

@property (nonatomic, strong) QDRMarkButton *markBtn;  // 书签遮罩

@property (nonatomic, assign) NSInteger oneKVO;

@property (nonatomic, assign) NSInteger twoKVO;

@end
