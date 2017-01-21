//
//  QDRViewController.m
//  freeBook
//
//  Created by 随看 on 16/9/28.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRViewController.h"
#import "QDRNetManager.h"
#import "BaseViewModel.h"
#import "QDRLoginViewController.h"
#import "QDRUserFeedbackViewController.h"
#import "QDRLoginCollectionViewCell.h"
#import "QDRHomePageViewModel.h"
#import "QDRLoginViewModel.h"
#import "QDRWebViewController.h"
#import "QDRSearchPromptView.h"
#import "QDRSearchViewModel.h"
#import "NSString+CLExtention.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <AddressBook/AddressBook.h>
#import "QDRclassificationViewController.h"
#import "QDRAddCollectionViewCell.h"
#import "QDRDeleteCellViewController.h"
#import "QDRSearchTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TractionCollectionViewFlowLayout.h"
#import "QDRHeaderView.h"
#import "QDRSkinView.h"
#import "QDRBookMarkView.h"
#import "QDRMarkButton.h"
#import "FMDBManager.h"
#import "QDRBookViewModel.h"
#import "QDRSkinViewModel.h"
#import "QDRclassViewController.h"

@interface QDRViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, selectIndexPathDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, deleteUrlDelegate, TractionCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) QDRHeaderView *collectionHeaderView;

@property (nonatomic, strong) QDRHomePageViewModel *homeVM;  //主页模型

@property (nonatomic, strong) QDRSearchViewModel *searchVM;        //搜索模型

@property (nonatomic, strong) QDRLoginViewModel *loginVM;   //登录模型

@property (nonatomic, strong) UICollectionView *addressCollectionView;      //网址

@property (nonatomic, strong) QDRSearchPromptView *searchView;       //搜索

@property (nonatomic, strong) TractionCollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, strong) QDRSkinView *skinView;   //皮肤

@property (nonatomic, strong) UIButton *maskSkinBtn;  // 皮肤遮罩


@end

@implementation QDRViewController
{
    CLLocationManager *locationManager;  // 获取地理位置管理者
    NSString *mCurrentAddress;  // 当前地址
    UILabel *addlabel;           // 最末尾添加按钮
    UIButton *noInternetBtn;        // 无网络连接按钮
    UILabel *noInternetLabel;           //无网络提示语
    NSInteger internetInt;
    CGFloat marginOffset;    // 拖拽距离
    
    NSInteger skinInt;      //皮肤的最终选择（用于确定使用按钮）
}

- (UIButton *)maskSkinBtn{
    if (!_maskSkinBtn) {
        _maskSkinBtn = [UIButton new];
        [_maskSkinBtn addTarget:self action:@selector(dismissSkinView) forControlEvents:UIControlEventTouchUpInside];
        _maskSkinBtn.frame = CGRectMake(0, 0, kWindowW, 0);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_maskSkinBtn];
    }
    return _maskSkinBtn;
}
// 隐藏皮肤视图
- (void)dismissSkinView{
    _maskSkinBtn.frame = CGRectMake(0, 0, kWindowW, 0);
    [_skinView dismissSelf];
}
- (QDRSkinView *)skinView{
    if (!_skinView) {
        _skinView = [[QDRSkinView alloc] initWithFrame:CGRectMake(0, kWindowH, kWindowW, 250)];
        [_skinView addObserver:self forKeyPath:@"kvoSkin" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        [_skinView addObserver:self forKeyPath:@"kvoDetermine" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_skinView];
        
        __weak typeof (self) wself = self;
        //选中内容
        _skinView.block = ^(NSString *chooseContent,NSIndexPath *indexPath){
            //            NSString *str = [wself.skinView.dataArray[indexPath.row] stringByReplacingOccurrencesOfString:@"label" withString:@"nav"];
            NSString *str = [wself.skinView.skinVM skinPicaddrForRow:indexPath.row].absoluteString;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
            wself.addressCollectionView.backgroundView = imageView;
            skinInt = indexPath.row;
            NSLog(@"数据：%@ ；第%ld行",chooseContent,(long)indexPath.row);
        };
    }
    return _skinView;
}

- (QDRHeaderView *)collectionHeaderView{
    if (!_collectionHeaderView) {
        _collectionHeaderView = [[QDRHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, QDR_HOME_HEADER_HEIGHT)];
        _collectionHeaderView.textFd.delegate = self;
        [_collectionHeaderView.searchBtn addTarget:self action:@selector(searchResults) forControlEvents:UIControlEventTouchUpInside];
        [_collectionHeaderView.skinBtn addTarget:self action:@selector(go2skinView) forControlEvents:UIControlEventTouchUpInside];
        [_collectionHeaderView.readBtn addTarget:self action:@selector(go2readurl) forControlEvents:UIControlEventTouchUpInside];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_READURL]) {
            [_collectionHeaderView addSubview:_collectionHeaderView.readBtn];
            [_collectionHeaderView.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(55, 32));
                make.centerY.mas_equalTo(_collectionHeaderView.skinBtn.mas_centerY).mas_equalTo(0);
                make.left.mas_equalTo(15);
            }];
        }
    }
    return _collectionHeaderView;
}

