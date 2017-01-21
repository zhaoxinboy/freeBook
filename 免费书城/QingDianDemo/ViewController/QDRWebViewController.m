//
//  QDRWebViewController.m
//  freeBook
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRWebViewController.h"
#import "QDRIsLoggedInViewController.h"
#import "QDRLoginViewController.h"
#import <WebKit/WebKit.h>
#import "QDRBookMarkView.h"
#import "WXApi.h"
#import "FMDBManager.h"
#import "QDRBookViewModel.h"
#import "AppDelegate.h"
#import "QDRSwipeView.h"
#import "QDRWebNaviView.h"

@interface QDRWebViewController ()<WKNavigationDelegate, WKUIDelegate,WXApiDelegate, UINavigationControllerDelegate, deleteUrlDelegate, WeiboSDKDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) NSString *Title;

@property (nonatomic, strong) QDRWebNaviView *naviView;     // 导航栏

@property (nonatomic, strong) UIView *tabbarView;       // 自定义tabbar

@property (nonatomic, strong) UILabel *titleLabel;      // 导航栏标题

@property (nonatomic, strong) UIButton *barGoBack;       // 返回
@property (nonatomic, strong) UIButton *barGoForward;    // 返回上一级
@property (nonatomic, strong) UIButton *homePage;        // 主页
@property (nonatomic, strong) UIButton *share;           // 分享
@property (nonatomic, strong) UIButton *bookmarks;       // 书签

@property (nonatomic, strong) UIView *shareView;            //分享视图
@property (nonatomic, strong) UIButton *weixinShareBtn;    // 微信分享
@property (nonatomic, strong) UIButton *quanShareBtn;       // 朋友圈分享
@property (nonatomic, strong) UIButton *weiboShareBtn;    // 微博分享

@property (nonatomic, strong) UIButton *maskBtn;            // 遮罩层按钮

@property (nonatomic, strong) QDRBookMarkView *bookView;        // 书签

@property (nonatomic, strong) QDRSwipeView *leftSwipeView;     //右滑左侧出现视图用于返回上一页面

@property (nonatomic, strong) QDRSwipeView *rightSwipeView;    // 左滑右侧出现视图用于前进到上一页面


@end

@implementation QDRWebViewController
{
    NSString *urlString;  //当前URL地址
    
    UILabel *gobackLabel;  //返回文字
    UILabel *goForwardLabel;  //返回上一页文字
    UILabel *homeLabel;
    UILabel *shareBtnLabel;
    UILabel *bookMarksLabel;
    
    CALayer *progresslayer;  // 网页进度条
    
    CGFloat marginOffset;  // 上下滑动距离
}

