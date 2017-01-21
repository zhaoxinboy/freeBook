//
//  QDRSkinViewModel.h
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/16.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseViewModel.h"
#import "QDRHomePageModel.h"

@interface QDRSkinViewModel : BaseViewModel


// 获取皮肤图片
- (void)getSkinByUserid:(NSString *)userid NetCompleteHandle:(CompletionHandle)completionHandle;
@property (nonatomic, strong) QDRSkinModel *skinModel;
@property(nonatomic) NSInteger rowNumber;
- (NSString *)skinIdForRow:(NSInteger)row;
- (NSString *)skinNameForRow:(NSInteger)row;
- (NSURL *)skinPicaddrForRow:(NSInteger)row;


@end
