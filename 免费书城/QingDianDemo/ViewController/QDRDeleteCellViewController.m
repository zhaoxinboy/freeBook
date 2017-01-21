//
//  QDRDeleteCellViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/18.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRDeleteCellViewController.h"
#import "QDRSearchViewModel.h"
#import "QDRLoginCollectionViewCell.h"

@interface QDRDeleteCellViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) QDRSearchViewModel *searchVM;  // 搜索模型，用于删除

@property (nonatomic, strong) UICollectionView *collectionView;      //网址

@end

@implementation QDRDeleteCellViewController

- (QDRHomePageViewModel *)homeVM
{
    if (!_homeVM) {
        _homeVM = [QDRHomePageViewModel new];
    }
    return _homeVM;
}


- (QDRSearchViewModel *)searchVM{
    if (!_searchVM) {
        _searchVM = [QDRSearchViewModel new];
    }
    return _searchVM;
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
        [_collectionView registerClass:[QDRLoginCollectionViewCell class] forCellWithReuseIdentifier:@"QDRDeleteCellViewController"];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.alwaysBounceVertical = YES;
        
        _collectionView.showsVerticalScrollIndicator = FALSE;
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //禁用滚动
        //        _addressCollectionView.scrollEnabled = NO;
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
        }];
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBColor(243, 243, 243);
    
    UILabel *title = [UILabel new];
    title.text = @"编辑";
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0.6;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(63);
        make.height.mas_equalTo(1);
    }];
    
    [self collectionView];
    
    
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [UIColor grayColor];
    bottomLineView.alpha = 0.6;
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(1);
    }];
    UIButton *confirmBtn = [UIButton new];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:kRGBColor(255, 75, 59) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(go2Back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)go2Back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"vc.homeVM   %@", self.homeVM);
    NSLog(@"%ld", (long)self.homeVM.rowNumber);
    return self.homeVM.rowNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDRLoginCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRDeleteCellViewController" forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        NSLog(@"subView   %@", subView);
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    [cell setDeleBtn:nil];
    [cell.imgView sd_setImageWithURL:[self.homeVM imageURLForRow:indexPath.row]];
    cell.titleLable.text = [self.homeVM titleForRow:indexPath.row];
    cell.deleBtn.hidden = NO;
    cell.deleBtn.tag = indexPath.row + 20000;
    [cell.deleBtn addTarget:self  action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

// 删除Cell
- (void)deleteCell:(UIButton *)sender{
    NSInteger tag = sender.tag - 20000;
    NSString *appid = [NSString stringWithFormat:@"%ld", (long)[self.homeVM urlIDForRow:tag]];
    __weak QDRDeleteCellViewController *wself = self;
    [self.searchVM postDeleteCollectAppByUserid:[[NSUserDefaults standardUserDefaults]  objectForKey:LOCAL_READ_USERID] appid:appid CompleteHandle:^(NSError *error) {
        if (!wself.searchVM.errorStr) {
            [wself.homeVM.dataArr removeObjectAtIndex:tag];
            [wself.collectionView reloadData];
        }
    }];
}
//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