- (QDRWebNaviView *)naviView{
    if (!_naviView) {
        _naviView = [[QDRWebNaviView alloc] init];
        _naviView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_naviView];
        [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        UIView *naviView = [UIView new];
        naviView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:naviView];
        [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        [_naviView addObserver:self forKeyPath:@"appImageKVO" options:NSKeyValueObservingOptionNew context:NULL];
        [_naviView addObserver:self forKeyPath:@"rightKVO" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _naviView;
}

- (QDRSwipeView *)leftSwipeView{
    if (!_leftSwipeView) {
        _leftSwipeView = [[QDRSwipeView alloc] initWithFrame:CGRectMake(-44, kWindowH / 2 - 22, 44, 44)];
        _leftSwipeView.swipeLabel.text = @"\U0000e64a";
        [self.view addSubview:_leftSwipeView];
        [self.view bringSubviewToFront:_leftSwipeView];
    }
    return _leftSwipeView;
}

- (QDRSwipeView *)rightSwipeView{
    if (!_rightSwipeView) {
        _rightSwipeView = [[QDRSwipeView alloc] initWithFrame:CGRectMake(kWindowW, kWindowH / 2 - 22, 44, 44)];
        _rightSwipeView.swipeLabel.text = @"\U0000e64d";
        [self.view addSubview:_rightSwipeView];
        [self.view bringSubviewToFront:_rightSwipeView];
    }
    return _rightSwipeView;
}

// 删除书签代理方法，用于刷新删除书签后当前页面为历史书签
- (void)deleteUrlwithString:(NSString *)urlString{
    if ([self.webView.URL absoluteString] && _naviView.rightBtn.selected == YES) {
        _naviView.rightBtn.selected = NO;
        [self judgeRightBtnText];
    }
}

// 书签
- (QDRBookMarkView *)bookView{
    if (!_bookView) {
        _bookView = [[QDRBookMarkView alloc] initWithFrame:CGRectMake(0, kWindowH, kWindowW, 320)];
        _bookView.delegate = self;
    }
    return _bookView;
}

// 遮罩层
- (UIButton *)maskBtn{
    if (!_maskBtn) {
        _maskBtn = [UIButton new];
        _maskBtn.backgroundColor = [UIColor blackColor];
        [_maskBtn addTarget:self action:@selector(maskTheWindow) forControlEvents:UIControlEventTouchUpInside];
        _maskBtn.alpha = 0;
        _maskBtn.frame = CGRectMake(0, 0, kWindowW, kWindowH);
        [self.view addSubview:_maskBtn];
    }
    return _maskBtn;
}

// 遮罩层点击事件
- (void)maskTheWindow{
    if (_shareView) {// 如果是分享视图
        [UIView animateWithDuration:0.2 animations:^{
            _shareView.frame = CGRectMake(0, kWindowH, kWindowW, 200);
            _maskBtn.alpha = 0;
        } completion:^(BOOL finished) {
            [self setMaskBtn:nil];
            [self setShareView:nil];
        }];
    }else if (_bookView.frame.origin.y != kWindowH){
        [_bookView downBookView];
        [UIView animateWithDuration:0.2 animations:^{
            _maskBtn.alpha = 0;
        } completion:^(BOOL finished) {
            [self setMaskBtn:nil];
        }];
    }
}


- (id)initWithURL:(NSURL *)url andTitle:(NSString *)title{
    if (self = [super init]) {
        self.url = url;
        urlString = [url absoluteString];  // 初始化时把URL传给分享页面，否则为空
        self.Title = title;
    }
    return self;
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        webConfig.preferences = [[WKPreferences alloc] init];
        // 默认为0
        webConfig.preferences.minimumFontSize = 10;
        // 默认认为YES
        webConfig.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // web内容处理池
        webConfig.processPool = [[WKProcessPool alloc] init];
        // 将所有cookie以document.cookie = 'key=value';形式进行拼接
        NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
        // 加cookie给h5识别，表明在ios端打开该地址
        WKUserContentController* userContentController = WKUserContentController.new;
        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        webConfig.userContentController = userContentController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.delegate = self;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
        [request addValue:[NSString loadRequestWithUrlString:_url.absoluteString] forHTTPHeaderField:@"Cookie"];
        [_webView loadRequest:request];
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
        }];
        // 进度条监听
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
        progress.backgroundColor = [UIColor clearColor];
        [_webView addSubview:progress];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 3);
        layer.backgroundColor = kRGBColor(255, 75, 59).CGColor;
        [progress.layer addSublayer:layer];
        progresslayer = layer;
        // 标题监听
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [_webView addGestureRecognizer:panGestureRecognizer]; // 添加托移手势
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleRecognizer.delegate = self;
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        singleRecognizer.cancelsTouchesInView = NO;
        // 添加单击手势
        [_webView addGestureRecognizer:singleRecognizer];
    }
    return _webView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![[touches anyObject].view isEqual:_webView]){
        NSLog(@"111");
    }
}


// 单击手势，用于隐藏和显示广告
- (void)singleTap:(UITapGestureRecognizer *)singleRecognizer{
    CGPoint point = [singleRecognizer locationInView:self.view];
    NSLog(@"point   %f,%f", point.x, point.y);
    if (CGRectContainsPoint(CGRectMake(kWindowW / 3, _webView.frame.origin.y, kWindowW / 3, _webView.frame.size.height), point)){
        CGRect bannersframe = self.bannersView.frame;
        if (bannersframe.origin.y == kWindowH) {
            bannersframe.origin.y = self.tabbarView.frame.origin.y - self.bannersView.frame.size.height;
        }else{
            bannersframe.origin.y = kWindowH;
        }
        self.bannersView.frame = bannersframe;
    }else{
        CGRect bannersframe = self.bannersView.frame;
        if (bannersframe.origin.y == kWindowH) {
            bannersframe.origin.y = self.tabbarView.frame.origin.y - self.bannersView.frame.size.height;
        }
        self.bannersView.frame = bannersframe;
    }
}

