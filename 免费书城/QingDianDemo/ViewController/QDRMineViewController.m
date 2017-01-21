//
//  QDRMineViewController.m
//  freeBook
//
//  Created by 杨兆欣 on 2016/12/8.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRMineViewController.h"
#import "QDRMineTableViewCell.h"
#import "QDRMineTableHeaderView.h"
#import "QDRHistoryViewController.h"
#import "QDRAboutUsViewController.h"
#import "QDRUserFeedbackViewController.h"
#import "QDRRegisteredViewController.h"
#import "QDRLoginViewController.h"
#import "QDRSetUpViewController.h"
#import "FMDBManager.h"
#import "QDRBookViewModel.h"
#import "QDRWebViewController.h"
#import "QDRLoginViewModel.h"

@interface QDRMineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QDRMineTableHeaderView *headerView;

@property (nonatomic, strong) QDRLoginViewModel *loginVm;

@end

@implementation QDRMineViewController

- (QDRLoginViewModel *)loginVm
{
    if (!_loginVm) {
        _loginVm = [QDRLoginViewModel new];
    }
    return _loginVm;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRGBColor(235, 235, 235);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[QDRMineTableViewCell class] forCellReuseIdentifier:@"QDRMineTableViewCell"];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"QDRMineViewController"];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //去掉多余的cell
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = NO;
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SKIN];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
        _tableView.backgroundView = imageView;
    }
    return _tableView;
}

// KVO事件
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.tabBarController){
        if ([keyPath isEqualToString:@"twoKVO"]) {
            NSMutableArray *arr = [[FMDBManager sharedFMDBManager] getAllBookView];
            QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
            NSInteger a = [change[@"new"] integerValue];
            model = arr[a];
            QDRWebViewController *webvc = [[QDRWebViewController alloc] initWithURL:[NSURL URLWithString:model.url] andTitle:@""];
            //            [webvc setValue:@"appImageView.image" forKey:image];
            webvc.appImageUrl = [NSURL URLWithString:model.titleData];
            webvc.supercode = model.superCode;
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webvc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SKIN];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
        _tableView.backgroundView = imageView;
    }
    if (_headerView) {
        // 登录状态
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_ISLOGIN] isEqualToString:NOLOGIN]) {
            __weak typeof (self) wself = self;
            [self.loginVm getUserInfoByUserid:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] NetCompleteHandle:^(NSError *error) {
                if (wself.loginVm.isLoginModel.username) {
                    [_headerView.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_ISLOGIN] isEqualToString:@"1"]) {
                        [_headerView.loginBtn setTitle:[NSString stringWithFormat:@"账号:%@", wself.loginVm.isLoginModel.username] forState:UIControlStateNormal];
                    }else{
                        [_headerView.loginBtn setTitle:[NSString stringWithFormat:@"昵称:%@", wself.loginVm.isLoginModel.nickname] forState:UIControlStateNormal];
                    }
                    
                }else{
                    
                }
            }];
        }else{
            [_headerView.loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [_headerView.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        }
    }
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)dealloc{
    [self.tabBarController removeObserver:self forKeyPath:@"twoKVO" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController addObserver:self forKeyPath:@"twoKVO" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    self.automaticallyAdjustsScrollViewInsets = false; // 解决滚动视图初始点为-20的问题
    
    [self tableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? 3 : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDRMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRMineTableViewCell"];
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.titleImageView.image = [UIImage imageNamed:@"me_icon_record"];
        cell.titleLabel.text = @"浏览记录";
        cell.rightLabel.text = @"\U0000e64d";
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.titleImageView.image = [UIImage imageNamed:@"me_icon_feedback"];
            cell.titleLabel.text = @"用户反馈";
            cell.rightLabel.text = @"\U0000e64d";
        }else if (indexPath.row == 1){
            cell.titleImageView.image = [UIImage imageNamed:@"me_icon_we"];
            cell.titleLabel.text = @"免责声明";
            cell.rightLabel.text = @"\U0000e64d";
        }else{
            cell.titleImageView.image = [UIImage imageNamed:@"me_icon_version"];
            cell.titleLabel.text = @"版本";
            cell.rightLabel.font = [UIFont systemFontOfSize:12];
            cell.rightLabel.textColor = kRGBColor(153, 153, 153);
            cell.rightLabel.text = [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        }
    }else{
        cell.titleImageView.image = [UIImage imageNamed:@"me_icon_set"];
        cell.titleLabel.text = @"设置";
        cell.rightLabel.text = @"\U0000e64d";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 浏览记录
        self.hidesBottomBarWhenPushed = YES;
        QDRHistoryViewController *hvc = [[QDRHistoryViewController alloc] init];
        [self.navigationController pushViewController:hvc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 用户反馈
            self.hidesBottomBarWhenPushed = YES;
            QDRUserFeedbackViewController *userVC = [[QDRUserFeedbackViewController alloc] init];
            [self.navigationController pushViewController:userVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if(indexPath.row == 1){
            // 免责声明
            self.hidesBottomBarWhenPushed = YES;
            QDRAboutUsViewController *vc = [[QDRAboutUsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else if (indexPath.section == 2 && indexPath.row == 0){
        // 设置
        self.hidesBottomBarWhenPushed = YES;
        QDRSetUpViewController *vc = [[QDRSetUpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    view.tintColor = [UIColor clearColor];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 84 : 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QDRMineViewController"];
    
    //    if (!_headerView) {
    //        _headerView = [[QDRMineTableHeaderView alloc] initWithFrame:CGRectZero];
    //        [headerView addSubview:_headerView];
    //        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.top.mas_equalTo(0);
    //            make.size.mas_equalTo(CGSizeMake(kWindowW, QDR_HOME_HEADER_HEIGHT));
    //        }];
    //        [_headerView.loginBtn addTarget:self  action:@selector(aboutLogin) forControlEvents:UIControlEventTouchUpInside];
    //
    //        // 登录状态
    //        if (![[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_ISLOGIN] isEqualToString:NOLOGIN]) {
    //            __weak typeof (self) wself = self;
    //            [self.loginVm getUserInfoByUserid:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] NetCompleteHandle:^(NSError *error) {
    //                if (wself.loginVm.isLoginModel.username) {
    //                    [_headerView.loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_ISLOGIN] isEqualToString:@"1"]) {
    //                        [_headerView.loginBtn setTitle:[NSString stringWithFormat:@"账号:%@", wself.loginVm.isLoginModel.username] forState:UIControlStateNormal];
    //                    }else{
    //                        [_headerView.loginBtn setTitle:[NSString stringWithFormat:@"昵称:%@", wself.loginVm.isLoginModel.nickname] forState:UIControlStateNormal];
    //                    }
    //                }else{
    //
    //                }
    //            }];
    //        }else{
    //            [_headerView.loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //            [_headerView.loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    //        }
    //    }
    
    return section == 0 ? headerView : nil;
}

// 登录相关
- (void)aboutLogin{
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_ISLOGIN] isEqualToString:NOLOGIN]) {
        NSLog(@"已登录过，不响应跳转登录界面事件");
    }else{
        self.hidesBottomBarWhenPushed = YES;
        QDRLoginViewController *vc = [[QDRLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
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
