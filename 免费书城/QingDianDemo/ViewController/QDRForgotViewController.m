//
//  QDRForgotViewController.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/1.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRForgotViewController.h"
#import "QDRForgotTableView.h"
#import "QDRRegisteredViewController.h"
#import "QDRUserFeedbackViewController.h"
#import "QDRForgetPassWordViewModel.h"
#import "QDRNaviTitleView.h"

@interface QDRForgotViewController ()

@property (nonatomic, strong) QDRForgotTableView *QDRFTableView;

@property (nonatomic, strong) QDRForgetPassWordViewModel *forgetVM;

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;

@end

@implementation QDRForgotViewController

- (QDRNaviTitleView *)naviTitleView{
    if (!_naviTitleView) {
        _naviTitleView = [[QDRNaviTitleView alloc] init];
    }
    return _naviTitleView;
}

- (QDRForgetPassWordViewModel *)forgetVM
{
    if (!_forgetVM) {
        _forgetVM = [QDRForgetPassWordViewModel new];
    }
    return _forgetVM;
}

- (QDRForgotTableView *)QDRFTableView
{
    if (!_QDRFTableView) {
        _QDRFTableView = [[QDRForgotTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_QDRFTableView];
        [_QDRFTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _QDRFTableView;
}

- (void)dealloc
{
    /* 移除KVO */
    [self.QDRFTableView removeObserver:self forKeyPath:@"KVOnum" context:nil];
    [self.QDRFTableView removeObserver:self forKeyPath:@"KVOFeedNum" context:nil];
    [self.QDRFTableView removeObserver:self forKeyPath:@"KVOlogin" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kRGBColor(236, 236, 236);
    
    [self.navigationController.navigationBar setHidden:NO];
    
    // 注册KVO监听是否跳转注册页面
    [self.QDRFTableView addObserver:self forKeyPath:@"KVOnum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.QDRFTableView addObserver:self forKeyPath:@"KVOFeedNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.QDRFTableView addObserver:self forKeyPath:@"KVOlogin" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    //导航条内容
    [self setNavigationController];
    
    [self QDRFTableView];

    // Do any additional setup after loading the view.
}

/* KVO调用方法 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    __weak QDRForgotViewController *wself = self;
    if (object == self.QDRFTableView) {
        if([keyPath isEqualToString:@"KVOnum"])
        {
            // 响应变化处理 注册
            QDRRegisteredViewController *rvc = [[QDRRegisteredViewController alloc] init];
            [self.navigationController pushViewController:rvc animated:YES];
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }else if([keyPath isEqualToString:@"KVOFeedNum"]){
            // 响应变化处理   用户反馈
            QDRUserFeedbackViewController *uvc = [[QDRUserFeedbackViewController alloc] init];
            [self.navigationController pushViewController:uvc animated:YES];
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }else if ([keyPath isEqualToString:@"KVOlogin"]){
            // 响应变化处理   登录
            [self.forgetVM postResetPasswordWithPassWord:self.QDRFTableView.passWordTF.text mobile:self.QDRFTableView.phoneTF.text verfycode:self.QDRFTableView.verificationCodeTF.text codeid:wself.QDRFTableView.verificationCodeStr NetCompleteHandle:^(NSError *error) {
                if ([wself.forgetVM.status isEqualToString:@"0"]) {
                    [wself showSuccessMsg:@"密码修改成功"];
                    [wself.navigationController popViewControllerAnimated:YES];
                }else{
                    [wself showErrorMsg:@"密码修改失败"];
                }
            }];
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }
    }
    
}

- (void)setNavigationController
{
    self.naviTitleView.titleLabel.text = @"找回密码";
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

//内存警告时
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