// 左右滑动手势方法
- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    CGRect leftFrame = self.leftSwipeView.frame;
    CGRect rightFrame = self.rightSwipeView.frame;
    if (translation.x > 0) {  // 向右滑动
        if (_webView.canGoBack) {
            leftFrame.origin.x = -44 + translation.x;
            if (leftFrame.origin.x >= 0) {
                leftFrame.origin.x = 0;
            }
            self.leftSwipeView.frame = leftFrame;
        }
    }else if(translation.x < 0){  //向左滑动
        if (_webView.canGoForward) {
            rightFrame.origin.x = kWindowW + translation.x;
            if (rightFrame.origin.x <= kWindowW - 44) {
                rightFrame.origin.x = kWindowW - 44;
            }
            self.rightSwipeView.frame = rightFrame;
        }
    }else if(translation.y < 0){  //向左滑动
        NSLog(@"%f", translation.y);
    }else if(translation.y > 0){  //向左滑动
        NSLog(@"%f", translation.y);
    }
    if ([recognizer state] == UIGestureRecognizerStateEnded) { // 停止拖动
        [self checkForPartialScroll];
    }
}

//左右滑动手势停止的方法
- (void)checkForPartialScroll{
    if (self.leftSwipeView.frame.origin.x == 0) {
        [_webView goBack];
        [UIView animateWithDuration:0.1 animations:^{
            _leftSwipeView.frame = CGRectMake(-44, kWindowH / 2 - 22, 44, 44);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            _leftSwipeView.frame = CGRectMake(-44, kWindowH / 2 - 22, 44, 44);
        }];
    }
    if (self.rightSwipeView.frame.origin.x == kWindowW - 44){
        [_webView goForward];
        [UIView animateWithDuration:0.1 animations:^{
            _rightSwipeView.frame = CGRectMake(kWindowW, kWindowH / 2 - 22, 44, 44);
        }];
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            _rightSwipeView.frame = CGRectMake(kWindowW, kWindowH / 2 - 22, 44, 44);
        }];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    self.banners = nil;
    
    _webView.navigationDelegate = nil;
    _webView.UIDelegate = nil;
    _webView.scrollView.delegate = nil;
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"URL"];
    [_bookView removeObserver:self forKeyPath:@"kvoUrl"];
    
    [_naviView removeObserver:self forKeyPath:@"appImageKVO"];
    [_naviView removeObserver:self forKeyPath:@"rightKVO"];
}

