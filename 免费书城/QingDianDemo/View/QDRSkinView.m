//
//  QDRSkinView.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/12/9.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSkinView.h"
#import "QDRSkinCollectionViewCell.h"

@interface QDRSkinView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation QDRSkinView

- (QDRSkinViewModel *)skinVM{
    if (!_skinVM) {
        _skinVM = [QDRSkinViewModel new];
    }
    return _skinVM;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    return _bottomView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_closeBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(40, 49));
        }];
    }
    return _closeBtn;
}

- (UIButton *)determineBtn{
    if (!_determineBtn) {
        _determineBtn = [UIButton new];
        [_determineBtn setTitle:@"确定使用" forState:UIControlStateNormal];
        [_determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineBtn addTarget:self action:@selector(determineSkin) forControlEvents:UIControlEventTouchUpInside];
        _determineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_bottomView addSubview:_determineBtn];
        [_determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(80, 49));
        }];
    }
    return _determineBtn;
}

- (void)determineSkin{
    self. kvoDetermine += 1;
    NSLog(@"确定使用皮肤");
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置CollectionViewCell的大小和布局
        CGFloat width = 108;
        //    220 * 365 宽*高
        //设置元素大小
        CGFloat height = 160;
        //        CGFloat height = width * 250.0/220.0;
        myLayout.itemSize = CGSizeMake(width, height);
        //四周边距
        myLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        myLayout.minimumInteritemSpacing = 10;
        myLayout.minimumLineSpacing = 10;
        myLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //集合视图初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
        
        //注册单元格Cell
        [_collectionView registerClass:[QDRSkinCollectionViewCell class] forCellWithReuseIdentifier:@"QDRSkinCollectionViewCell"];
        _collectionView.alwaysBounceVertical = NO;  // 垂直弹跳
        _collectionView.alwaysBounceHorizontal = YES;  // 水平弹跳
        
        _collectionView.showsVerticalScrollIndicator = FALSE;   //滚动条
        _collectionView.showsHorizontalScrollIndicator = YES;// 滚动条
        _collectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //禁用滚动
        //        _addressCollectionView.scrollEnabled = NO;
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-60);
        }];
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.skinVM.rowNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QDRSkinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRSkinCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[self.skinVM skinPicaddrForRow:indexPath.row] placeholderImage:[UIImage imageNamed:LOCAL_READ_PLACESKIN]];
    cell.titleLabel.text = [self.skinVM skinNameForRow:indexPath.row];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_SKIN];
    if ([[self.skinVM skinPicaddrForRow:indexPath.row].absoluteString isEqualToString:str]) {
        cell.determineImageView.image = [UIImage imageNamed:@"pic_press"];
    }else{
        cell.determineImageView.image = nil;
    }
    
    return cell;
}


- (void)deleteBook:(UIButton *)sender{
    NSInteger btnTag = sender.tag - 100000;
    // 加载成后判断数据库中是否有此页的书签，更改右上角按钮状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(skinUrlwithString:)]) {
        [self.delegate skinUrlwithString:@""];
    }
        
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.kvoUrl = indexPath.row;
    NSLog(@"------%zd", indexPath.item);
    
    
    if (_currentSelectIndex != nil && _currentSelectIndex != indexPath) {
        QDRSkinCollectionViewCell *cell =  (QDRSkinCollectionViewCell *)[collectionView cellForItemAtIndexPath:_currentSelectIndex];
        [cell UpdateCellWithState:NO];
    }
    QDRSkinCollectionViewCell *cell =  (QDRSkinCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell UpdateCellWithState:!cell.isSelected];
    _currentSelectIndex = indexPath;
    
    _block([NSString stringWithFormat:@"%ld", (long)indexPath.item],indexPath);
    
}

// 高亮完成后回调
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    QDRSkinCollectionViewCell *cell =  (QDRSkinCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
}

// 由高亮转成非高亮完成时的回调
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    QDRSkinCollectionViewCell *cell =  (QDRSkinCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
}

// 设置是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

// 设置是否允许取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

// 取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
        [self collectionView];
        
        [self bottomView];
        [self closeBtn];
        [self determineBtn];
        
        // 获取皮肤数据
        [self.skinVM getSkinByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] NetCompleteHandle:^(NSError *error) {
            [self.collectionView reloadData];
        }];
    }
    return self;
}

// 显示
- (void)popSelf{
    // 获取皮肤数据
    [self.skinVM getSkinByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] NetCompleteHandle:^(NSError *error) {
        [self.collectionView reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, kWindowH - 250, kWindowW, 250);
        }];
    }];
    
}

// 隐藏
- (void)dismissSelf{
    self.kvoSkin += 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kWindowH, kWindowW, 250);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
