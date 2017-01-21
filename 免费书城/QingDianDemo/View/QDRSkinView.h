//
//  QDRSkinView.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/9.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDRSkinViewModel.h"


@protocol skinUrlDelegate <NSObject>

- (void)skinUrlwithString:(NSString *)urlString;

@end

typedef void(^ChooseBlock) (NSString *chooseContent,NSIndexPath *indexPath);

@interface QDRSkinView : UIView

@property(nonatomic, strong) NSIndexPath *currentSelectIndex;
@property(nonatomic, copy) ChooseBlock block;

// delegate
@property (nonatomic, assign) id <skinUrlDelegate> delegate;

@property (nonatomic, strong) UIView *bottomView;                   // 底部视图

@property (nonatomic, strong) UIButton *closeBtn;            // 关闭按钮

@property (nonatomic, strong) UIButton *determineBtn;        //确定按钮

@property (nonatomic, assign) NSInteger kvoDetermine;           // kvo监听确定按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;        //皮肤数据源

@property (nonatomic, assign) NSInteger kvoUrl;                 // kvo监听点击的URL

@property (nonatomic, assign) NSInteger kvoSkin;                // kvo监听位置,用于取消遮罩按钮

@property (nonatomic, strong) QDRSkinViewModel *skinVM;         // 皮肤数据模型


// 显示
- (void)popSelf;

// 隐藏
- (void)dismissSelf;


@end