// 程序退出到后台后的操作
- (void)applicationWillResignActive:(UIApplication *)application{
    [[NSUserDefaults standardUserDefaults] setObject:[_webView.URL absoluteString] forKey:LOCAL_READ_READURL];
    [[NSUserDefaults standardUserDefaults] setObject:self.appImageUrl.absoluteString forKey:LOCAL_READ_APPIMAGEURL];
    [[NSUserDefaults standardUserDefaults] setObject:self.supercode forKey:LOCAL_READ_SUPERCODE];
    NSLog(@"%@", [_webView.URL absoluteString]);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    //    if (![[FMDBManager sharedFMDBManager] getAllBookView]) {
    //        // 添加一个书签
    //        QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
    //        model.titlestr = @"点击右上角按钮添加书签";
    //        [[FMDBManager sharedFMDBManager] addBookView:model];
    //    }
    
    // 隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    // 设置导航控制器的代理为self
    //    self.navigationController.delegate = self;
    
    // 导航栏部分
    [self naviView];
    [_naviView.appImageView sd_setImageWithURL:self.appImageUrl placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
    
    
    [self webView];
    
    // 添加KVO监听
    [self.bookView addObserver:self forKeyPath:@"kvoUrl" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    
    
    
    // 底部
    self.tabbarView = [UIView new];
    _tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabbarView];
    [_tabbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    self.barGoBack = [UIButton new];
    self.barGoBack.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
    [self.barGoBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.barGoBack setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.barGoBack setTitle:@"\U0000e64a" forState:UIControlStateNormal];
    [self.barGoBack setTitle:@"\U0000e64a" forState:UIControlStateHighlighted];
    self.barGoBack.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    [self.barGoBack addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:self.barGoBack];
    [self.barGoBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWindowW / 4, 40));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    gobackLabel = [UILabel new];
    gobackLabel.text = @"返回";
    gobackLabel.textColor = [UIColor blackColor];
    gobackLabel.font = [UIFont systemFontOfSize:8];
    [_tabbarView addSubview:gobackLabel];
    [gobackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_barGoBack.mas_centerX).mas_equalTo(0);
        make.bottom.mas_equalTo(_tabbarView.mas_bottom).mas_equalTo(-3);
    }];
    
    self.barGoForward = [UIButton new];
    self.barGoForward.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
    [self.barGoForward setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.barGoForward setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.barGoForward setTitle:@"\U0000e64d" forState:UIControlStateNormal];
    [self.barGoForward setTitle:@"\U0000e64d" forState:UIControlStateHighlighted];
    self.barGoForward.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    [self.barGoForward addTarget:self action:@selector(go2Forward) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:self.barGoForward];
    [self.barGoForward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWindowW / 4, 40));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kWindowW / 4);
    }];
    goForwardLabel = [UILabel new];
    goForwardLabel.text = @"上一页";
    goForwardLabel.textColor = [UIColor blackColor];
    goForwardLabel.font = [UIFont systemFontOfSize:8];
    [_tabbarView addSubview:goForwardLabel];
    [goForwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_barGoForward.mas_centerX).mas_equalTo(0);
        make.bottom.mas_equalTo(_tabbarView.mas_bottom).mas_equalTo(-3);
    }];
    
    [self.barGoBack setUserInteractionEnabled:NO];
    self.barGoBack.alpha = 0.2;
    gobackLabel.alpha = 0.2;
    [self.barGoForward setUserInteractionEnabled:NO];
    self.barGoForward.alpha = 0.2;
    goForwardLabel.alpha = 0.2;
    
    self.homePage = [UIButton new];
    self.homePage.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
    [self.homePage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.homePage setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.homePage setTitle:@"\U0000e655" forState:UIControlStateNormal];
    [self.homePage setTitle:@"\U0000e655" forState:UIControlStateHighlighted];
    self.homePage.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    [self.homePage addTarget:self action:@selector(goHomePage) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:self.homePage];
    [self.homePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWindowW / 4, 40));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo((kWindowW / 4) * 2);
    }];
    homeLabel = [UILabel new];
    homeLabel.text = @"主页";
    homeLabel.textColor = [UIColor blackColor];
    homeLabel.font = [UIFont systemFontOfSize:8];
    [_tabbarView addSubview:homeLabel];
    [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_homePage.mas_centerX).mas_equalTo(0);
        make.bottom.mas_equalTo(_tabbarView.mas_bottom).mas_equalTo(-3);
    }];
    
    //    self.share = [UIButton new];
    //    self.share.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
    //    [self.share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self.share setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //    [self.share setTitle:@"\U0000e735" forState:UIControlStateNormal];
    //    [self.share setTitle:@"\U0000e735" forState:UIControlStateHighlighted];
    //    self.share.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    //    [self.share addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
    //    [_tabbarView addSubview:self.share];
    //    [self.share mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.size.mas_equalTo(CGSizeMake(kWindowW / 5, 40));
    //        make.bottom.mas_equalTo(0);
    //        make.left.mas_equalTo((kWindowW / 5) * 3);
    //    }];
    //    shareBtnLabel = [UILabel new];
    //    shareBtnLabel.text = @"分享";
    //    shareBtnLabel.textColor = [UIColor blackColor];
    //    shareBtnLabel.font = [UIFont systemFontOfSize:8];
    //    [_tabbarView addSubview:shareBtnLabel];
    //    [shareBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(_share.mas_centerX).mas_equalTo(0);
    //        make.bottom.mas_equalTo(_tabbarView.mas_bottom).mas_equalTo(-3);
    //    }];
    
    self.bookmarks = [UIButton new];
    self.bookmarks.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
    [self.bookmarks setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bookmarks setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.bookmarks setTitle:@"\U0000e60f" forState:UIControlStateNormal];
    [self.bookmarks setTitle:@"\U0000e60f" forState:UIControlStateHighlighted];
    self.bookmarks.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
    [self.bookmarks addTarget:self action:@selector(goBookMarks) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:self.bookmarks];
    [self.bookmarks mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWindowW / 4, 40));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo((kWindowW / 4) * 3);
    }];
    bookMarksLabel = [UILabel new];
    bookMarksLabel.text = @"书签";
    bookMarksLabel.textColor = [UIColor blackColor];
    bookMarksLabel.font = [UIFont systemFontOfSize:8];
    [_tabbarView addSubview:bookMarksLabel];
    [bookMarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bookmarks.mas_centerX).mas_equalTo(0);
        make.bottom.mas_equalTo(_tabbarView.mas_bottom).mas_equalTo(-3);
    }];
    
    self.bannersView = [[QDRBannersView alloc] init];
    [self.view addSubview:self.bannersView];
    self.banners = [[MMUBanners alloc] initWithSlotId:(IS_IPAD ? AFP_IPAD_APPID : AFP_IPHONE_APPID) bannersDelegate:self  browserDelegate:self positionType:PositionTypeDown_middle];
    self.banners.mPreferredWidth = kWindowW < kWindowH ? kWindowW :kWindowH;
    NSLog(@"%f", self.banners.layer.frame.size.height);
    [self.bannersView addSubview:_banners];
    
}

