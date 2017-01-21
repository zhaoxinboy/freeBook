//
//  QDRHistoryViewController.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "QDRHistoryModel.h"

@interface QDRHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) QDRHistoryArrModel *model;

// 网络请求
- (void)getNetWorking;

@end
