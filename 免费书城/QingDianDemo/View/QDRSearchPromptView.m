//
//  QDRSearchPromptView.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/3.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRSearchPromptView.h"
#import "QDRHistoryTableViewCell.h"
#import "QDRHomePageModel.h"
#import "QDRSearchViewModel.h"

@interface QDRSearchPromptView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) QDRSearchViewModel *searchVM;

@property (nonatomic, strong) UIView *disView;

@end

@implementation QDRSearchPromptView

- (QDRSearchViewModel *)searchVM
{
    if (!_searchVM) {
        _searchVM = [QDRSearchViewModel new];
    }
    return _searchVM;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateHighlighted];
        [_closeBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-5);
        }];
    }
    return _closeBtn;
}

- (void)closeSelf
{
    [self dismiss];
}

- (void)dismiss
{
    if (self.disView) {
        [self.disView removeFromSuperview];
        [self setDisView:nil];
    }
    __weak QDRSearchPromptView *wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.frame = CGRectMake(wself.frame.origin.x, wself.frame.origin.y, wself.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [_tableView reloadData];
        wself.KVOTableView += 1;
    }];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)popView
{
    if (_dataArr.count != 0) {
        [self.tableView reloadData];
    }else{
        self.disView = [UIView new];
        self.disView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.disView];
        [self.disView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
        }];
        
        UILabel *label = [UILabel new];
        label.text = @"未找到相关记录！";
        [self.disView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    
    
    // 同步显示 子控件(views)和(self)
    NSArray *results = [self subviews];
    for (UIView *view in results) {
        [view setHidden:YES];
    }
    __weak QDRSearchPromptView *wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        wself.frame = CGRectMake(wself.frame.origin.x, wself.frame.origin.y, wself.frame.size.width, 160);
    }completion:^(BOOL finished) {
        NSArray *results = [wself subviews];
        for (UIView *view in results) {
            [view setHidden:NO];
        }
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[QDRHistoryTableViewCell class] forCellReuseIdentifier:@"QDRHistoryTableViewCell"];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-40);
        }];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        
        [self tableView];
        [self closeBtn];
    }
    return self;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", self.dataArr);
    return self.dataArr.count;
}
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QDRHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRHistoryTableViewCell"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexPathRow:)]) {
        [self.delegate selectIndexPathRow:indexPath.row];
    }
}

- (void)addSearchResult:(UIButton *)sender
{
    NSInteger index = sender.tag - 10000;
    NSLog(@"%ld", (long)index);
    __weak QDRSearchPromptView *wself = self;
    QDRHomeAddressDataModel *model = self.dataArr[index];
    [self.searchVM postAddAppInfoToUserFromNetWithUrlId:[model.qdrid integerValue] andUserID:[[NSUserDefaults standardUserDefaults] objectForKey:LOCAL_READ_USERID] CompleteHandle:^(NSError *error) {
        //添加APP
        wself.KVOAddApp += 1;
        //打印添加
        NSLog(@"添加成功");
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