// 判断右侧按钮下方文字
- (void)judgeRightBtnText{
    if (_naviView.rightBtn.selected) {
        _naviView.rightLabel.text = @"删除书签";
    }else{
        _naviView.rightLabel.text = @"添加书签";
    }
}

// 添加书签
- (void)addBookViewFMDB{
    if (!_naviView.rightBtn.selected) {
        // 添加一个书签
        QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
        model.titlestr = _naviView.naviTitleLabel.text;
        model.url = urlString;
        model.userUUID = LOCAL_READ_UUID;
        model.imageData = [self UIImageToBase64Str:[self screenView:_webView]];
        model.titleData = self.appImageUrl.absoluteString;
        model.superCode = _supercode;
        BOOL judge = [[FMDBManager sharedFMDBManager] addBookView:model];
        if (judge) {
            _naviView.rightBtn.selected = !_naviView.rightBtn.selected;
            [self showSuccessMsg:@"添加书签成功"];
        }else{
            [self showSuccessMsg:@"添加书签失败，请重试"];
        }
    }else{
        NSMutableArray *arr = [[FMDBManager sharedFMDBManager] getAllBookView];
        for (int i = 0; i < arr.count; i++) {
            QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
            model = arr[i];
            if ([model.url isEqualToString:[self.webView.URL absoluteString]]) {
                if ([[FMDBManager sharedFMDBManager] deleteBookView:model]){
                    _naviView.rightBtn.selected = !_naviView.rightBtn.selected;
                    [self showSuccessMsg:@"删除书签成功"];
                }else{
                    [self showSuccessMsg:@"删除书签失败，请重试"];
                }
            }
        }
    }
    [self judgeRightBtnText];
}

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [UIView new];
        _shareView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shareView];
        _shareView.frame = CGRectMake(0, kWindowH, kWindowW, 200);
        UIButton *closeBtn = [UIButton new];
        [closeBtn setTitle:@"取  消" forState:UIControlStateNormal];
        [closeBtn setTitle:@"取  消" forState:UIControlStateHighlighted];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [closeBtn addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor blackColor];
        [_shareView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(-41);
        }];
        UILabel *shareLabel = [UILabel new];
        shareLabel.text = @"分享";
        shareLabel.textColor = [UIColor blackColor];
        [_shareView addSubview:shareLabel];
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.centerX.mas_equalTo(0);
        }];
        self.weixinShareBtn = [UIButton new];
        self.weixinShareBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:45];
        [self.weixinShareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.weixinShareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.weixinShareBtn setTitle:@"\U0000e775" forState:UIControlStateNormal];
        [self.weixinShareBtn setTitle:@"\U0000e775" forState:UIControlStateHighlighted];
        [self.weixinShareBtn addTarget:self action:@selector(go2weixinshare) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:self.weixinShareBtn];
        [self.weixinShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(kWindowW / 3, 140));
        }];
        UILabel *weixinLabel = [UILabel new];
        weixinLabel.textColor = [UIColor blackColor];
        weixinLabel.text = @"微信";
        [self.shareView addSubview:weixinLabel];
        [weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_weixinShareBtn.mas_bottom).mas_equalTo(-40);
            make.centerX.mas_equalTo(_weixinShareBtn.mas_centerX).mas_equalTo(0);
        }];
        
        
        self.quanShareBtn = [UIButton new];
        self.quanShareBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:45];
        [self.quanShareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.quanShareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.quanShareBtn setTitle:@"\U0000e6a2" forState:UIControlStateNormal];
        [self.quanShareBtn setTitle:@"\U0000e6a2" forState:UIControlStateHighlighted];
        [self.quanShareBtn addTarget:self action:@selector(go2quanshare) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:self.quanShareBtn];
        [self.quanShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kWindowW / 3);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(kWindowW / 3, 140));
        }];
        UILabel *quanLabel = [UILabel new];
        quanLabel.textColor = [UIColor blackColor];
        quanLabel.text = @"朋友圈";
        [self.shareView addSubview:quanLabel];
        [quanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_quanShareBtn.mas_bottom).mas_equalTo(-40);
            make.centerX.mas_equalTo(_quanShareBtn.mas_centerX).mas_equalTo(0);
        }];
        
        self.weiboShareBtn = [UIButton new];
        self.weiboShareBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:45];
        [self.weiboShareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.weiboShareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.weiboShareBtn setTitle:@"\U0000e600" forState:UIControlStateNormal];
        [self.weiboShareBtn setTitle:@"\U0000e600" forState:UIControlStateHighlighted];
        [self.weiboShareBtn addTarget:self action:@selector(go2weiboshare) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:self.weiboShareBtn];
        [self.weiboShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(kWindowW / 3, 140));
        }];
        UILabel *weiboLabel = [UILabel new];
        weiboLabel.textColor = [UIColor blackColor];
        weiboLabel.text = @"微博";
        [self.shareView addSubview:weiboLabel];
        [weiboLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_weiboShareBtn.mas_bottom).mas_equalTo(-40);
            make.centerX.mas_equalTo(_weiboShareBtn.mas_centerX).mas_equalTo(0);
        }];
        
    }
    return _shareView;
}

