//
//  QDRSetUpViewController.m
//  freeBook
//
//  Created by 杨兆欣 on 2016/11/11.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSetUpViewController.h"
#import "QDRVersionViewController.h"
#import "QDRNaviTitleView.h"
#import "QDRSetUpTableViewCell.h"
#import "QDRForgotViewController.h"
#import "QDRClearCacheView.h"

@interface QDRSetUpViewController ()<UITableViewDataSource, UITableViewDelegate, removeDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;

@property (nonatomic, strong) UIButton *logOutBtn;

@property (nonatomic, strong) QDRClearCacheView *clearView;
@end

@implementation QDRSetUpViewController{
    NSIndexPath *SdIndexPath;  // 清理缓存所选中的位置
}

- (QDRClearCacheView *)clearView{
    if (!_clearView) {
        _clearView = [[QDRClearCacheView alloc] initWithTarget:self];
        [_clearView.determineBtn addTarget:self action:@selector(cleanSD) forControlEvents:UIControlEventTouchUpInside];
        _clearView.delegate = self;
    }
    return _clearView;
}

- (void)cleanSD{
    [_clearView closeSelf];
    [self sdCleanCache];
    QDRSetUpTableViewCell *cell = (QDRSetUpTableViewCell *)[self.tableView cellForRowAtIndexPath:SdIndexPath];
    cell.rightLabel.text = [NSString stringWithFormat:@"%0.2f M", [self sdFolderSize]];
}

- (void)removeClearView{
    [self setClearView:nil];
}

- (UIButton *)logOutBtn{
    if (!_logOutBtn) {
        _logOutBtn = [UIButton new];
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _logOutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logOutBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [_logOutBtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
        _logOutBtn.backgroundColor = kRGBColor(255, 75, 59);
        [self.view addSubview:_logOutBtn];
        [_logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    return _logOutBtn;
}

//  登录按钮普通状态下的背景色及点击事件
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = kRGBColor(186, 174, 174);
    
    // 友盟退出登录
    [MobClick profileSignOff];
    
    // 登录状态设为100表示退出登录
    [[NSUserDefaults standardUserDefaults] setObject:NOLOGIN forKey:LOCAL_READ_ISLOGIN];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self showSuccessMsg:@"退出成功!"];
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = kRGBColor(227, 227, 227);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 隐藏cell分割线
        _tableView.separatorStyle = NO;
        [_tableView registerClass:[QDRSetUpTableViewCell class] forCellReuseIdentifier:@"QDRSetUpViewController"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (void)setNavigationController
{
    [self.navigationController.navigationBar setHidden:NO];
    self.naviTitleView.titleLabel.text = @"设置";
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavigationController];
    
    [self tableView];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_ISLOGIN] isEqualToString:NOLOGIN]) {
        [self logOutBtn];
    }
    
    [self clearView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDRSetUpTableViewCell *cell = (QDRSetUpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QDRSetUpViewController"];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        cell.leftLabel.text = @"清除缓存";
        cell.rightLabel.text = [NSString stringWithFormat:@"%0.2f M", [self sdFolderSize]];
    }
    //    else if (indexPath.section == 1){
    //        cell.leftLabel.text = @"找回密码";
    //        cell.rightLabel.text = @"\U0000e64d";
    //    }
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SdIndexPath = indexPath;
        [self clearView];
        [_clearView openSelf];
    }
    //    if (indexPath.section == 1) {
    //        self.hidesBottomBarWhenPushed = YES;
    //        QDRForgotViewController *vc = [[QDRForgotViewController alloc] init];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
}

// 表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
