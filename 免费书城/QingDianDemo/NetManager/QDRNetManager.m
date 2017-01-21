//
//  QDRNetManager.m
//  QingDianDemo
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRNetManager.h"
#import "Reachability.h"
#import "QDRLoginViewModel.h"


const NSInteger kGGErrorNotNetCode = -501;
const NSInteger kGGErrorLoingByKeyCode = -502;
static NSString *const kGGErrorNetNetDiscription = @"无法链接到网络";
static NSString *const kGGErrorLoingByKeyDiscription = @"服务器异常";

static AFHTTPSessionManager *manager = nil;

@implementation QDRNetManager

+ (AFHTTPSessionManager *)sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    return manager;
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete{
    
    NSString *token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN];
    NSLog(@" token   %@", token);
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    __weak typeof(self) weakSelf = self;
    //打印网络请求
    NSLog(@"Request Path: %@, params %@", path, params);
    return [[self sharedAFManager] GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObject;
        if ([[dic objectForKey:@"status"] isEqualToString:@"3001"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3002"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3003"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3005"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3006"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3007"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3008"]) {
            NSLog(@"token失效或者为空或者一系列错误");
            __block NSString *oldUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
            [[QDRLoginViewModel new] postDataFromWithUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME] passWord:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] NetCompleteHandle:^(NSError *error) {
                NSString *token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN];
                NSLog(@" token   %@", token);
                if (token) {
                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                }
                NSString *pathStr = nil;
                NSString *newUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
                if (!([path rangeOfString:@"userid="].location == NSNotFound)) {
                    pathStr = [path stringByReplacingOccurrencesOfString:oldUserid withString:newUserid];
                }
                [weakSelf GET:pathStr parameters:params completionHandler:^(id responseObj, NSError *error) {
                     complete(responseObj, nil);
                 }];
             }];
        }else if ([[dic objectForKey:@"status"] isEqualToString:@"2004"] ||
                  [[dic objectForKey:@"status"] isEqualToString:@"2015"]){
            [[NSUserDefaults standardUserDefaults] setObject:NOLOGIN forKey:LOCAL_READ_ISLOGIN];// 此时用户登录失效，设置登录字段不为1
            __block NSString *oldUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
            QDRLoginViewModel *loginVM = [QDRLoginViewModel new];
            [loginVM postFirstRegistWithSign:LOCAL_READ_UUID andSerialnumber:LOCAL_READ_UUID companyid:LOCAL_READ_COMPANYID NetCompleteHandle:^(NSError *error) {
                NSString *pathStr = nil;
                NSString *newUserid = [NSString stringWithFormat:@"userid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]];
                if (!([path rangeOfString:@"userid="].location == NSNotFound)) {
                    pathStr = [path stringByReplacingOccurrencesOfString:oldUserid withString:newUserid];
                }
                [weakSelf GET:pathStr parameters:params completionHandler:^(id responseObj, NSError *error) {
                    complete(responseObj, nil);
                }];
            }];
        }else{
            complete(responseObject, nil);
        }
//        complete(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleText:@"网络错误"];
        complete(nil, error);
    }];
}

+ (id)POST:(NSString *)path parameters:(NSMutableDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete{
    NSString *token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN];
    NSLog(@" token   %@", token);
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    
    __weak typeof(self) weakSelf = self;
    return [[self sharedAFManager] POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObject;
        if ([[dic objectForKey:@"status"] isEqualToString:@"3001"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3002"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3003"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3005"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3006"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3007"]||
            [[dic objectForKey:@"status"] isEqualToString:@"3008"]) {
            NSLog(@"token失效或者为空或者一系列错误");
            [[QDRLoginViewModel new] postDataFromWithUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME] passWord:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] NetCompleteHandle:^(NSError *error) {
                NSString *token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN];
                NSLog(@" token   %@", token);
                if (token) {
                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                }
                NSMutableDictionary *newParams = params;
                if ([newParams objectForKey:@"userid"]) {
                    [newParams setObject:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] forKey:@"userid"];
                }
                [weakSelf POST:path parameters:newParams completionHandler:^(id responseObj, NSError *error) {
                    complete(responseObj, nil);
                }];
            }];
        }else if ([[dic objectForKey:@"status"] isEqualToString:@"2004"] ||
                  [[dic objectForKey:@"status"] isEqualToString:@"2015"]){
            [[NSUserDefaults standardUserDefaults] setObject:NOLOGIN forKey:LOCAL_READ_ISLOGIN];// 此时用户登录失效，设置登录字段不为1
            QDRLoginViewModel *loginVM = [QDRLoginViewModel new];
            [loginVM postFirstRegistWithSign:LOCAL_READ_UUID andSerialnumber:LOCAL_READ_UUID companyid:LOCAL_READ_COMPANYID NetCompleteHandle:^(NSError *error) {
                NSMutableDictionary *newParams = params;
                if ([newParams objectForKey:@"userid"]) {
                    [newParams setObject:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] forKey:@"userid"];
                }
                [weakSelf POST:path parameters:newParams completionHandler:^(id responseObj, NSError *error) {
                    complete(responseObj, nil);
                }];
            }];
        }else{
            complete(responseObject, nil);
        }
//        complete(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleText:@"网络错误"];
        complete(nil, error);
    }];
}

+ (NSString *)percentPathWithPath:(NSString *)path params:(NSDictionary *)params{
    NSMutableString *percentPath =[NSMutableString stringWithString:path];
    NSArray *keys = params.allKeys;
    NSInteger count = keys.count;
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [percentPath appendFormat:@"?%@=%@", keys[i], params[keys[i]]];
        }else{
            [percentPath appendFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
    }
    return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)handleError:(NSError *)error{
    [[self new] showErrorMsg:error]; // 弹出错误信息
}

+ (void)handleText:(NSString *)text{
    [[self new] showSuccessMsg:text]; //弹出信息
}

+(BOOL)isNetStatusWiFi{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
+(BOOL)isNetStatusWWAN{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
+(BOOL)isNetStatusEnable{
    return [self isNetStatusWiFi] || [self isNetStatusWWAN];
}







@end
