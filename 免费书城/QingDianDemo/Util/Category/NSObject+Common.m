//
//  NSObject+Common.m
//  FDPublic
//
//  Created by 刘伟 on 15/6/19.
//  Copyright (c) 2015年 timShadow. All rights reserved.
//

#import "NSObject+Common.h"

#define kToastDuration     1

@implementation NSObject (Common)

//显示失败提示
- (void)showErrorMsg:(NSObject *)msg{
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = msg.description;
    [progressHUD hideAnimated:YES afterDelay:kToastDuration];
}

//显示成功提示
- (void)showSuccessMsg:(NSObject *)msg{
    [self hideProgress];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.label.text = msg.description;
    [progressHUD hideAnimated:YES afterDelay:kToastDuration];
}

//显示忙
- (void)showProgress{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    [progressHUD hideAnimated:YES afterDelay:kToastDuration];
}

//隐藏提示
- (void)hideProgress{
    [MBProgressHUD hideHUDForView:[self currentView] animated:YES];
}

- (UIView *)currentView{
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        controller = [(UITabBarController *)controller selectedViewController];
    }
    if([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController *)controller visibleViewController];
    }
    if (!controller) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return controller.view;
}


// 网络提示信息
- (NSString *)promptStrWithStatus:(NSString *)status{
    NSString *promptStr = nil;
    if ([status isEqualToString:@"2000"]) {
        promptStr = @"未找到相关数据";
    }else if ([status isEqualToString:@"2001"]){
        promptStr = @"用户公司未找到";
    }else if ([status isEqualToString:@"2002"]){
        promptStr = @"传入参数缺少key";
    }else if ([status isEqualToString:@"2003"]){
        promptStr = @"传入参数为空";
    }else if ([status isEqualToString:@"2004"]){
        promptStr = @"登录失败，用户密码错误";
    }else if ([status isEqualToString:@"2005"]){
        promptStr = @"请求方式错误";
    }else if ([status isEqualToString:@"2006"]){
        promptStr = @"服务器内部错误";
    }else if ([status isEqualToString:@"2007"]){
        promptStr = @"抱歉您还没有登录";
    }else if ([status isEqualToString:@"2008"]){
        promptStr = @"传入type类型错误或获取不到序列号";
    }else if ([status isEqualToString:@"2009"]){
        promptStr = @"不符合唯一性检";
    }else if ([status isEqualToString:@"2010"]){
        promptStr = @"您不能通过此方式登录";
    }else if ([status isEqualToString:@"2011"]){
        promptStr = @"无此手机用户";
    }else if ([status isEqualToString:@"2012"]){
        promptStr = @"帐号密码不正确";
    }else if ([status isEqualToString:@"2013"]){
        promptStr = @"帐号密码不正确";
    }else if ([status isEqualToString:@"2014"]){
        promptStr = @"无此手机用户";
    }else if ([status isEqualToString:@"2015"]){
        promptStr = @"无此用户";
    }else if ([status isEqualToString:@"2016"]){
        promptStr = @"手机号格式错误";
    }else if ([status isEqualToString:@"2017"]){
        promptStr = @"验证码发送失败";
    }else if ([status isEqualToString:@"2018"]){
        promptStr = @"验证码获取频繁";
    }else if ([status isEqualToString:@"2019"]){
        promptStr = @"验证码校验失败";
    }else if ([status isEqualToString:@"2020"]){
        promptStr = @"您已注册过,请登录或通过忘记密码找回";
    }else if ([status isEqualToString:@"3006"]){
        promptStr = @"获取auth错误";
    }else if ([status isEqualToString:@"3007"]){
        promptStr = @"无法获取权限";
    }else if ([status isEqualToString:@"3008"]){
        promptStr = @"权限校验错误";
    }
    return promptStr;
}

//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr{
    NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:_encodedImageStr options:1];
    UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}

// 截图成为image
- (UIImage *)screenView:(UIView *)view{
    CGRect frame = view.frame;
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
//        for(UIView *subview in view.subviews)
//        {
//            
//            [subview drawViewHierarchyInRect:subview.bounds afterScreenUpdates:YES];
//        }
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    else
    {
        CGContextSaveGState(context);
        [view.layer renderInContext:context];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, CGRectMake(0, 0, kWindowW, view.frame.size.height));
    UIImage *CGImg = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return CGImg;
//    CGRect rect = view.frame;
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [view.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
}


// 限制图片大小在32K以内
- (NSData *)dataWithShareImage:(NSURL *)url{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    if(imageData!=nil){
        CGFloat q = 1.0;
        if(imageData.length>32000){
            q = 32000.0 / imageData.length;
        }
        if(q != 1.0){
            UIImage *imgTmp = [UIImage imageWithData:imageData];
            //图片大小限制在32k，不然分享失败
            imageData = UIImageJPEGRepresentation(imgTmp, q);
        }
    }
    return imageData;
}

// sd缓存计算
- (CGFloat)sdFolderSize{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    CGFloat folderSize = 0;
    //文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
        return folderSize;
    }
    return 0;
}

// sd清理缓存
-(void)sdCleanCache{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    //获取文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        //获取目录下面的文件名字
        NSArray *childFiles = [manager subpathsAtPath:path];
        for (NSString *fileName in childFiles){
            //拼接地址和文件名
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
            //清理文件
            NSError *error = nil;
            [manager removeItemAtPath:filePath error:&error];
        }
        //清理缓存
        [[SDImageCache sharedImageCache] cleanDisk];
        [self showSuccessMsg:@"清理完成!"];
    }
}

// 百度字符串
+ (NSString *)keywordWithBaiDuUrl:(NSString *)keyword{
    NSString * urlStart = @"https://m.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=";
    NSString * urlEnd = @"&rsv_pq=80c7023000194588&rsv_t=e923%2BJi6SI0Q7Kl1q1%2BUl%2Bq7jbwN0GzkIghhykTbOJO0WX2%2BnR6iKTwQWLI&rsv_enter=1&inputT=7275&rsv_sug3=20&rsv_sug1=19&rsv_sug2=0&rsv_sug4=7642";
    //NSString * keyword = @"java";
    NSMutableString * url = [[NSMutableString alloc]init];
    [url appendString:urlStart];
    [url appendString:keyword];
    [url appendString:urlEnd];
    return url;
}


// 获取cookie
+ (NSString *)loadRequestWithUrlString:(NSString *)urlString{
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    return cookieValue;
}
@end
