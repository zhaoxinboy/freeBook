//
//  QDRBookMarkView.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/10.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRBookMarkView.h"
#import "QDRBookMarksCollectionViewCell.h"
#import "CYLineLayout.h"
#import "FMDBManager.h"
#import "QDRBookViewModel.h"

@interface QDRBookMarkView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *nullLabel;// 无数据时显示的文字

@end

@implementation QDRBookMarkView

- (UILabel *)nullLabel{
    if (!_nullLabel) {
        _nullLabel = [UILabel new];
        _nullLabel.textColor = [UIColor whiteColor];
        _nullLabel.font = [UIFont systemFontOfSize:16];
        _nullLabel.textAlignment = NSTextAlignmentCenter;
        _nullLabel.text = @"暂无书签，快去添加自己喜欢的网页吧！";
    }
    return _nullLabel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        // 创建布局
        CYLineLayout *layout = [[CYLineLayout alloc] init];
        layout.itemSize = CGSizeMake((245 / (kWindowH - 104)) * kWindowW, 260);
        
        //集合视图初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //注册单元格Cell
        [_collectionView registerClass:[QDRBookMarksCollectionViewCell class] forCellWithReuseIdentifier:@"QDRBookMarksCollectionViewCell"];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.alwaysBounceVertical = NO;  // 垂直弹跳
        _collectionView.alwaysBounceHorizontal = YES;  // 水平弹跳
        
        _collectionView.showsVerticalScrollIndicator = FALSE;   //滚动条
        _collectionView.showsHorizontalScrollIndicator = FALSE;// 滚动条
        
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //禁用滚动
        //        _addressCollectionView.scrollEnabled = NO;
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QDRBookMarksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QDRBookMarksCollectionViewCell" forIndexPath:indexPath];
    QDRBookViewModel *model = self.dataArray[indexPath.row];
    if (model.imageData) {
        UIImage *image = [self Base64StrToUIImage:model.imageData];
        cell.titleContentView.image = image;
    }
    cell.titleLabel.text = model.titlestr;
    cell.closeBtn.tag = indexPath.row + 100000;
    [cell.closeBtn addTarget:self action:@selector(deleteBook:) forControlEvents:UIControlEventTouchUpInside];
    cell.bottomView.backgroundColor = [UIColor redColor];
    return cell;
}


- (void)deleteBook:(UIButton *)sender{
    NSInteger btnTag = sender.tag - 100000;
    // 加载成后判断数据库中是否有此页的书签，更改右上角按钮状态
    NSMutableArray *arr = [[FMDBManager sharedFMDBManager] getAllBookView];
    QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
    model = arr[btnTag];
    if ([[FMDBManager sharedFMDBManager] deleteBookView:model]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteUrlwithString:)]) {
            [self.delegate deleteUrlwithString:model.url];
        }
        [self showSuccessMsg:@"删除书签成功"];
        [self.dataArray removeAllObjects];
        self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
        [self.collectionView reloadData];   // 删除后刷新数组
    }else{
        [self showSuccessMsg:@"删除书签失败，请重试"];
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.kvoUrl = indexPath.row;
    NSLog(@"------%zd", indexPath.item);
}

//返回UICollectionView 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
        [self collectionView];
        
    }
    return self;
}

- (void)upBookView{
    if ([[FMDBManager sharedFMDBManager] getAllBookView].count == 0){          //数组为空
        NSLog(@"%@", _nullLabel);
        if (!_nullLabel) {
            [self nullLabel];
            [self addSubview:_nullLabel];
            [_nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
        }
    }else{
        [_nullLabel removeFromSuperview];
        [self setNullLabel:nil];
    }
    if (!(self.dataArray == [[FMDBManager sharedFMDBManager] getAllBookView])) {
        [self.dataArray removeAllObjects];
        self.dataArray = [[FMDBManager sharedFMDBManager] getAllBookView];
        [_collectionView reloadData];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kWindowH - 320, kWindowW, 320);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)downBookView{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kWindowH, kWindowW, 320);
    } completion:^(BOOL finished) {
        
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
