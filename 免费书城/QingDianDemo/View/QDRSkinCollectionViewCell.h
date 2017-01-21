//
//  QDRSkinCollectionViewCell.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/9.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDRSkinCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *determineImageView;

@property (nonatomic, assign) BOOL isSelected;
-(void)UpdateCellWithState:(BOOL)select;

@end
