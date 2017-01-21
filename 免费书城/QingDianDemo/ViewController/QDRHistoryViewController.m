//
//  QDRHistoryViewController.m
//  freeBook
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRHistoryViewController.h"
#import "QDRHistoryCollectionViewCell.h"
#import "QDRHistoryViewModel.h"
#import "QDRWebViewController.h"
#import "QDRHomePageViewModel.h"
#import "QDRNaviTitleView.h"
#import "QDRWebViewController.h"
#import "ULBCollectionViewFlowLayout.h"
#import "QDRNotHistoryView.h"

@interface QDRHistoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ULBCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) QDRNaviTitleView *naviTitleView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) QDRNotHistoryView *notView;

@property (nonatomic, strong) UILabel *readLable;

@property (nonatomic, strong) QDRHistoryViewModel *historyVM;

@property(nonatomic,strong) QDRHomePageViewModel *homeVM;  //主页模型

@end

@implementation QDRHistoryViewController

- (QDRNotHistoryView *)notView{
    if (!_notView) {
        _notView = [[QDRNotHistoryView alloc] init];
        [_notView.browseBtn addTarget:self action:@selector(goBrowse) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_notView];
        [_notView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _notView;
}

// “去浏览” 点击事件
- (void)goBrowse{
    [self.navigationController popViewControllerAnimated:YES];
}


// section背景颜色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return [UIColor whiteColor];
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        ULBCollectionViewFlowLayout *myLayout = [[ULBCollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = (kWindowW - 60) / 2;
        //设置元素大小
        CGFloat height = QDR_HISTORY_HEIGHT;
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(38, 15, 38, 15);
        myLayout.minimumInteritemSpacing = 30;
        myLayout.minimumLineSpacing = 30;
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //集合视图初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        //注册单元格Cell
        [_collectionView registerClass:[QDRHistoryCollectionViewCell class] forCellWithReuseIdentifier:@"QDRHistoryCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.alwaysBounceVertical = YES;
        
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //禁用滚动
        //        _addressCollectionView.scrollEnabled = NO;
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyVM.rowNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(self.historyVM.rowNumber > 0){ return 1; }
    else{ return 0; }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDRHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRHistoryCollectionViewCell" forIndexPath:indexPath];
    if (self.historyVM.rowNumber != 0) {
        [cell.imageView sd_setImageWithURL:[self.historyVM imageURLForRow:indexPath.row]];
        cell.titleLabel.text = [self.historyVM appNameForRow:indexPath.row];
        
    }
    return cell;
}



//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model) {
        [self setModel:nil];
    }
    self.model = self.historyVM.dataArr[indexPath.row];
    
    NSInteger appid = [(NSNumber *)self.model.appID integerValue];
    NSLog(@"%ld", (long)appid);
    // 添加历史记录
    [self.homeVM postAddHistoryToUserFromNetWithUrlId:appid andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
    }];
    
    QDRWebViewController *webvc = [[QDRWebViewController alloc] initWithURL:[NSURL URLWithString:[self.historyVM addressURLForRow:indexPath.row]] andTitle:@""];
    webvc.appImageUrl = [self.historyVM imageURLForRow:indexPath.row];
    webvc.supercode = [self.historyVM superCodeForRow:indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webvc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 组头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 15);
    
}

- (QDRNaviTitleView *)naviTitleView{
    if (!_naviTitleView) {
        _naviTitleView = [[QDRNaviTitleView alloc] init];
    }
    return _naviTitleView;
}

- (QDRHomePageViewModel *)homeVM
{
    if (!_homeVM) {
        _homeVM = [QDRHomePageViewModel new];
    }
    return _homeVM;
}

- (QDRHistoryViewModel *)historyVM
{
    if (!_historyVM) {
        _historyVM = [QDRHistoryViewModel new];
    }
    return _historyVM;
}


- (void)getNetWorking
{
    __weak typeof (self) wself = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID]) {
        [self.historyVM getHistoryByUseridWithUserid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
            if (wself.historyVM.rowNumber > 0) {
                //                    [wself notView];
                [wself setNotView:nil];
                // 回到主线程刷新UI
                [wself.collectionView reloadData];
            }else{
                [wself notView];
                //                    [wself setNotView:nil];
                //                    // 回到主线程刷新UI
                //                    [wself.collectionView reloadData];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self collectionView];
    [self getNetWorking];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)setNavigationController
{
    self.naviTitleView.titleLabel.text = @"浏览记录";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(227, 227, 227);
    
    [self setNavigationController];
    
    // Do any additional setup after loading the view.
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
