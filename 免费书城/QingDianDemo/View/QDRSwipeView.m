//
//  QDRSwipeView.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSwipeView.h"

@implementation QDRSwipeView

- (UILabel *)swipeLabel{
    if (!_swipeLabel) {
        _swipeLabel = [UILabel new];
        _swipeLabel.font = [UIFont fontWithName:@"iconfont" size:30];
        _swipeLabel.textAlignment = UITextAlignmentCenter;
        _swipeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_swipeLabel];
        [_swipeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _swipeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
        
        [self swipeLabel];
        
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
