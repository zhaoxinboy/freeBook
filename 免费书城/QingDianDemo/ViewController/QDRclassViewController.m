//
//  QDRclassViewController.m
//  freeBook
//
//  Created by 杨兆欣 on 2016/11/14.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRclassViewController.h"
#import "QDRLoginCollectionViewCell.h"
#import "QDRSearchViewModel.h"
#import "QDRWebViewController.h"
#import "QDRHomePageViewModel.h"

@interface QDRclassViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic, strong) QDRSearchViewModel *searchVM;

@property (nonatomic, strong) UICollectionView *collectionView;      //网址

@end

@implementation QDRclassViewController{
    UIView *promptView;     //提示框
    UILabel *promptLabel;       //提示框文字
}

- (QDRSearchViewModel *)searchVM
{
    if (!_searchVM) {
        _searchVM = [QDRSearchViewModel new];
    }
    return _searchVM;
}

- (QDRHomePageViewModel *)homeVM
{
    if (!_homeVM) {
        _homeVM = [QDRHomePageViewModel new];
    }
    return _homeVM;
}

#pragma mark - lazyInstances
- (UICollectionView *)collectionView{
    if(_collectionView == nil) {
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = APPWIDTH;
        //    220 * 365 宽*高
        //设置元素大小
        CGFloat height = width + 25;
        //        CGFloat height = width * 250.0/220.0;
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
        myLayout.minimumInteritemSpacing = 30;
        myLayout.minimumLineSpacing = 30;
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //集合视图初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        //注册单元格Cell
        [_collectionView registerClass:[QDRLoginCollectionViewCell class] forCellWithReuseIdentifier:@"QDRclassViewController"];
        //表头视图
        //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QDRclassViewController"];
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
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-80);
        }];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 关闭导航透明度
    self.navigationController.navigationBar.translucent = NO;
    
    // 去除导航下方分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    
    
    // 导航标题
    UIView *titleView = [UIView new];
    titleView.frame = CGRectMake(0, 0, 100, 40);
    UILabel *label = [UILabel new];
    label.text = @"导航分类";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [titleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.navigationItem.titleView = titleView;
    //    label.text = [self.homeVM classTitleForRow:_numRow];
    label.text = @"图书";
    
    //网络请求数据
    __weak typeof (self) wself = self;
    [self.homeVM getAllCategoryApps:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
        for (int i = 0; i < wself.homeVM.classRowNumber; i++) {
            if ([[wself.homeVM classTitleForRow:i] isEqualToString:@"图书"]) {
                wself.numRow = i;
            }
        }
        [wself.homeVM  classNumForRow:_numRow];
        [wself collectionView];
        
        //创建长按手势监听
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizerCell:)];
        longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [wself.collectionView addGestureRecognizer:longPress];
    }];
    
    UIButton *closeBtn = [UIButton new];
    closeBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:30];
    [closeBtn setTitle:@"\U0000e6cc" forState:UIControlStateNormal];
    [closeBtn setTitleColor:kRGBColor(150, 150, 150) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)longPressGestureRecognizerCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        // 找到当前的cell
        QDRLoginCollectionViewCell *cell = (QDRLoginCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        // 定义cell的时候btn是隐藏的, 在这里设置为NO
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        if (indexPath == nil) {
            NSLog(@"空");
        }else{
            if (cell.addAppLabel.hidden == YES) {
                [self.searchVM postAddAppInfoToUserFromNetWithUrlId:[self.homeVM classiDataurlIDForRow:indexPath.row] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
                    //添加APP
                    cell.addAppLabel.hidden = NO;
                    [self addPromptViewWithTitle:[NSString stringWithFormat:@"已将\"%@\"添加到主页面", cell.titleLable.text]];
                    //打印添加
                    NSLog(@"添加成功");
                }];
            }else{
                [self addPromptViewWithTitle:@"不可重复添加"];
            }
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.homeVM  classNumForRow:_numRow];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDRLoginCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRclassViewController" forIndexPath:indexPath];
    [cell imgView];
    [cell titleLable];
    if ([self.homeVM  classNumForRow:_numRow]) {
        [cell.imgView sd_setImageWithURL:[self.homeVM classiDataimageURLForRow:indexPath.row]];
        cell.titleLable.text = [self.homeVM classiDataTitleForRow:indexPath.row];
        if ([[self.homeVM classiDataIscollectedForRow:indexPath.row] isEqualToString:@"1"]) {
            cell.addAppLabel.hidden = NO;
        }
    }
    return cell;
}



//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 添加历史记录
        [self.homeVM postAddHistoryToUserFromNetWithUrlId:[self.homeVM classiDataurlIDForRow:indexPath.row] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
            
        }];
    });
    QDRWebViewController *wvc = [[QDRWebViewController alloc] initWithURL:[self.homeVM classiDataaddressURLForRow:indexPath.row] andTitle:@""];
    wvc.appImageUrl = [self.homeVM classiDataimageURLForRow:indexPath.row];
    wvc.supercode = [self.homeVM classiDataSuperCodeForRow:indexPath.row];
    [self.navigationController pushViewController:wvc animated:YES];
    
    
}

//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 提示框
- (void)addPromptViewWithTitle:(NSString *)title{
    promptView = [UIView new];
    promptView.backgroundColor = [UIColor blackColor];
    promptView.alpha = 0.8;
    promptView.layer.masksToBounds = YES;
    promptView.layer.cornerRadius = 10;
    [self.navigationItem.titleView addSubview:promptView];
    [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    promptLabel = [UILabel new];
    promptLabel.text = title;
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:12];
    [promptView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [UIView animateWithDuration:1.5 animations:^{
        promptView.alpha = 0;
    } completion:^(BOOL finished) {
        promptLabel = nil;
        promptView = nil;
    }];
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