// 续读
- (void)go2readurl{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_READURL]) {
        QDRWebViewController *webvc = [[QDRWebViewController alloc] initWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_READURL]] andTitle:@""];
        //            [webvc setValue:@"appImageView.image" forKey:image];
        webvc.appImageUrl = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_APPIMAGEURL]];
        webvc.supercode = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SUPERCODE];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webvc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}

// 弹出皮肤视图
- (void)go2skinView{
    NSLog(@"%lu", self.tabBarController.selectedIndex);
    
    if (_skinView.skinVM.rowNumber != 0) {
        self.maskSkinBtn.frame = CGRectMake(0, 0, kWindowW, kWindowH);
        [self.skinView popSelf];
        NSLog(@"设置皮肤");
    }else{
        [self showErrorMsg:@"无网络连接，请检查网络状态"];
    }
    
}

- (QDRSearchPromptView *)searchView{
    if (!_searchView) {
        _searchView = [[QDRSearchPromptView alloc] initWithFrame:CGRectMake(0, 64, kWindowW, 0)];
        _searchView.delegate = self;
        [self.view addSubview:_searchView];
        //kvo
        [_searchView addObserver:self forKeyPath:@"KVOAddApp" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return _searchView;
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

- (QDRLoginViewModel *)loginVM
{
    if (!_loginVM) {
        _loginVM = [QDRLoginViewModel new];
    }
    return _loginVM;
}

// 刷新collectionview动作
- (void)reloadSelfCollectionView{
    NSLog(@"%lu", (unsigned long)_collectionHeaderView.subviews.count);
    
    // 添加“续读”按钮
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_READURL]) {
        if (_collectionHeaderView.subviews.count == 4) {
            [_collectionHeaderView addSubview:_collectionHeaderView.readBtn];
            [_collectionHeaderView.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(55, 32));
                make.centerY.mas_equalTo(_collectionHeaderView.skinBtn.mas_centerY).mas_equalTo(0);
                make.left.mas_equalTo(15);
            }];
        }
    }
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SKIN]) {
        // 当默认皮肤不存在时，用第一个来当默认皮肤
        QDRSkinViewModel *skinVM = [QDRSkinViewModel new];
        [skinVM getSkinByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] NetCompleteHandle:^(NSError *error) {
            if (skinVM.rowNumber != 0) {
                [[NSUserDefaults standardUserDefaults] setObject:[skinVM skinPicaddrForRow:0].absoluteString forKey:LOCAL_READ_SKIN];
                NSString *str = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SKIN];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
                _addressCollectionView.backgroundView = imageView;
            }
        }];
    }else{
        NSString *str = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SKIN];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
        _addressCollectionView.backgroundView = imageView;
    }
    //    float f = (self.homeVM.rowNumber + 1) / 4;
    //    int a;
    //    a = ceil(f);// 向上取整
    //    if (a <= 6) {
    //        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(25, 25, kWindowH - APPWIDTH - 114 - (APPWIDTH + 25) * a, 25);
    //    }else{
    //        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(25, 25, APPWIDTH + 25, 25);
    //    }
    _collectionViewLayout.isRefresh = YES;
    [_addressCollectionView reloadData];
}

