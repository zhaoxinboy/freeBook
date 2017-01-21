//
//  QDRBannersView.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/23.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRBannersView.h"

@implementation QDRBannersView{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selfHeight = IS_IPAD ? 90 : 50;
        self.frame = CGRectMake(0, kWindowH - 40 - self.selfHeight, kWindowW, self.selfHeight);
    }
    return self;
}

- (void)upBannersView{
    self.frame = CGRectMake(0, kWindowH - 40 - self.selfHeight, kWindowW, self.selfHeight);
}

- (void)downBannersView{
    self.frame = CGRectMake(0, kWindowH - self.selfHeight, kWindowW, self.selfHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
