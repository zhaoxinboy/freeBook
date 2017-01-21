//
//  QDRRegisteredViewController.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRRegisteredViewController.h"
#import "QDRRegisteredTableView.h"
#import "QDRWebWeViewController.h"
#import "QDRUserFeedbackViewController.h"
#import "QDRRegisteredViewModel.h"
#import "QDRNaviTitleView.h"

@interface QDRRegisteredViewController ()

@property (nonatomic, strong) QDRRegisteredTableView *registeredTableView;

@property (nonatomic, strong) QDRRegisteredViewModel *registeredVM;

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;

@end

@implementation QDRRegisteredViewController

- (QDRNaviTitleView *)naviTitleView{
    if (!_naviTitleView) {
        _naviTitleView = [[QDRNaviTitleView alloc] init];
    }
    return _naviTitleView;
}

- (QDRRegisteredViewModel *)registeredVM
{
    if (!_registeredVM) {
        _registeredVM = [QDRRegisteredViewModel new];
    }
    return _registeredVM;
}

- (QDRRegisteredTableView *)registeredTableView
{
    if (!_registeredTableView) {
        _registeredTableView = [[QDRRegisteredTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_registeredTableView];
        [_registeredTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _registeredTableView;
}

- (void)dealloc
{
    /* 移除KVO */
    [self.registeredTableView removeObserver:self forKeyPath:@"KVOreadNum" context:nil];
    [self.registeredTableView removeObserver:self forKeyPath:@"KVOlogin" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(236, 236, 236);
    
    [self.navigationController.navigationBar setHidden:NO];
    
    // 注册KVO监听  注册页面  用户反馈
    [self.registeredTableView addObserver:self forKeyPath:@"KVOreadNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.registeredTableView addObserver:self forKeyPath:@"KVOlogin" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self setNavigationController];
    
    [self registeredTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)setNavigationController
{
    self.naviTitleView.titleLabel.text = @"注册";
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

/* KVO调用方法 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    __weak QDRRegisteredViewController* wself = self;
    if (object == self.registeredTableView) {
        if([keyPath isEqualToString:@"KVOreadNum"])
        {
            
            // 响应变化处理  条款
            QDRWebWeViewController *wvc = [[QDRWebWeViewController alloc] initWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_LEGAL]] andTitle:@"网络条款"];
            [self.navigationController pushViewController:wvc animated:YES];
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }else if([keyPath isEqualToString:@"KVOlogin"]){ //相应登录
            [self.registeredVM postDataFromWithUserName:self.registeredTableView.phoneTF.text passWord:self.registeredTableView.passWordTF.text mobile:self.registeredTableView.phoneTF.text verfycode:self.registeredTableView.verificationCodeTF.text serialnumber:LOCAL_READ_UUID codeid:wself.registeredTableView.verificationCodeStr NetCompleteHandle:^(NSError *error) {
                if ([wself.registeredVM.status isEqualToString:@"0"]) {
                    [wself showSuccessMsg:@"注册成功"];
                    [wself.navigationController popViewControllerAnimated:YES];
                }
            }];
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }
    }
    
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