// KVO事件
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    __weak QDRViewController* wself = self;
    if (object == _searchView) {
        if ([keyPath isEqualToString:@"KVOAddApp"]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [wself.homeVM getAddressDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                    // 回到主线程刷新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wself reloadSelfCollectionView];
                    });
                }];
            });
        }
    }else if(object == _skinView){
        if ([keyPath isEqualToString:@"kvoSkin"]) {     // 隐藏皮肤
            _maskSkinBtn.frame = CGRectMake(0, 0, kWindowW, 0); // 隐藏皮肤遮罩层
            NSString *str = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SKIN];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
            _addressCollectionView.backgroundView = imageView;
        }else if ([keyPath isEqualToString:@"kvoDetermine"]){     //确定按钮
            NSString *str = [_skinView.skinVM skinPicaddrForRow:skinInt].absoluteString;
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:LOCAL_READ_SKIN];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView sd_setImageWithURL:[_skinView.skinVM skinPicaddrForRow:skinInt]];
            _addressCollectionView.backgroundView = imageView;
            _maskSkinBtn.frame = CGRectMake(0, 0, kWindowW, 0);
            [UIView animateWithDuration:0.2 animations:^{
                _skinView.frame = CGRectMake(0, kWindowH, kWindowW, 250);
            }];
            [_skinView.collectionView reloadData];
        }
    }else if (object == self.tabBarController){
        if ([keyPath isEqualToString:@"oneKVO"]) {
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

- (void)getNetWork
{
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME]);
    __weak QDRViewController* wself = self;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_FIRST] || ![[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_TOKEN]) { //首次打开APP
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.loginVM postFirstRegistWithSign:LOCAL_READ_UUID andSerialnumber:LOCAL_READ_UUID companyid:LOCAL_READ_COMPANYID NetCompleteHandle:^(NSError *error) {
                [wself.homeVM getDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                    [wself.homeVM getAddressDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                        // 回到主线程刷新UI
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself reloadSelfCollectionView];
                        });
                    }];
                }];
            }];
        });
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.loginVM postDataFromWithUserName:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERNAME] passWord:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_PASSWORD] NetCompleteHandle:^(NSError *error) {
                [wself.homeVM getDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                    [wself.homeVM getAddressDataFromNetWithUserId:[[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] integerValue] CompleteHandle:^(NSError *error) {
                        // 回到主线程刷新UI
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself reloadSelfCollectionView];
                        });
                    }];
                }];
            }];
        });
    }
}



- (void)dealloc{
    [_searchView removeObserver:self forKeyPath:@"KVOAddApp" context:nil];
    [_skinView removeObserver:self forKeyPath:@"kvoSkin" context:nil];
    [_skinView removeObserver:self forKeyPath:@"kvoDetermine" context:nil];
    [self.tabBarController removeObserver:self forKeyPath:@"oneKVO" context:nil];
    
}

- (void)hideKeyboard:(UITapGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.addressCollectionView];
    if (!CGRectContainsPoint(_collectionHeaderView.textFd.frame, point)){
        if ([_collectionHeaderView.textFd isFirstResponder]) {
            [_collectionHeaderView.textFd resignFirstResponder];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.homeVM.dataArr.count != 0) {
        [self getNetWork];
    }
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)addRecord:(NSNotification *)notification{
    self.collectionViewLayout.isRefresh = YES;
    [self.addressCollectionView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    self.collectionViewLayout.isRefresh = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = false; // 解决滚动视图初始点为-20的问题
    [self.navigationController.navigationBar setHidden:YES];
    
    // 网络监听
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //2.监听改变
    __weak typeof (self) wself = self;
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                internetInt = -1;
                [wself showErrorMsg:@"暂无网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                internetInt = 0;
                [wself showErrorMsg:@"暂无网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                internetInt = 1;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                internetInt = 2;
                break;
            default:
                break;
        }
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!(internetInt == 1 || internetInt == 2)) {
                [self addNoInternet];       // 添加无网络时底部按钮
            }
        });
    }];
    [manger startMonitoring]; // 开始监听
    
    // 网络
    [self getNetWork];
    // collection视图
    [self addressCollectionView];
    
    
    // 添加手势用于隐藏键盘，注意要区别tableview的点击事件
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.addressCollectionView addGestureRecognizer:gestureRecognizer];
    
    
    // 定位
    dispatch_async(dispatch_get_main_queue(), ^{
        [self InitLocation];
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    });
    
    
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizerCell:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.addressCollectionView addGestureRecognizer:longPress];
    
    
    [self maskSkinBtn];
    [self skinView];
    
    [self.tabBarController addObserver:self forKeyPath:@"oneKVO" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    // Do any additional setup after loading the view.
}

