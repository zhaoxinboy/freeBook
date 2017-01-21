//
//  FMDBManager.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/15.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QDRBookViewModel;

@interface FMDBManager : NSObject

@property (nonatomic, strong) QDRBookViewModel *model;

+ (instancetype)sharedFMDBManager;


#pragma mark - Person
/**
 *  添加BookView
 *
 */
- (BOOL)addBookView:(QDRBookViewModel *)model;
/**
 *  删除BookView
 *
 */
- (BOOL)deleteBookView:(QDRBookViewModel *)model;
/**
 *  更新BookView
 *
 */
- (BOOL)updateBookView:(QDRBookViewModel *)model;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllBookView;

@end
