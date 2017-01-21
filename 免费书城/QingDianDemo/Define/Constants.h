//
//  Constants.h
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define LOCAL_READ_ISLOGIN              @"islogin"      // 登录状态
#define LOCAL_READ_USERTYPE             @"usertype"     // 是否注册过，1为手机注册  2为匿名用户
#define LOCAL_READ_FIRST                @"isfirst"      // 是否第一次登陆  是为1  不是为空
#define LOCAL_READ_USERID               @"userid"       // 用户ID
#define LOCAL_READ_USERNAME             @"username"     // 账号
#define LOCAL_READ_USERMOBILE           @"usermobile"   // 用户手机号
#define LOCAL_READ_PASSWORD             @"password"     // 密码
#define LOCAL_READ_MOBILE               @"moblie"       // 手机号
#define LOCAL_READ_TOKEN                @"token"        // token
#define LOCAL_READ_RECORD               @"record"       // 底部信息
#define LOCAL_READ_HEADERURL            @"headerurl"    // logo地址
#define LOCAL_READ_LEGAL                @"legal"        // 法律条款

#define LOCAL_READ_READURL              @"readurl"      // 继续阅读
#define LOCAL_READ_APPIMAGEURL          @"appImageUrl"  // 继续阅读图标
#define LOCAL_READ_SUPERCODE            @"supercode"    // 继续阅读去广告代码

#define LOCAL_READ_COMPANYID            @"2"            //公司ID

#define PHONELOGIN                      @"1"    //手机号登录
#define WXLOGIN                         @"2"    // 微信登录
#define QQLOGIN                         @"3"    // QQ登录
#define NOLOGIN                         @"100"  // 未登录


#define LOCAL_READ_SKIN                 @"skinName"         // 选中皮肤名称

#define LOCAL_READ_PLACEIMAGE           @"app_icon_pro"     // 图标默认图片

#define LOCAL_READ_PLACESKIN            @"pic_nor"          // 皮肤默认图片


#define LOCAL_READ_MD5                  @"-EF5T83H61CDX2B68"        //MD5加密拼接字符串

#define LOCAL_READ_UUID (NSString *)[SSKeychain passwordForService:@"com.dawenming.freeBook" account:@"com.dawenming.freeBook"]


//afp广告id
#define AFP_IPHONE_APPID @"67280675"
#define AFP_IPAD_APPID @"67276741"

// 区分iPhone和iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// QQ
#define QQAPPID @"1105872746"
#define QQAPPKEY @"cQcHaKcT4F3FwPZ1"

// 微信
//#define WXAPPKEY @"wxb958621a3a540480"                                  // 微信APPkey
#define WXAPPKEY @"wx38c5f8ad36572780"
#define WXSECRET @"b42e30b5a85f6695615cfc3a1235af03"                    // 微信密匙

// 微博
//#define WBAPPKEY @"1245459821"                                          // 微博APPkey
#define WBAPPKEY @"4036025500"
//#define WBSECRET @"bc142d4432fd286be454d9e6fffb9384"                    // 微博密匙
#define WBSECRET @"42d420a535a890530028fff907834153"
#define KREADIRECTURL @"https://api.weibo.com/oauth2/default.html"      // 微博回调页URL地址

#define BUNDLEID @"com.dawenming.freeBook"                          // 项目包名

// 友盟
//#define UMAPPKEY @"582136c445297d56d0001ae4"
#define UMAPPKEY @"583ba3aef29d98403a0002ac"                            // 友盟appkey




// 服务器地址
//#define URLPATH @"http://www.ironhide.top:8266"  // 线下
#define URLPATH @"http://60.205.170.90:8081"    // 线上


#define APPWIDTH (kWindowW - 50 - 20 * 5)/4                     // APP图标宽度

#define QDR_APP_WIDTH 47                                        // APP图标宽度

#define QDR_APP_HEIGHT 69                                       // APP图标高度

#define QDR_HOME_HEADER_HEIGHT 165                              // 首页头部高度

#define QDR_HOME_CONTENTOFFSET (QDR_HOME_HEADER_HEIGHT - 84)    // 首页头部偏移量

#define QDR_FIRST_COLOR kRGBColor(255,98,81)                    // 主色

#define QDR_HISTORY_HEIGHT 36                                   // 历史记录cell高度

//通过RGB设置颜色
#define kRGBColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

#define kWindowH   [UIScreen mainScreen].bounds.size.height //应用程序的屏幕高度
#define kWindowW    [UIScreen mainScreen].bounds.size.width  //应用程序的屏幕宽度

#define kAppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate))

#define kStoryboard(StoryboardName)     [UIStoryboard storyboardWithName:StoryboardName bundle:nil]

//通过Storyboard ID 在对应Storyboard中获取场景对象
#define kVCFromSb(storyboardId, storyboardName)     [[UIStoryboard storyboardWithName:storyboardName bundle:nil] \
instantiateViewControllerWithIdentifier:storyboardId]

//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}

//Docment文件夹目录
#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

#endif /* Constants_h */
