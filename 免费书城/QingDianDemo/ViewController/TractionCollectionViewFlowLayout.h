//
//  TractionCollectionViewFlowLayout.h
//  Contacts
//
//  Created by sg021 on 16/11/1.
//  Copyright © 2016年 sg021. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 扩展section的背景色
@protocol TractionCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section;
@end

@interface TractionCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat springFrequency;
@property (nonatomic, assign) CGFloat resistanceFactor;

@property (nonatomic ,assign) BOOL isRefresh;

@property (nonatomic ,copy) void (^offsetBlock)(CGFloat);

@end
