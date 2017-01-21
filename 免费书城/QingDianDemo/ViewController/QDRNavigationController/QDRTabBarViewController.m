//
//  QDRTabBarViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/7.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRTabBarViewController.h"
#import "QDRNavigationController.h"
#import "QDRViewController.h"
#import "QDRTabBar.h"
#import "QDRMineViewController.h"
#import "FMDBManager.h"
#import "QDRBookViewModel.h"
#import "QDRWebViewController.h"
#import "QDRSkinViewModel.h"

@interface QDRTabBarViewController ()<QDRTabBarDelegate, deleteUrlDelegate>

@property (nonatomic, strong) QDRTabBar *qdrTabbar;

@end

@implementation QDRTabBarViewController

#pragma mark - SXTTabbarDelegate

- (void)tabbar:(QDRTabBar *)tabbar clickIndex:(QDRItemType)idx {
    
    if (idx != QDRItemTypeLaunch) {
        //当前tabbar的索引
        self.selectedIndex = idx - QDRItemTypeLive;
        return;
    }
    
    [self.markBtn upMark];
    [self.bookView upBookView];
    
    NSLog(@"%lu", (unsigned long)self.selectedIndex);
    NSLog(@"主页书签");
}

// 删除书签
- (void)deleteUrlwithString:(NSString *)urlString{
    NSLog(@"删除书签（首页）");
}

// 书签
- (QDRBookMarkView *)bookView{
    if (!_bookView) {
        _bookView = [[QDRBookMarkView alloc] initWithFrame:CGRectMake(0, kWindowH, kWindowW, 320)];
        _bookView.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_bookView];
        // 添加KVO监听
        [self.bookView addObserver:self forKeyPath:@"kvoUrl" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _bookView;
}

- (QDRMarkButton *)markBtn{
    if (!_markBtn) {
        _markBtn = [[QDRMarkButton alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_markBtn];
        [_markBtn addTarget:self action:@selector(ClickMarkBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _markBtn;
}

// 点击遮罩层
- (void)ClickMarkBtn{
    [_markBtn downMark];
    [_bookView downBookView];
}


#pragma mark - getters and setters

- (QDRTabBar *)qdrTabbar {
    
    if (!_qdrTabbar) {
        _qdrTabbar = [[QDRTabBar alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 49)];
        _qdrTabbar.delegate = self;
    }
    return _qdrTabbar;
}

- (void)dealloc{
    [_bookView removeObserver:self forKeyPath:@"kvoUrl"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载所有视图控制器
    [self configViewControllers];
    
    //加载自定义tabbar
    [self.tabBar addSubview:self.qdrTabbar];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - privte methods

- (void)configViewControllers {
    
    NSMutableArray * viewControlNames = [NSMutableArray arrayWithArray:@[@"QDRViewController",@"QDRMineViewController"]];
    
    for (NSUInteger i = 0; i < viewControlNames.count; i ++) {
        
        NSString * controllerName = viewControlNames[i];
        
        UIViewController * vc = [[NSClassFromString(controllerName) alloc] init];
        
        QDRNavigationController * nav = [[QDRNavigationController alloc] initWithRootViewController:vc];
        
        [viewControlNames replaceObjectAtIndex:i withObject:nav];
    }
    
    self.viewControllers = viewControlNames;
    
}


// KVO事件
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == _bookView) {
        if ([keyPath isEqualToString:@"kvoUrl"]) {
            [_markBtn downMark];
            [_bookView downBookView];
            if (self.selectedIndex == 0) {
                self.oneKVO = [change[@"new"] integerValue];
            }else{
                self.twoKVO = [change[@"new"] integerValue];
            }
        }
    }
    
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
