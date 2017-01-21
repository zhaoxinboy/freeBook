//
//  QDRWebWeViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRWebWeViewController.h"
#import <WebKit/WebKit.h>

@interface QDRWebWeViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSString *mytitle;

@end

@implementation QDRWebWeViewController{
    CALayer *progresslayer;  // 网页进度条
}

- (id)initWithURL:(NSURL *)url andTitle:(NSString *)title{
    if (self = [super init]) {
        self.url = url;
        self.mytitle = title;
    }
    return self;
}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
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
    }
    return _webView;
}

- (void)dealloc
{
    _webView.navigationDelegate = nil;
    _webView.UIDelegate = nil;
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
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
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.mytitle;
    
    [self.navigationController.navigationBar setHidden:NO];
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e64a" style:UIBarButtonItemStylePlain target:self action:@selector(go2Back)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"iconfont" size:24], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [self webView];
    // Do any additional setup after loading the view.
}

- (void)go2Back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
