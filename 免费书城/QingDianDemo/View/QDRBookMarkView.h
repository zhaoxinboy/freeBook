//
//  QDRBookMarkView.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/10.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteUrlDelegate <NSObject>

- (void)deleteUrlwithString:(NSString *)urlString;

@end

@interface QDRBookMarkView : UIView

// delegate
@property (nonatomic, assign) id <deleteUrlDelegate> delegate;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray; //书签数据源

@property (nonatomic, assign) NSInteger kvoUrl;  // kvo监听点击的URL

@property (nonatomic, assign) NSInteger kvoClickUrl;  // kvo监听删除的URL


- (void)upBookView;

- (void)downBookView;

@end