// 微信分享
- (void)go2weixinshare{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _titleLabel.text;
    message.description = _titleLabel.text;
    [message setThumbImage:_naviView.appImageView.image];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = urlString;
    NSLog(@"%@", urlString);
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

// 朋友圈分享
- (void)go2quanshare{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _titleLabel.text;
    message.description = _titleLabel.text;
    [message setThumbImage:_naviView.appImageView.image];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = urlString;
    NSLog(@"%@", urlString);
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

// 微博分享
- (void)go2weiboshare{
    NSLog(@"新浪微博分享");
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = KREADIRECTURL;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [_webView.URL absoluteString];
    webpage.title = _naviView.naviTitleLabel.text;
    webpage.description = _naviView.naviTitleLabel.text;
    webpage.thumbnailData = [self dataWithShareImage:_appImageUrl];
    webpage.webpageUrl = [_webView.URL absoluteString];
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}



// 关闭分享页面
- (void)closeShareView{
    [UIView animateWithDuration:0.2 animations:^{
        _maskBtn.alpha = 0;
        _shareView.frame = CGRectMake(0, kWindowH, kWindowW, 200);
    } completion:^(BOOL finished) {
        [self setMaskBtn:nil];
        [self setShareView:nil];
    }];
}

// 返回
- (void) go2Back
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}


// 返回上一级
- (void)go2Forward
{
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)goHomePage{
    [[NSUserDefaults standardUserDefaults] setObject:[_webView.URL absoluteString] forKey:LOCAL_READ_READURL];
    [[NSUserDefaults standardUserDefaults] setObject:self.appImageUrl.absoluteString forKey:LOCAL_READ_APPIMAGEURL];
    [[NSUserDefaults standardUserDefaults] setObject:self.supercode forKey:LOCAL_READ_SUPERCODE];
    [self.navigationController popViewControllerAnimated:YES];
}

// 弹出分享视图
- (void)goShare{
    [self maskBtn];
    [self shareView];
    // 分享
    [UIView animateWithDuration:0.2 animations:^{
        _maskBtn.alpha = 0.3;
        _shareView.frame = CGRectMake(0, kWindowH - 200, kWindowW, 200);
    }];
}

// 弹出书签视图
- (void)goBookMarks{
    [self maskBtn];
    [self.view addSubview:_bookView];
    [_bookView upBookView];
    [UIView animateWithDuration:0.2 animations:^{
        _maskBtn.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
}

// [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
// kvo监控进度条进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (object == _bookView) {
        if ([keyPath isEqualToString:@"kvoUrl"]) {
            NSMutableArray *arr = [[FMDBManager sharedFMDBManager] getAllBookView];
            QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
            NSInteger a = [change[@"new"] integerValue];
            model = arr[a];
            [_naviView.appImageView sd_setImageWithURL:[NSURL URLWithString:model.titleData] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
            _titleLabel.text = model.titlestr;
            _supercode = model.superCode;
            _url = [NSURL URLWithString:model.url];
            _naviView.rightBtn.selected = YES;
            [self judgeRightBtnText];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
            [request addValue:[NSString loadRequestWithUrlString:_url.absoluteString] forHTTPHeaderField:@"Cookie"];
            [_webView loadRequest:request];
            
            [self maskTheWindow];
        }
    }else if (object == _naviView){
        if ([keyPath isEqualToString:@"appImageKVO"]) {     // 页面刷新
            [self.webView stopLoading];
            [self.webView reload];
        }else if ([keyPath isEqualToString:@"rightKVO"]){   // 添加书签
            [self addBookViewFMDB];
        }
    }else if (object == _webView){
        if([keyPath isEqualToString:@"estimatedProgress"]) {
            progresslayer.opacity = 1;
            //不要让进度条倒着走...有时候goback会出现这种情况
            if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
                return;
            }
            progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
            if ([change[@"new"] floatValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    progresslayer.opacity = 0;
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    progresslayer.frame = CGRectMake(0, 0, 0, 3);
                });
            }
        }else if([keyPath isEqualToString:@"title"]){
            if (object == self.webView) {
                _naviView.naviTitleLabel.text = self.webView.title;
            }
        }else if([keyPath isEqualToString:@"URL"]){
            if (object == self.webView) {
                urlString = [self.webView.URL absoluteString];
            }
            
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}

// 判断前进返回按钮的状态
- (void) barButtonEnable
{
    [self.barGoBack setUserInteractionEnabled:self.webView.canGoBack];
    if (self.webView.canGoBack) {
        self.barGoBack.alpha = 1;
        gobackLabel.alpha = 1;
    }else{
        self.barGoBack.alpha = 0.2;
        gobackLabel.alpha = 0.2;
    }
    [self.barGoForward setUserInteractionEnabled:self.webView.canGoForward];
    if (self.webView.canGoForward) {
        self.barGoForward.alpha = 1;
        goForwardLabel.alpha = 1;
    }else{
        self.barGoForward.alpha = 0.2;
        goForwardLabel.alpha = 0.2;
    }
}

#pragma mark - WKWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    // 内容开始返回后判断数据库中是否有此页的书签，更改右上角按钮状态
    NSMutableArray *arr = [[FMDBManager sharedFMDBManager] getAllBookView];
    for (int i = 0; i < arr.count; i++) {
        QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
        model = arr[i];
        NSLog(@"%@",[self.webView.URL absoluteString]);
        if ([model.url isEqualToString:[self.webView.URL absoluteString]]) {
            _naviView.rightBtn.selected = YES;
            break;
        }else{
            _naviView.rightBtn.selected = NO;
        }
    }
    [self judgeRightBtnText];
    [self barButtonEnable];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 执行一段JS代码
    NSLog(@"self.supercode  %@", self.supercode);
    [_webView evaluateJavaScript:self.supercode completionHandler:^(id _Nullable i, NSError * _Nullable error) {
        NSLog(@"Error -> %@", error);
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self barButtonEnable];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showErrorMsg:@"加载失败"];
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 判断是不是新页面
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 正在拖拽
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffset = scrollView.contentOffset.y;
    static CGFloat lastOffset;
    NSLog(@"scrollView.contentSize.height %f", scrollView.contentSize.height);
    
    if ((currentOffset <= 0) || ((scrollView.contentSize.height >= kWindowH - 104) && (currentOffset >= scrollView.contentSize.height - kWindowH - 104))) {
        return;
    }
    marginOffset = currentOffset - lastOffset;
    NSLog(@"currentOffset   %f", currentOffset);
    CGFloat tabBarY = _tabbarView.frame.origin.y;
    CGFloat navBarY = _naviView.frame.origin.y;
    CGFloat webY = _webView.frame.origin.y;
    CGFloat webH = _webView.frame.size.height;
    CGFloat bannerY = _bannersView.frame.origin.y;
    if (marginOffset < 0) { //向下滚动，显示navigationBar和TabBar。设置statusBar不透明
        tabBarY -= fabs((marginOffset));
        navBarY += fabs((marginOffset));
        webY += fabs((marginOffset));
        webH -= fabs((marginOffset * 2));
        bannerY -= fabs((marginOffset));
        if (navBarY >= 20) {//上移navBar到其顶部和屏幕顶部相同的时候，不准在下移
            tabBarY = kWindowH - 40;
            navBarY = 20;
            webY = 64;
            webH = kWindowH - 104;
            bannerY = kWindowH - 40 - _bannersView.selfHeight;
        }
        _tabbarView.frame = CGRectMake(0, tabBarY, kWindowW, 40);
        _naviView.frame = CGRectMake(0, navBarY, kWindowW, 44);
        _webView.frame = CGRectMake(0, webY, kWindowW, webH);
        _bannersView.frame = CGRectMake(0, bannerY, kWindowW, _bannersView.frame.size.height);
        
    }else{//向上滚动,隐藏navigationBar和TabBar，设置statusBar透明
        tabBarY += fabs((marginOffset));
        navBarY -= fabs((marginOffset));
        webY -= fabs((marginOffset));
        webH += fabs((marginOffset * 2));
        bannerY += fabs((marginOffset));
        if (navBarY <= -24) {
            tabBarY = kWindowH;
            navBarY = -24;
            webY = 20;
            webH = kWindowH - 20;
            bannerY = kWindowH - _bannersView.selfHeight;
        }
        _tabbarView.frame = CGRectMake(0, tabBarY, kWindowW, 40);
        _naviView.frame = CGRectMake(0, navBarY, kWindowW, 44);
        _webView.frame = CGRectMake(0, webY, kWindowW, webH);
        _bannersView.frame = CGRectMake(0, bannerY, kWindowW, _bannersView.frame.size.height);
    }
    
    lastOffset = currentOffset;
    
}

// 拖拽完了
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self regularScrollView:scrollView];
}

