//
//  QDRVersionViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/29.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRVersionViewController.h"

@interface QDRVersionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation QDRVersionViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kRGBColor(227, 227, 227);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRAboutUsViewController"];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kWindowW, 0, 0)];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _tableView;
}

- (void)go2Back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_HEADERURL]]];
    }
    return _headerImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e64a" style:UIBarButtonItemStylePlain target:self action:@selector(go2Back)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"iconfont" size:24], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    QDRLabel *titleLabel = [[QDRLabel alloc] init];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 0, 100, 40);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"\U0000e603 最新版本";
    self.navigationItem.titleView = titleLabel;
    
    
    [self headerImageView];
    [self tableView];
    // Do any additional setup after loading the view.
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRAboutUsViewController" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_headerImageView];
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }else{
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"当前版本 %@", [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 100 : 44;
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
