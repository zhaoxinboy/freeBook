//
//  QDRHomePage.h
//  QingDianDemo
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseModel.h"

@class QDRHomeStatusModel,QDRHomeDataModel, QDRHomeAddressStatusModel, QDRHomeAddressDataModel, QDRclassiModel, QDRclassiDataModel;


@interface QDRHomePageModel : BaseModel

@property (nonatomic, strong) NSString *kStatus;

@property (nonatomic, strong) QDRHomeDataModel *kData;

@end

@interface QDRHomeStatusModel : BaseModel

@property (nonatomic, strong) NSString *status;

@end

@interface QDRHomeDataModel : BaseModel

@property (nonatomic, strong) NSString *companyname;  // 公司名称

@property (nonatomic, strong) NSString *addtime;      // 加入时间

@property (nonatomic, strong) NSString *record;       // 记录

@property (nonatomic, strong) NSString *modifytime;   // 修改时间

@property (nonatomic, strong) NSString *logo;         // logo

@property (nonatomic, strong) NSNumber *qdrid;      // 用户ID

@property (nonatomic, strong) NSString *legal;          //法律条款

@end

@interface QDRHomeAddressModel : BaseModel

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSMutableArray *data;

@end

/*
 "applogopath": "/media/applogo/2016/09/me_07_PJFiA8G.png",
 "appname": "网易",
 "addtime": "2016-09-24 10:33:30",
 "isshow": true,
 "appurl": "wap.wangyi.com",
 "appindex": 6,
 "modifytime": "2016-09-24 10:33:30",
 "id": 7,
 "desc": "321"
 */

@interface QDRHomeAddressDataModel : BaseModel

@property (nonatomic, strong) NSString *applogopath;

@property (nonatomic, strong) NSString *appname;

@property (nonatomic, strong) NSString *addtime;

@property (nonatomic, strong) NSString *isshow;

@property (nonatomic, strong) NSString *appurl;

@property (nonatomic, strong) NSString *appindex;

@property (nonatomic, strong) NSString *modifytime;

@property (nonatomic, strong) NSNumber *qdrid;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *supercode;

@property (nonatomic, strong) NSString *iscollected;

@end

// 分类
@interface QDRclassificationModel : BaseModel

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QDRclassiModel : NSObject

@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, strong) NSMutableArray<QDRclassiDataModel *> *appinfo;

@property (nonatomic, strong) NSString *categoryname;

@end

@interface QDRclassiDataModel : NSObject

@property (nonatomic, strong) NSString *applogopath;

@property (nonatomic, strong) NSString *appname;

@property (nonatomic, strong) NSString *addtime;

@property (nonatomic, strong) NSString *isshow;

@property (nonatomic, strong) NSString *appurl;

@property (nonatomic, strong) NSString *appindex;

@property (nonatomic, strong) NSString *modifytime;

@property (nonatomic, strong) NSNumber *qdrid;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *iscollected;

@property (nonatomic, strong) NSString *supercode;

@end

@interface QDRSkinModel : BaseModel

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSMutableArray *data;

@end

@interface QDRSkinDataModel : NSObject

@property (nonatomic, copy) NSString *addtime;

@property (nonatomic, assign) NSNumber *skinId;

@property (nonatomic, copy) NSString *modifytime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *picaddr;

@end