// 减速完了
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self regularScrollView:scrollView];
}

// 拖拽完成后固定滚动视图
- (void)regularScrollView:(UIScrollView *)scrollView
{
    CGFloat navaY = _naviView.frame.origin.y;
    
    if (navaY <= - 2 ) {//当navigationBar的Y值小于-12的时候，就隐藏两个bar
        
        [UIView animateWithDuration:0.2 animations:^{
            _tabbarView.frame = CGRectMake(0, kWindowH,  kWindowW, 40);
            _naviView.frame = CGRectMake(0, -24, kWindowW, 44);
            _webView.frame = CGRectMake(0, 20, kWindowW, kWindowH - 20);
            [_bannersView downBannersView];
            if (scrollView.contentOffset.y <= 0) {
                _webView.scrollView.contentOffset =CGPointMake(0, 0);
            }
        }];
        
        
    }else{//否则显示两个bar
        [UIView animateWithDuration:0.2 animations:^{
            _tabbarView.frame = CGRectMake(0, kWindowH - 40,  kWindowW, 40);
            _naviView.frame = CGRectMake(0, 20, kWindowW, 44);
            _webView.frame = CGRectMake(0, 64, kWindowW, kWindowH - 104);
            [_bannersView upBannersView];
        }];
    }
}


#pragma mark - MMUBannerView delegate methods

