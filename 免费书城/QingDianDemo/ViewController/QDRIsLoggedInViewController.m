//
//  QDRIsLoggedInViewController.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRIsLoggedInViewController.h"
#import "QDRIsLoggedInTableView.h"
#import "QDRUserFeedbackViewController.h"
#import "QDRLoginViewModel.h"

@interface QDRIsLoggedInViewController ()

@property (nonatomic, strong) QDRIsLoggedInTableView *isloggedinTableView;

@property (nonatomic, strong) QDRLoginViewModel *loginVm;

@end

@implementation QDRIsLoggedInViewController

- (QDRLoginViewModel *)loginVm
{
    if (!_loginVm) {
        _loginVm = [QDRLoginViewModel new];
    }
    return _loginVm;
}

// 取消所有响应者  [view endEditing:YES];

- (QDRIsLoggedInTableView *)isloggedinTableView
{
    if (!_isloggedinTableView) {
        _isloggedinTableView = [[QDRIsLoggedInTableView  alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_isloggedinTableView];
        [_isloggedinTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _isloggedinTableView;
}

- (void)dealloc{
    /* 移除KVO */
    [self.isloggedinTableView removeObserver:self forKeyPath:@"KVOFeedNum" context:nil];
    [self.isloggedinTableView removeObserver:self forKeyPath:@"KVOLogOutNum" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    NSLog(@"[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]  %@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]);
    
    __weak QDRIsLoggedInViewController* wself = self;
    [self.loginVm getUserInfoByUserid:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] NetCompleteHandle:^(NSError *error) {
        wself.isloggedinTableView.phoneLabel.text = [NSString stringWithFormat:@"手机号:%@", wself.loginVm.isLoginModel.mobile];
    }];
    
    // 注册KVO监听  注册页面  用户反馈
    [self.isloggedinTableView addObserver:self forKeyPath:@"KVOFeedNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    [self.isloggedinTableView addObserver:self forKeyPath:@"KVOLogOutNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self setNavigationController];
    
    [self isloggedinTableView];
    // Do any additional setup after loading the view.
}

- (void)setNavigationController
{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e64a" style:UIBarButtonItemStylePlain target:self action:@selector(go2Back)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"iconfont" size:24], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)go2Back
{
    [self.navigationController popViewControllerAnimated:YES];
}


/* KVO调用方法 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.isloggedinTableView) {
        if([keyPath isEqualToString:@"KVOFeedNum"]){
            // 响应变化处理  用户反馈
            QDRUserFeedbackViewController *uvc = [[QDRUserFeedbackViewController alloc] init];
            [self.navigationController pushViewController:uvc animated:YES];
            
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        }else if ([keyPath isEqualToString:@"KVOLogOutNum"]){
            [self.navigationController popToRootViewControllerAnimated:YES];
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