// 长按手势实现方法
- (void)longPressGestureRecognizerCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint pointTouch = [gestureRecognizer locationInView:self.addressCollectionView];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.addressCollectionView indexPathForItemAtPoint:pointTouch];
        NSLog(@"(long)indexPath.row %ld", (long)indexPath.row);
        // 找到当前的cell
        //        QDRLoginCollectionViewCell *cell = (QDRLoginCollectionViewCell *)[self.addressCollectionView cellForItemAtIndexPath:indexPath];
        // 定义cell的时候btn是隐藏的, 在这里设置为NO
        [self.addressCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        if (indexPath == nil || (indexPath.row == self.homeVM.rowNumber)) {
            NSLog(@"长按手势在添加按钮上试，无响应事件");
        }else{
            QDRDeleteCellViewController *vc = [[QDRDeleteCellViewController alloc] init];
            NSLog(@"vc.homeVM   %@", vc.homeVM);
            vc.homeVM = self.homeVM;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}




- (void)judgeInt
{
    if (internetInt == 1 || internetInt == 2) {
        if (noInternetLabel) {
            [noInternetLabel removeFromSuperview];
        }
        if (noInternetBtn) {
            [noInternetBtn removeFromSuperview];
        }
        // 网络
        [self getNetWork];
    }else{
        [self addNoInternet];       // 添加无网络时底部按钮
    }
}

- (void)addNoInternet
{
    [self showErrorMsg:@"暂无网络"];
    if (!noInternetLabel){
        noInternetLabel = [UILabel new];
        noInternetLabel.text = @"当前无网络，点击屏幕刷新";
        noInternetLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:noInternetLabel];
        [noInternetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-80);
        }];
    }
    if (!noInternetBtn) {
        noInternetBtn = [UIButton new];
        [noInternetBtn addTarget:self action:@selector(judgeInt) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:noInternetBtn];
        [noInternetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 搜索结果
- (void)searchResults
{
    if (_addressCollectionView.contentOffset.y == QDR_HOME_CONTENTOFFSET) {
        NSString *searchStr = _collectionHeaderView.textFd.text;
        if ([searchStr includeChinese]) {
            searchStr = [searchStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        NSLog(@"%@", _collectionHeaderView.textFd.text);
        
        // 跳转到百度网址
        QDRWebViewController *webVc = [[QDRWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString keywordWithBaiDuUrl:searchStr]] andTitle:@""];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
        
        
        //        __weak typeof (self) wself = self;
        //        [self.searchVM getSearchResultFromNetWithStr:searchStr withsearchView:_searchView CompleteHandle:^(NSError *error) {
        //            QDRSearchTableViewController *vc = [[QDRSearchTableViewController alloc] init];
        //            vc.searchVM = wself.searchVM;
        //            self.hidesBottomBarWhenPushed = YES;
        //            [wself.navigationController pushViewController:vc animated:YES];
        //            self.hidesBottomBarWhenPushed = NO;
        //        }];
    }else{
        __weak typeof (self) wself = self;
        [UIView animateWithDuration:0.2 animations:^{
            wself.addressCollectionView.contentOffset = CGPointMake(0, QDR_HOME_CONTENTOFFSET);
        } completion:^(BOOL finished) {
            if (![_collectionHeaderView.textFd isFirstResponder]) {
                [_collectionHeaderView.textFd becomeFirstResponder];
            }
        }];
    }
    
}

// section背景颜色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    return [[UIColor whiteColor] colorWithAlphaComponent:0.9];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.homeVM.rowNumber + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDRLoginCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRViewController" forIndexPath:indexPath];
    QDRAddCollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRAddCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.homeVM.rowNumber) {
        NSLog(@"indexPath.row   %ld", (long)indexPath.row);
        NSLog(@"self.homeVM.rowNumber   %ld", (long)self.homeVM.rowNumber);
        [cell.imgView sd_setImageWithURL:[self.homeVM imageURLForRow:indexPath.row]];
        cell.titleLable.text = [self.homeVM titleForRow:indexPath.row];
        return cell;
    }else{
        NSLog(@"indexPath.row   %ld", (long)indexPath.row);
        NSLog(@"self.homeVM.rowNumber   %ld", (long)self.homeVM.rowNumber);
        [addCell borderView];
        [addCell addLabel];
        addCell.titleLable.text = @"添加";
        return addCell;
    }
}



//UICollectionView 被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.homeVM.rowNumber) {
        // 添加历史记录
        [self.homeVM postAddHistoryToUserFromNetWithUrlId:[self.homeVM urlIDForRow:indexPath.row] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
            
        }];
        
        QDRWebViewController *webvc = [[QDRWebViewController alloc] initWithURL:[self.homeVM addressURLForRow:indexPath.row] andTitle:@""];
        webvc.appImageUrl = [self.homeVM imageURLForRow:indexPath.row];
        webvc.supercode = [self.homeVM supercodeForRow:indexPath.row];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webvc animated:YES];
        self.hidesBottomBarWhenPushed=NO;
        
    }else{
        NSLog(@"从分组中添加APP");
        QDRclassViewController *vc = [[QDRclassViewController alloc] init];
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navc animated:YES completion:nil];
        
        //        QDRclassificationViewController *vc = [[QDRclassificationViewController alloc] init];
        //        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
        //        [self presentViewController:navc animated:YES completion:nil];
    }
}

