//
//  QDRLoginModel.h
//  QingDianDemo
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "BaseModel.h"
#import "MJExtension.h"

@interface QDRLoginModel : BaseModel

@property (nonatomic, strong) NSString *kStatus;

@property (nonatomic, strong) NSDictionary *kData;

@end

@interface QDRLoginStatusModel : BaseModel

@property (nonatomic, strong) NSString *status;

@end

@interface QDRLoginDataModel : BaseModel

@property (nonatomic, copy) NSString *username;  

@property (nonatomic, copy) NSString *qq;

@property (nonatomic, copy) NSString *first_name;

@property (nonatomic, copy) NSString *last_name;

@property (nonatomic, copy) NSString *usertype;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *is_superuser;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *is_staff;

@property (nonatomic, copy) NSString *last_login;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *rtoken;

@property (nonatomic, assign) NSNumber *userid;      // 用户ID

@property (nonatomic, copy) NSString *date_joined;

@end

//{
//    data =     {
//        avatar = "/media/avatar/default.png";
//        company = 1;
//        "date_joined" = "2016-10-05 07:17:16";
//        email = "";
//        "first_name" = "";
//        id = 14;
//        "is_active" = 1;
//        "is_staff" = 0;
//        "is_superuser" = 0;
//        "last_login" = "<null>";
//        "last_name" = "";
//        mobile = "<null>";
//        qq = "<null>";
//        serialnumber = "3E56A64F-BA3B-4214-B954-1EE9C5216179";
//        username = "3E56A64F-BA3B-4214-B954-1EE9C5216179";
//        usertype = 2;
//    };
//    status = 0;
//}

@interface QDRFirstModel : BaseModel

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *date_joined;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *first_name;

@property (nonatomic, assign) NSNumber *userid;      // 用户ID

@property (nonatomic, assign) NSNumber *usertype;

@property (nonatomic, copy) NSString *is_active;

@property (nonatomic, copy) NSString *is_staff;

@property (nonatomic, copy) NSString *is_superuser;

@property (nonatomic, copy) NSString *last_login;

@property (nonatomic, copy) NSString *last_name;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *qq;

@property (nonatomic, copy) NSString *serialnumber;

@property (nonatomic, copy) NSString *rtoken;

@property (nonatomic, copy) NSString *username;


@end

@interface QDRIsLoginModel : BaseModel

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSMutableDictionary *outerinfo;

@end


@interface QDRWXLgoinModel : BaseModel

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *headimgurl;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *openid;

@property (nonatomic, copy) NSString *privilege;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *unionid;

@end

@interface QDRQQLgoinModel : BaseModel

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *figureurl;

@property (nonatomic, copy) NSString *figureurl_1;

@property (nonatomic, copy) NSString *figureurl_2;

@property (nonatomic, copy) NSString *figureurl_qq_1;

@property (nonatomic, copy) NSString *figureurl_qq_2;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *is_lost;

@property (nonatomic, copy) NSString *is_yellow_vip;

@property (nonatomic, copy) NSString *is_yellow_year_vip;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *vip;

@property (nonatomic, copy) NSString *ret;

@property (nonatomic, copy) NSString *yellow_vip_level;

@end


