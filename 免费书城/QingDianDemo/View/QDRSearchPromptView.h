//
//  QDRSearchPromptView.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/3.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectIndexPathDelegate <NSObject>

- (void)selectIndexPathRow:(NSInteger )index;

@end

@interface QDRSearchPromptView : UIView

// delegate
@property (nonatomic, assign) id <selectIndexPathDelegate> _Nonnull delegate;

@property (nonatomic, strong) UIButton *_Nonnull closeBtn;

@property (nonatomic, strong) NSMutableArray *_Nonnull dataArr;

@property (nonatomic, strong) UITableView *_Nonnull tableView;

@property (nonatomic, assign) NSInteger KVOTableView;       //kvo控制tableview表头高度

@property (nonatomic, assign) NSInteger KVOAddApp;          //kvo控制添加APP刷新页面

- (void)popView;

- (void)dismiss;

@end