//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"QDRViewController" forIndexPath:indexPath];
        
        [self collectionHeaderView];
        
        [headerRV addSubview:_collectionHeaderView];
        return headerRV;
        
    }else //有兴趣的也可以添加尾部视图
    {
        return nil;
    }
}

// 150 - 38 - 6    最上边顶到头
// 150 - 6       最下边刚开始出来

#pragma mark - lazyInstances
- (UICollectionView *)addressCollectionView {
    if(_addressCollectionView == nil) {
        self.collectionViewLayout =[[TractionCollectionViewFlowLayout alloc] init];
        _collectionViewLayout.isRefresh = YES;
        _collectionViewLayout.headerReferenceSize = CGSizeMake(kWindowW, QDR_HOME_HEADER_HEIGHT);
        _collectionViewLayout.itemSize = CGSizeMake(QDR_APP_WIDTH, QDR_APP_HEIGHT);
        
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 23, kWindowH - 124 - QDR_APP_HEIGHT, 23);
        _collectionViewLayout.minimumInteritemSpacing = (kWindowW - QDR_APP_WIDTH * 4 - 46) / 3;
        _collectionViewLayout.minimumLineSpacing = 30;
        
        _addressCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:_collectionViewLayout];
        //注册单元格Cell
        [_addressCollectionView registerClass:[QDRLoginCollectionViewCell class] forCellWithReuseIdentifier:@"QDRViewController"];
        [_addressCollectionView registerClass:[QDRAddCollectionViewCell class] forCellWithReuseIdentifier:@"QDRAddCollectionViewCell"];
        //表头视图
        [_addressCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QDRViewController"];
        _addressCollectionView.backgroundColor = [UIColor whiteColor];
        
        
        //        _addressCollectionView.alwaysBounceHorizontal = YES;
        _addressCollectionView.alwaysBounceVertical = NO;
        _addressCollectionView.showsVerticalScrollIndicator = FALSE;
        //        _addressCollectionView.showsHorizontalScrollIndicator = FALSE;
        
        //设置代理
        _addressCollectionView.dataSource = self;
        _addressCollectionView.delegate = self;
        
        __weak typeof (self) wself = self;
        _collectionViewLayout.offsetBlock = ^(CGFloat offset){
            if (offset >= 0) {
                wself.collectionHeaderView.maskView.alpha = 1;
            }else{
                wself.collectionHeaderView.maskView.alpha = 0;
            }
            
        };
        //禁用滚动
        //        _addressCollectionView.scrollEnabled = NO;
        [self.view addSubview:_addressCollectionView];
    }
    return _addressCollectionView;
}

