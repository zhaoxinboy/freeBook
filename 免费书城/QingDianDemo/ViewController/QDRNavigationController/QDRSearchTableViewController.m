//
//  QDRSearchTableViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/19.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSearchTableViewController.h"
#import "QDRSearchTableViewCell.h"
#import "QDRWebViewController.h"
#import "QDRHomePageViewModel.h"
#import "QDRNaviTitleView.h"

@interface QDRSearchTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) QDRHomePageViewModel *homeVM;

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;

@end

@implementation QDRSearchTableViewController

- (QDRHomePageViewModel *)homeVM{
    if (!_homeVM) {
        _homeVM = [QDRHomePageViewModel new];
    }
    return _homeVM;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (QDRSearchViewModel *)searchVM{
    if (!_searchVM) {
        _searchVM = [QDRSearchViewModel new];
    }
    return _searchVM;
}

- (QDRNaviTitleView *)naviTitleView{
    if (!_naviTitleView) {
        _naviTitleView = [[QDRNaviTitleView alloc] init];
    }
    return _naviTitleView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 隐藏cell分割线
        _tableView.separatorStyle = NO;
        [_tableView registerClass:[QDRSearchTableViewCell class] forCellReuseIdentifier:@"QDRSearchTableViewController"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.naviTitleView.titleLabel.text = @"搜索结果";
    self.naviTitleView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = self.naviTitleView;
    // 左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\U0000e64a" style:UIBarButtonItemStylePlain target:self action:@selector(go2Back)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"iconfont" size:24], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:self.searchVM.SearchResultModel.data];
    NSLog(@"self.dataArr  %@", self.dataArr);
    
    [self.navigationController.navigationBar setHidden:NO];
    
    if (self.dataArr.count == 0) {
        UILabel *label = [UILabel new];
        label.text = @"无搜索结果，请返回重新输入!";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
    }else{
        [self tableView];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)go2Back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)self.dataArr.count);
    return self.dataArr.count;
}
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return APPWIDTH + 10;
}
#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QDRSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRSearchTableViewController"];
    QDRHomeAddressDataModel *model = nil;
    if (self.dataArr[indexPath.row]) {
        model = self.dataArr[indexPath.row];
    }
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]]];
    cell.titleLabel.text = model.appname;
    //    cell.addressLabel.text = model.appurl;
    
    cell.addBtn = [UIButton new];
    cell.addBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:35];
    [cell.addBtn setTitle:@"\U0000e621" forState:UIControlStateNormal];
    [cell.addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cell.addBtn.tag = indexPath.row + 10000;
    [cell.addBtn addTarget:self action:@selector(addSearchResult:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.addBtn];
    [cell.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)addSearchResult:(UIButton *)sender{
    NSInteger row = sender.tag - 10000;
    QDRHomeAddressDataModel *model = nil;
    if (self.dataArr[row]) {
        model = self.dataArr[row];
    }
    [self.searchVM postAddAppInfoToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
        
    }];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QDRHomeAddressDataModel *model = nil;
    if (self.dataArr[indexPath.row]) {
        model = self.dataArr[indexPath.row];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 添加历史记录
            [self.homeVM postAddHistoryToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
                
            }];
        });
    }
    QDRWebViewController *vc = [[QDRWebViewController alloc] initWithURL:[NSURL URLWithString:model.appurl] andTitle:@""];
    vc.appImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]];
    vc.supercode = model.supercode;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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
