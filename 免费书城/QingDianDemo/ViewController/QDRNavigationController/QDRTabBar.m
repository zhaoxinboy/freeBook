//
//  QDRTabBar.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/7.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRTabBar.h"

@interface QDRTabBar ()

@property (nonatomic, strong) NSArray *datalist;

@property (nonatomic, strong) UIButton *lastItem;

@property (nonatomic, strong) UIImageView *tabBgView;

@property (nonatomic, strong) UIButton *bookmarksBtn;


@end

@implementation QDRTabBar{
    UILabel *firstLabel;
    UILabel *secondLabel;
}

- (NSArray *)datalist {
    if (!_datalist) {
        _datalist = @[@"tab_page_nor",@"icon_me_nor"];
    }
    return _datalist;
}

- (UIButton *)bookmarksBtn {
    if (!_bookmarksBtn) {
        _bookmarksBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bookmarksBtn setImage:[UIImage imageNamed:@"tab_label_nor"] forState:UIControlStateNormal];
        [_bookmarksBtn setImage:[UIImage imageNamed:@"tab_label_press"] forState:UIControlStateHighlighted];
        [_bookmarksBtn sizeToFit];
        [_bookmarksBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        _bookmarksBtn.tag = QDRItemTypeLaunch;
    }
    return _bookmarksBtn;
}

- (UIImageView *)tabBgView {
    
    if (!_tabBgView) {
        _tabBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    return _tabBgView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        firstLabel = [UILabel new];
        firstLabel.font = [UIFont systemFontOfSize:8];
        secondLabel = [UILabel new];
        secondLabel.font = [UIFont systemFontOfSize:8];
        
        //装载背景
        [self addSubview:self.tabBgView];
        
        //装载item
        for (int i = 0; i < self.datalist.count; i++) {
            
            UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
            
            item.adjustsImageWhenHighlighted = NO;
            
            [item setImage:[UIImage imageNamed:self.datalist[i]] forState:UIControlStateNormal];
            
            [item setImage:[UIImage imageNamed:[self.datalist[i] stringByReplacingOccurrencesOfString:@"nor" withString:@"press"]] forState:UIControlStateSelected];
            
            if (i == 0) {
                firstLabel.textColor = [UIColor grayColor];
                firstLabel.text = @"首页";
                [item addSubview:firstLabel];
                [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.centerX.mas_equalTo(0);
                }];
            }else{
                secondLabel.textColor = [UIColor grayColor];
                secondLabel.text = @"我的";
                [item addSubview:secondLabel];
                [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.centerX.mas_equalTo(0);
                }];
            }
            
            if (i == 0) {
                item.selected = YES;
                self.lastItem = item;
            }
            
            item.tag = QDRItemTypeLive + i;
            
            [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:item];
            
        }
        
        //装载相机
        [self addSubview:self.bookmarksBtn];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = kWindowW / self.datalist.count;
    
    for (UIView * btn in self.subviews) {
        
        if (btn.tag >= QDRItemTypeLive) {
            
            btn.frame = CGRectMake((btn.tag - QDRItemTypeLive) * width, 0, width, self.frame.size.height);
        }
    }
    
    self.tabBgView.frame = self.frame;
    self.bookmarksBtn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    self.bookmarksBtn.bounds = CGRectMake(0, 0, 50, 50);
    
    
}

- (void)clickItem:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(tabbar:clickIndex:)]) {
        [self.delegate tabbar:self clickIndex:button.tag];
    }
    
    if (self.block) {
        self.block(self,button.tag);
    }
    
    if (button.tag == QDRItemTypeLaunch) {
        return;
    }
    
    //将上一个按钮的选中状态置为NO
    self.lastItem.selected = NO;
    
    //将正在点击的按钮状态置为YES
    button.selected = YES;
    
    //将当前按钮设置成上一个按钮
    self.lastItem = button;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            button.transform = CGAffineTransformIdentity;
        }];
    }];
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