- (void)animationHeader{
    CABasicAnimation *changeheaderview = [CABasicAnimation animationWithKeyPath:@"position"];
    changeheaderview.fromValue = [NSValue valueWithCGPoint:_collectionHeaderView.textBordView.layer.position];
    changeheaderview.toValue   = [NSValue valueWithCGPoint:CGPointMake(10, 100)];
    changeheaderview.duration  = 1.0; // For convenience
    changeheaderview.fillMode = kCAFillModeForwards;
    changeheaderview.removedOnCompletion = NO;
    
    CABasicAnimation *changeColor =
    [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor.fromValue = (id)[UIColor orangeColor].CGColor;
    changeColor.toValue   = (id)[UIColor blueColor].CGColor;
    changeColor.duration  = 1.0; // For convenience
    
    // 设定为缩放
    CABasicAnimation *headerViewTransfrom = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    headerViewTransfrom.duration = 1; // 动画持续时间
    headerViewTransfrom.repeatCount = 1; // 重复次数
    headerViewTransfrom.autoreverses = NO; // 动画结束时执行逆动画
    // 缩放倍数
    headerViewTransfrom.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    headerViewTransfrom.toValue = [NSNumber numberWithFloat:0.5]; // 结束时的倍率
    
    CAAnimationGroup * headergroup = [CAAnimationGroup animation];
    headergroup.duration = 1;
    headergroup.fillMode = kCAFillModeForwards;
    headergroup.removedOnCompletion = NO;
    headergroup.animations = @[changeheaderview,headerViewTransfrom];
    [_collectionHeaderView.textBordView.layer addAnimation:headergroup forKey:@"headergroup"];
    
    _collectionHeaderView.textBordView.layer.speed = 0.0;
}

// 输入框刚开始工作时
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_collectionHeaderView.textBordView.frame.origin.x != 60) {
        __weak typeof (self) wself = self;
        [UIView animateWithDuration:0.2 animations:^{
            wself.addressCollectionView.contentOffset = CGPointMake(0, QDR_HOME_CONTENTOFFSET);
        } completion:^(BOOL finished) {
            
        }];
    }
}



// 键盘代理方法：右下角按钮点击方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_addressCollectionView.contentOffset.y == QDR_HOME_CONTENTOFFSET) {
        NSString *searchStr = _collectionHeaderView.textFd.text;
        if ([searchStr includeChinese]) {
            searchStr = [searchStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        NSLog(@"%@", _collectionHeaderView.textFd.text);
        
        // 跳转到百度网址
        QDRWebViewController *webVc = [[QDRWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString keywordWithBaiDuUrl:searchStr]] andTitle:@""];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        //        __weak typeof (self) wself = self;
        //        [self.searchVM getSearchResultFromNetWithStr:searchStr withsearchView:_searchView CompleteHandle:^(NSError *error) {
        //            QDRSearchTableViewController *vc = [[QDRSearchTableViewController alloc] init];
        //            vc.searchVM = wself.searchVM;
        //             self.hidesBottomBarWhenPushed = YES;
        //            [wself.navigationController pushViewController:vc animated:YES];
        //             self.hidesBottomBarWhenPushed = NO;
        //        }];
    }
    return YES;
}


//定位
- (void)InitLocation {
    //初始化定位服务管理对象
    if(locationManager == nil){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        locationManager.distanceFilter = 1000.0f;
    }
    
}
#pragma mark Core Location委托方法用于实现位置的更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray *)locations
{
    CLLocation * currLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if ([placemarks count] > 0) {
                           CLPlacemark *placemark = placemarks[0];
                           NSDictionary *addressDictionary = placemark.addressDictionary;
                           NSString *address = [addressDictionary objectForKey:(NSString *) kABPersonAddressStreetKey];
                           address = address == nil ? @"": address;
                           NSString *state = [addressDictionary objectForKey:(NSString *) kABPersonAddressStateKey];
                           state = state == nil ? @"": state;
                           NSString *city = [addressDictionary objectForKey:(NSString *) kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           mCurrentAddress = [[NSString alloc] initWithFormat:@"%@", city];
                           
                           NSLog(@"经纬度  %f,%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude);
                           NSLog(@"%@", mCurrentAddress);
                           
                           // 地理位置上传
                           [_homeVM postAddLocationByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] itude:[NSString stringWithFormat:@"%f,%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude] location:mCurrentAddress CompleteHandle:^(NSError *error) {
                               
                           }];
                           
                           [locationManager stopUpdatingLocation];
                       }
                   }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

-(void)locationManager:(nonnull CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            //用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            break;
        }
            //访问受限(苹果预留选项,暂时没用)
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
            //定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            //定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled]){
                NSLog(@"定位开启，但被拒");
                /*在此处, 应该提醒用户给此应用授权, 并跳转到"设置"界面让用户进行授权
                                 在iOS8.0之后跳转到"设置"界面代码*/
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:settingURL]){
                    [[UIApplication sharedApplication] openURL:settingURL];
                }
            }else{
                NSLog(@"定位关闭，不可用");
            }
            break;
        }
            //获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}

