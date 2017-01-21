//
//  QDRHomePageViewModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"

@interface QDRHomePageViewModel : BaseViewModel


@property (nonatomic, strong) NSMutableArray *classArr;
// 分类信息
- (void)getAllCategoryApps:(NSString *)userID CompleteHandle:(CompletionHandle)completionHandle;
//@property (nonatomic, strong) QDRclassiModel *classModel;
@property (nonatomic, strong) QDRclassificationModel *classModel;
@property(nonatomic) NSInteger classRowNumber;
- (QDRclassiModel *)classModelForRow:(NSInteger)row;
- (NSString *)classTitleForRow:(NSInteger)row;

@property (nonatomic, strong) NSMutableArray *classDataArr;
@property (nonatomic, strong) QDRclassiModel *classDataModel;
@property(nonatomic) NSInteger classiDataRowNumber;
- (NSInteger)classNumForRow:(NSInteger)row;
- (NSMutableArray *)classArrNumForRow:(NSInteger)row;
- (QDRclassiDataModel *)classDataModelForRow:(NSInteger)row;
- (NSInteger)classClassDataArrNumForRow:(NSInteger)row;
- (NSString *)classiDataIscollectedForRow:(NSInteger)row;
- (NSString *)classiDataTitleForRow:(NSInteger)row;
- (NSURL *)classiDataimageURLForRow:(NSInteger)row;
- (NSURL *)classiDataaddressURLForRow:(NSInteger)row;
- (NSInteger)classiDataurlIDForRow:(NSInteger)row;
- (NSString *)classiDataSuperCodeForRow:(NSInteger)row;


// 地理位置
- (void)postAddLocationByUserid:(NSString *)userID itude:(NSString *)itude location:(NSString *)location CompleteHandle:(CompletionHandle)completionHandle;


// 主页相关
@property (nonatomic, strong) QDRHomeDataModel *HomeDataModel;
- (void)getDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle;


// 主页网址数据
@property (nonatomic, strong) QDRHomeAddressModel *homeAddressModel;
- (void)getAddressDataFromNetWithUserId:(NSInteger)userID CompleteHandle:(CompletionHandle)completionHandle;

@property(nonatomic) NSInteger rowNumber;
- (NSString *)titleForRow:(NSInteger)row;
- (NSURL *)imageURLForRow:(NSInteger)row;
- (NSURL *)addressURLForRow:(NSInteger)row;
- (NSInteger)urlIDForRow:(NSInteger)row;
- (NSString *)supercodeForRow:(NSInteger)row;

// 添加历史记录
- (void)postAddHistoryToUserFromNetWithUrlId:(NSInteger)urlID andUserID:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle;





@end
