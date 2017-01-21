//
//  QDRHistoryModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/10/5.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseModel.h"

@interface QDRHistoryModel : BaseModel

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QDRHistoryArrModel : BaseModel

@property (nonatomic, strong) NSString *appurl;

@property (nonatomic, assign) NSNumber *appID;

@property (nonatomic, strong) NSString *applogopath;

@property (nonatomic, strong) NSString *appname;

@property (nonatomic, strong) NSString *supercode;

@end