// 正在拖拽
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    CGFloat currentOffset = scrollView.contentOffset.y;
    ////    static CGFloat lastOffset;
    //
    //    NSLog(@"currentOffset   %f", currentOffset);
    //    if (currentOffset <= 0 || currentOffset >= 140) {//此时不应改变
    //        return;
    //    }
    //
    //    marginOffset = currentOffset - _lastOffset;
    //    NSLog(@"marginOffset   %f", marginOffset);
    //    CGFloat navaH = _naviView.frame.size.height;
    //    CGFloat textX = _textBackView.frame.origin.x;
    //    CGFloat textY = _textBackView.frame.origin.y;
    //    CGFloat textW = _textBackView.frame.size.width;
    //    CGFloat imageW = _headerImageView.frame.size.width;
    //
    //    if (currentOffset >= 0 && currentOffset <= 70) {
    //
    //    }
    //
    //    if (marginOffset < 0) { //向下滚动
    //
    //        if (navaH >= 134 || navaH == 204) {
    //            return;
    //        }
    //
    //        navaH += fabs((marginOffset));
    //        textY += fabs((marginOffset));
    //        textX -= fabs((marginOffset / 138.0 * 40.0));
    //        textW += fabs((marginOffset / 138.0 * 40.0 * 2.0));
    //
    //
    //        _naviView.frame = CGRectMake(0, 0, kWindowW, navaH);
    //        _textBackView.frame = CGRectMake(textX, textY, textW, 40);
    //        //        _headerImageView.center = CGPointMake(imageX, imageY);
    //        NSLog(@"_headerImageView.bounds.size.width %f", _headerImageView.bounds.size.width);
    //
    //        if (currentOffset < 70) {
    //            [self regularScrollView:scrollView];
    //        }
    //
    //    }else{//向上滚动
    //
    //        if (navaH < 134 || navaH == 64) {
    //            return;
    //        }
    //        navaH -= fabs((marginOffset));
    //        textY -= fabs((marginOffset));
    //        textX += fabs((marginOffset / 138.0 * 40.0));
    //        textW -= fabs((marginOffset / 138.0 * 40.0 * 2.0));
    //        imageW -= fabs((marginOffset));
    //
    //        _naviView.frame = CGRectMake(0, 0, kWindowW, navaH);
    //        _textBackView.frame = CGRectMake(textX, textY, textW, 40);
    //        _headerImageView.bounds = CGRectMake(0, 0, imageW, imageW);
    //        NSLog(@"_headerImageView.bounds.size.width %f", _headerImageView.bounds.size.width);
    //
    //        if (currentOffset >= 70) {
    //            [self regularScrollView:scrollView];
    //        }
    //    }
    //    _lastOffset = currentOffset;
}

// 拖拽完了
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    [self regularScrollView:scrollView];
}

// 减速完了
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    [self regularScrollView:scrollView];
}

// 拖拽完成后固定滚动视图
- (void)regularScrollView:(UIScrollView *)scrollView{
    CGFloat headerX = _collectionHeaderView.textBordView.frame.origin.x;
    __weak typeof (self) wself = self;
    if (headerX >= 40 && headerX < 60) {
        
        [UIView animateWithDuration:0.1 animations:^{
            wself.collectionHeaderView.headerImageView.alpha = 0;
            scrollView.contentOffset = CGPointMake(0, 140);
        } completion:^(BOOL finished) {
            
        }];
    }else if (headerX < 40 && headerX > 20){
        
        [UIView animateWithDuration:0.1 animations:^{
            //            wself.collectionHeaderView.textBordView.frame = CGRectMake(20, wself.collectionHeaderView.textBordView.frame.origin.y, kWindowW - 40, 36);
            wself.collectionHeaderView.headerImageView.bounds = CGRectMake(0, 0, 60, 60);
            wself.collectionHeaderView.headerImageView.alpha = 1;
            scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            wself.collectionHeaderView.searchBtn.alpha = 1;
        }];
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
