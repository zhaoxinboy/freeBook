//
//  QDRUserFeedbackTableView.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"

@interface QDRUserFeedbackTableView : UITableView

@property (nonatomic, strong) BRPlaceholderTextView *adviceTextView;  // 输入框

@property (nonatomic, strong) UILabel *stirngLenghLabel;            //文字个数

@property (nonatomic, assign) NSInteger KVOsubNum;                  // kvo监听提交按钮

@property (nonatomic, strong) UILabel *promptLabel;                 // 底部提示语


@end
