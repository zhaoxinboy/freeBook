//
//  ViewController.m
//  QingDianDemo
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    //需要配置为对应的字体
    label.font = [UIFont fontWithName:@"iconfont" size:24];
    //配置上两个对应图标
    label.text = @"\U0000e696 \U0000e90a";
    //配置图标颜色
    [label setTextColor:[UIColor cyanColor]];
    
    [self.view addSubview:label];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
