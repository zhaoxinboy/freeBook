//
//  QDRSearchTableViewCell.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/23.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDRSearchTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageView;         //头像

@property (nonatomic, strong) UILabel *titleLabel;                  //名称

@property (nonatomic, strong) UILabel *addressLabel;                //地址

@property (nonatomic, strong) UIButton *addBtn;                     //加号按钮用在首页的时候再添加

@end
