//
//  QDRNavigationController.m
//  QingDianDemo
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRNavigationController.h"

@interface QDRNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation QDRNavigationController

//设置navigation背景
+ (void)initialize {
    
    if (self == [QDRNavigationController class]) {
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
        bar.barTintColor = QDR_FIRST_COLOR;
    }
}

// 状态栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    // 设置按钮颜色为黑色
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    //实现全屏滑动返回
    id target = self.interactivePopGestureRecognizer.delegate;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
    [self.view addGestureRecognizer:pan];
    
    // 取消边缘滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    pan.delegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark ---- <UIGestureRecognizerDelegate>


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 判断下当前是不是在根控制器
    return self.childViewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
