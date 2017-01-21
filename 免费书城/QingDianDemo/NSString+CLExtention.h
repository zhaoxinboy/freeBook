//
//  NSString+CLExtention.h
//  QNGG
//
//  Created by 刘昶 on 15/7/13.
//  Copyright (c) 2015年 luxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define fStringOrEmptyStr(str) [NSString stringOrEmptyStr:(str)]

#define fStringByReplaceStr(str1,str2) [NSString stringOrEmptyStr:(str1) replaceString:(str2)]
@interface NSString (CLExtention)

-(NSString *)encryptWithMD5;
-(NSString *)encryptWithSHA1;

-(NSString *)converGBKString;

-(NSString *)pinYinStr;
-(NSString *)pinYinHeadStr;
+(NSString *)macaddress;
-(CGSize)cl_sizeWithFont:(UIFont *)font;

-(CGSize)cl_sizeWithMaxSize:(CGSize)size attributes:(NSDictionary *)attr;
/**
 *  手机号验证
 */
-(BOOL)isMobilePhoneNumber;
/**
 *  验证码验证 (默认为:六位数字)
 */
-(BOOL)isValidCode;

/**
 *  判断是否为邮箱
 */
- (BOOL)isEmailFormat;

/**
 *  判断是否为密码格式
 */
- (BOOL)isCorrectPasswordFormat;

/**
 *  判断是否为整数
 */
- (BOOL)isPureInt ;

-(BOOL)isSJHttpSucces;

-(BOOL)isSJHttpNotNet;

-(instancetype)stringOrEmptyStr;

+(instancetype)stringOrEmptyStr:(NSString *)str;
+(instancetype)stringOrEmptyStr:(NSString *)str replaceString:(NSString *)reloaceStr;

+(NSString *)getUUID;

+(NSString *)prettyPrintedJson:(id)jsonObject;
-(id)JSONValue;
+ (UIColor *) colorWithString: (NSString *)color;

+(NSString *)cl_formatMobliePhoneNumber:(NSString *)phoneNumber;
/**
 *  汉字繁体转简体
 */
-(NSString *)chineseTraditional2Simplified;
/**
 *  汉字简体转繁体
 */
-(NSString *)chineseSimplified2Traditional;

- (BOOL)isChinese;//判断是否是纯汉字

- (BOOL)includeChinese;//判断是否含有汉字

@end


@interface NSMutableString (CLExtention)
-(void)appendSpaceIfHasLength;
-(void)appendSpace;
-(void)appendSpace:(NSUInteger)length;
-(void)appendPrefixSpaceString:(NSString *)aString;
-(void)appendString:(NSString *)aString withPrefixStr:(NSString *)prefix;
@end
