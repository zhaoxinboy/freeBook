//
//  QDRLoginViewController.m
//  QingDianDemo
//
//  Created by 随看 on 16/9/30.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRLoginViewController.h"
#import "QDRLoginView.h"
#import "QDRForgotViewController.h"
#import "QDRRegisteredViewController.h"
#import "QDRUserFeedbackViewController.h"
#import "QDRLoginViewModel.h"
#import "QDRNaviTitleView.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "QDRLoginModel.h"


@interface QDRLoginViewController ()<WXDelegate, TencentSessionDelegate>

@property (nonatomic, strong) QDRLoginView *loginView;

@property (nonatomic, strong) QDRLoginViewModel *loginVM;

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;


@end

@implementation QDRLoginViewController{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
    AppDelegate *appdelegate;
    NSString *_qqOpenId;
}

- (QDRNaviTitleView *)naviTitleView{
    if (!_naviTitleView) {
        _naviTitleView = [[QDRNaviTitleView alloc] init];
    }
    return _naviTitleView;
}

- (QDRLoginViewModel *)loginVM
{
    if (!_loginVM) {
        _loginVM = [QDRLoginViewModel new];
    }
    return _loginVM;
}

- (QDRLoginView *)loginView
{
    if (!_loginView) {
        _loginView = [[QDRLoginView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_loginView];
        [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        // 注册KVO监听  忘记密码  登录  注册  用户反馈
        [_loginView addObserver:self forKeyPath:@"KVOForgotNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [_loginView addObserver:self forKeyPath:@"KVOLoginNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [_loginView addObserver:self forKeyPath:@"KVORegisterNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [_loginView addObserver:self forKeyPath:@"qqKVO" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [_loginView addObserver:self forKeyPath:@"KVOweixin" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        
    }
    return _loginView;
}

- (void)dealloc
{
    /* 移除KVO */
    [self.loginView removeObserver:self forKeyPath:@"KVOForgotNum" context:nil];
    [self.loginView removeObserver:self forKeyPath:@"KVOLoginNum" context:nil];
    [self.loginView removeObserver:self forKeyPath:@"KVORegisterNum" context:nil];
    [self.loginView removeObserver:self forKeyPath:@"qqKVO" context:nil];
    [self.loginView removeObserver:self forKeyPath:@"KVOweixin" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self loginView];
    
    //导航条内容
    [self setNavigationController];
    // Do any additional setup after loading the view.
}

/* KVO调用方法 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.loginView) {
        if([keyPath isEqualToString:@"KVOForgotNum"])
        {
            // 响应变化处理 忘记密码
            self.hidesBottomBarWhenPushed = YES;
            QDRForgotViewController *fvc = [[QDRForgotViewController alloc] init];
            [self.navigationController pushViewController:fvc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }else if ([keyPath isEqualToString:@"KVOLoginNum"]){
            // 响应变化处理 登录
            __weak QDRLoginViewController *wself = self;
            
            [self.loginVM postAppLoginWithMobile:_loginView.phoneTF.text passWord:_loginView.passWordTF.text NetCompleteHandle:^(NSError *error) {
                if ([[NSString stringWithFormat:@"%@",wself.loginVM.successApp] isEqualToString:@"0"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:wself.loginView.phoneTF.text forKey:LOCAL_READ_MOBILE];
                    [[NSUserDefaults standardUserDefaults] setObject:wself.loginView.phoneTF.text forKey:LOCAL_READ_USERNAME];
                    if (wself.loginView.rememberBtn.selected) {  //记住密码
                        [[NSUserDefaults standardUserDefaults] setObject:wself.loginView.passWordTF.text forKey:LOCAL_READ_PASSWORD];
                    }
                    // 登录状态设为1表示已登录
                    [[NSUserDefaults standardUserDefaults] setObject:PHONELOGIN forKey:LOCAL_READ_ISLOGIN];
                    [wself showSuccessMsg:@"登陆成功"];
                    [MobClick profileSignInWithPUID:LOCAL_READ_UUID];// 友盟登录
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [wself showErrorMsg:@"账号密码错误"];
                }
            }];
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
            
        }else if ([keyPath isEqualToString:@"KVORegisterNum"]){
            // 响应变化处理 注册
            self.hidesBottomBarWhenPushed = YES;
            QDRRegisteredViewController *rvc = [[QDRRegisteredViewController alloc] init];
            [self.navigationController pushViewController:rvc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            NSLog(@"注册");
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
            
        }else if ([keyPath isEqualToString:@"qqKVO"]){
            // QQ登录事件
            NSLog(@"QQ登录跳转");
            _tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:self];
            _permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
            // 这里调起登录
            [_tencentOAuth authorize:_permissionArray];
            
        }else if ([keyPath isEqualToString:@"KVOweixin"]){
            
            if ([WXApi isWXAppInstalled]) {
                SendAuthReq *req = [[SendAuthReq alloc]init];
                req.scope = @"snsapi_userinfo";
                req.openID = WXAPPKEY;
                req.state = @"12345";
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.wxDelegate = self;
                
                [WXApi sendAuthReq:req viewController:self delegate:appDelegate];
                // 微信登录事件
                NSLog(@"微信登录跳转");
                NSLog(@"%d", [WXApi sendAuthReq:req viewController:self delegate:appDelegate]);
            }else{
                [self showErrorMsg:@"未检测到微信客户端"];
            }
        }
    }
    
}

#pragma mark 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPKEY,WXSECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        /*
         access_token	接口调用凭证
         expires_in	access_token接口调用凭证超时时间，单位（秒）
         refresh_token	用户刷新access_token
         openid	授权用户唯一标识
         scope	用户授权的作用域，使用逗号（,）分隔
         unionid	 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString *accessToken=[dic valueForKey:@"access_token"];
        NSString *openID=[dic valueForKey:@"openid"];
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    [self loginVM];
    __weak typeof (self) wself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //开发人员拿到相关微信用户信息后， 需要与后台对接，进行登录
        NSLog(@"login success dic  ==== %@",dic);
        
        QDRWXLgoinModel *qqModel  = [QDRWXLgoinModel mj_objectWithKeyValues:dic];
        NSLog(@"%@", qqModel.nickname);
        
        NSString *reObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", reObject);
        
        [wself.loginVM postOutherLoginWithOnlyid:openID serialnumber:LOCAL_READ_UUID userid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] type:@"1" outerinfo:reObject nickname:(NSString *)qqModel.nickname NetCompleteHandle:^(NSError *error) {
            if ([wself.loginVM.successOuther isEqualToString:@"0"]) {
                [wself showSuccessMsg:@"登陆成功"];
                [[NSUserDefaults standardUserDefaults] setObject:WXLOGIN forKey:LOCAL_READ_ISLOGIN];
                [wself.navigationController popViewControllerAnimated:YES];
            }else{
                [wself showErrorMsg:@"登录失败，请重新登录"];
            }
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
    }];
}


- (void)setNavigationController
{
    self.naviTitleView.titleLabel.text = @"登录";
    self.naviTitleView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = self.naviTitleView;
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e64a" style:UIBarButtonItemStylePlain target:self action:@selector(go2Back)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"iconfont" size:24], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

- (void)go2Back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    //这里可以对点击的url进行操作
    
    if (label == _loginView.forgotPassword) {
        QDRForgotViewController *fvc = [[QDRForgotViewController alloc] init];
        [self.navigationController pushViewController:fvc animated:YES];
    }
    if (label == _loginView.registered) {
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
//        - (void)getUserInfoResponse:(APIResponse*) response
        //这个方法就是 用户信息的回调方法。
        
        [_tencentOAuth getUserInfo];
        _qqOpenId = _tencentOAuth.openId;   // 保存用户的openid
    }else{
        
        NSLog(@"accessToken 没有获取成功");
    }
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        [self showErrorMsg:@"取消登录"];
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        [self showErrorMsg:@"登录失败"];
        NSLog(@"其他原因， 导致登录失败");
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    [self showErrorMsg:@"网络连接错误"];
    NSLog(@"没有网络了， 怎么登录成功呢");
}


/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }
    
}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //            _labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            NSLog(@"增量授权失败，无网络连接，请设置网络");
            break;
        }
        case kUpdateFailUserCancel:
        {
            //            _labelTitle.text=@"增量授权失败，用户取消授权";
            NSLog(@"增量授权失败，用户取消授权");
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            NSLog(@"增量授权失败，未知错误");
            break;
        }
    }
    
    
}

#pragma mark 登录成功后，回调 - 返回对应QQ的相关信息
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    
    //这里 与自己服务器进行对接，看怎么利用这获取到的个人信息。
    
    NSDictionary *dic = response.jsonResponse;
    NSLog(@" response %@",dic);
    QDRQQLgoinModel *qqloginModel = [QDRQQLgoinModel mj_objectWithKeyValues:dic];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    
    __weak typeof (self) wself = self;
    [self.loginVM postOutherLoginWithOnlyid:_qqOpenId serialnumber:LOCAL_READ_UUID userid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] type:@"2" outerinfo:str nickname:(NSString *)qqloginModel.nickname NetCompleteHandle:^(NSError *error) {
        if ([wself.loginVM.successOuther isEqualToString:@"0"]) {
            [wself showSuccessMsg:@"登陆成功"];
            [[NSUserDefaults standardUserDefaults] setObject:QQLOGIN forKey:LOCAL_READ_ISLOGIN];
            [wself.navigationController popViewControllerAnimated:YES];
        }else{
            [wself showErrorMsg:@"登录失败，请重新登录"];
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