- (UIViewController *)bannerViewControllerForPresentingModalView{
    return self;
}


// 横幅成功
- (void)bannerAdsSuccess:(MMUBanners *)bannerAds{
    NSLog(@"Banner Success");
}

// 横幅失败
- (void)bannerAdsAllAdFail:(MMUBanners *)bannerAds withError:(NSError *)err{
    NSLog(@"Banner Fail");
}

// 横幅点击
- (void)bannerClick:(MMUBanners *)bannerAds{
    NSLog(@"Banner Click");
}

// 横幅展现
- (void)bannerAdsAppear:(MMUBanners *)bannerAds
{
    NSLog(@"Banner Appear");
}

// 横幅关闭
- (void)bannerClosed:(MMUBanners *)bannerAds{
    NSLog(@"Banner Close");
}

/**
 *You can get notified when the user delete the ad
 返回 YES 表示由开发者处理关闭广告事件
 返回 NO 表示由sdk处理关闭广告事件
 */
- (BOOL)dealCloseAd:(MMUBanners *)bannerAds{
    return NO;
}


#pragma mark - browserDelegate 支持平台：阿里妈妈、谷歌admob
// 浏览器将要展示
- (void)browserWillLoad{
    NSLog(@"%s",__func__);
}

// 浏览器将要消失
- (void)browserWillDismiss{
    NSLog(@"%s",__func__);
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
