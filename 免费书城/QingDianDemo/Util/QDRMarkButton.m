//
//  QDRMarkButton.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/12.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRMarkButton.h"

@implementation QDRMarkButton

- (void)upMark{
    self.frame = CGRectMake(0, 0, kWindowW, kWindowH);
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.2;
    }];
}

- (void)downMark{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    }];
    self.frame = CGRectMake(0, 0, kWindowW, 0);
}


- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, kWindowH, kWindowW, 0)];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
