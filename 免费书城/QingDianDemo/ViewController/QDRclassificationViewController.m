//
//  QDRclassificationViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/11.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRclassificationViewController.h"
#import "QDRLoginCollectionViewCell.h"
#import "QDRHomePageViewModel.h"
#import "QDRclassViewController.h"
#import "QDRClassificationCollectionViewCell.h"
#import "QDRWebViewController.h"

@interface QDRclassificationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) QDRHomePageViewModel *homeVM;  //主页模型

@property (nonatomic, strong) UICollectionView *collectionView;      //网址

@end

@implementation QDRclassificationViewController

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
        CGFloat width = 70;
        //    220 * 365 宽*高
        //设置元素大小
        CGFloat height = 92;
        //        CGFloat height = width * 250.0/220.0;
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(42, 35, 25, 35);
        myLayout.minimumInteritemSpacing = (kWindowW - 280) / 2;  // 同一列中间隔的cell最小间距
        myLayout.minimumLineSpacing = 36;       // 最小行间距
        myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //集合视图初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        //注册单元格Cell
        [_collectionView registerClass:[QDRClassificationCollectionViewCell class] forCellWithReuseIdentifier:@"QDRclassificationViewController"];
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.homeVM getAllCategoryApps:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 关闭导航透明度
    self.navigationController.navigationBar.translucent = NO;
    
    // 去除导航下方分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    UIView *titleView = [UIView new];
    titleView.frame = CGRectMake(0, 0, 100, 40);
    UILabel *label = [UILabel new];
    label.text = @"导航分类";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.navigationItem.titleView = titleView;
    
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
    __weak QDRclassificationViewController *wself = self;
    [self.homeVM getAllCategoryApps:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
        [wself collectionView];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.homeVM.classRowNumber;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDRClassificationCollectionViewCell *cell = (QDRClassificationCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"QDRclassificationViewController" forIndexPath:indexPath];
    
    
    for (UIView *subView in cell.contentView.subviews) {
        NSLog(@"subView   %@", subView);
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
//    if (cell == nil) {
//        cell = (QDRAddCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"QDRclassificationViewController" forIndexPath:indexPath];
//    }else{
//        //删除cell的所有子视图
//        while ([cell.contentView.subviews lastObject] != nil){
//            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
    cell.borderView.layer.borderWidth = 1;//边框宽度
    cell.titleLable.text = [self.homeVM classTitleForRow:indexPath.row];
    
    NSArray *arr = [self.homeVM  classArrNumForRow:indexPath.row];
    NSInteger num = arr.count;
    NSLog(@" indexPath.row %ld   num %lu  ", (long)indexPath.row, (unsigned long)arr.count);
    QDRclassiDataModel *model = [QDRclassiDataModel new];
    
    if (num == 1) {
        model = arr[0];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView1];
    }else if (num == 2){
        model = arr[0];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView1];
        model = arr[1];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView2];
    }else if (num == 3){
        model = arr[0];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView1];
        model = arr[1];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView2];
        model = arr[2];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView3];
    }else if (num != 0){
        model = arr[0];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView1];
        model = arr[1];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView2];
        model = arr[2];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView3];
        model = arr[3];
        [cell.imageView4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URLPATH, model.applogopath]] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACEIMAGE]];
        [cell.contentView addSubview:cell.imageView4];
    }
    
    return cell;
}



//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QDRclassViewController *vc = [[QDRclassViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.homeVM = self.homeVM;
    vc.numRow = indexPath.row;
    [self presentViewController:navc animated:YES completion:nil];
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
