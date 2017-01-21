//
//  QDRUserFeedbackViewController.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRUserFeedbackViewController.h"
#import "QDRUserFeedbackTableView.h"
#import "QDRUserFeedbackViewModel.h"
#import "QDRNaviTitleView.h"


@interface QDRUserFeedbackViewController ()

@property (nonatomic, strong) QDRUserFeedbackTableView *QDRUserTableView;

@property (nonatomic, strong) QDRUserFeedbackViewModel *feedVM;

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;

@property (nonatomic, strong) UIButton *submitBtn;      // 提交按钮

@end

@implementation QDRUserFeedbackViewController

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [_submitBtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.backgroundColor = kRGBColor(255, 75, 59);
        _submitBtn.userInteractionEnabled = NO;
        _submitBtn.alpha = 0.6;
        [self.view addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    return _submitBtn;
}



//  登录按钮普通状态下的背景色及点击事件
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = kRGBColor(255, 75, 59);
    
     __weak typeof (self) wself = self;
    [self.feedVM postResetPasswordWithUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] content:self.QDRUserTableView.adviceTextView.text NetCompleteHandle:^(NSError *error) {
        if ([wself.feedVM.isSuccess isEqualToString:@"success"]) {
            [wself showSuccessMsg:@"反馈成功，我们会尽快解决"];
        }else{
            [wself showErrorMsg:@"反馈失败，请检查网络"];
        }
        
    }];
    
    
}

//  登录按钮高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor grayColor];
}

- (QDRNaviTitleView *)naviTitleView{
    if (!_naviTitleView) {
        _naviTitleView = [[QDRNaviTitleView alloc] init];
    }
    return _naviTitleView;
}

- (QDRUserFeedbackViewModel *)feedVM
{
    if (!_feedVM) {
        _feedVM = [QDRUserFeedbackViewModel new];
    }
    return _feedVM;
}

- (QDRUserFeedbackTableView *)QDRUserTableView
{
    if (!_QDRUserTableView) {
        _QDRUserTableView = [[QDRUserFeedbackTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_QDRUserTableView];
        [_QDRUserTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _QDRUserTableView;
}

- (void)dealloc
{
    [self.QDRUserTableView removeObserver:self forKeyPath:@"KVOsubNum" context:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.QDRUserTableView addObserver:self forKeyPath:@"KVOsubNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    [self setNavigationController];
    
    [self QDRUserTableView];
    
    [self submitBtn];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationController{
    self.naviTitleView.titleLabel.text = @"意见反馈";
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
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == self.QDRUserTableView) {
        if([keyPath isEqualToString:@"KVOsubNum"]){
            NSLog(@"%@", [change valueForKey:@"new"]);
            if ([[change valueForKey:@"new"] integerValue] == 0) {
                _submitBtn.userInteractionEnabled = YES;
                _submitBtn.alpha = 1;
            }else if ([[change valueForKey:@"new"] integerValue] == 1){
                _submitBtn.userInteractionEnabled = NO;
                _submitBtn.alpha = 0.6;
            }
            //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
            NSLog(@"\noldKVOnum:%@ newKVOnum:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
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
