//
//  QDRHistoryViewModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"
#import "QDRHistoryModel.h"

@interface QDRHistoryViewModel : BaseViewModel

@property (nonatomic, strong)QDRHistoryModel *historyModel;

- (void)getHistoryByUseridWithUserid:(NSString *)userid CompleteHandle:(CompletionHandle)completionHandle;



@property(nonatomic) NSInteger rowNumber;
- (NSURL *)imageURLForRow:(NSInteger)row;
- (NSString *)addressURLForRow:(NSInteger)row;
- (NSString *)appNameForRow:(NSInteger)row;
- (NSInteger)appIdForRow:(NSInteger)row;
- (NSString *)superCodeForRow:(NSInteger)row;

@end
