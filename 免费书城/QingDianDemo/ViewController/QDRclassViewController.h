//
//  QDRclassViewController.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/14.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDRHomePageViewModel.h"

@interface QDRclassViewController : UIViewController

@property (nonatomic, strong) QDRHomePageViewModel *homeVM;  //主页模型

@property (nonatomic, assign) NSInteger numRow;   // 选择第几行

@end
