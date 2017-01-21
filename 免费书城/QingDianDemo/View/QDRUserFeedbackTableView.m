//
//  QDRUserFeedbackTableView.m
//  QingDianDemo
//
//  Created by 随看 on 16/10/2.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRUserFeedbackTableView.h"

@interface QDRUserFeedbackTableView () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@end

@implementation QDRUserFeedbackTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.KVOsubNum = 0;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = kRGBColor(236, 236, 236);
        // 隐藏cell分割线
        self.separatorStyle = NO;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QDRUserFeedbackTableView"];
    }
    return self;
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QDRUserFeedbackTableView" forIndexPath:indexPath];
    if (!_adviceTextView) {
        _adviceTextView = [[BRPlaceholderTextView alloc] init];
        _adviceTextView.placeholder = @"请输入你的建议，200字以内";
        _adviceTextView.layer.borderColor = kRGBColor(236, 236, 236).CGColor;
        _adviceTextView.layer.borderWidth = 1;
        _adviceTextView.delegate = self;
        [_adviceTextView addMaxTextLengthWithMaxLength:200 andEvent:^(BRPlaceholderTextView *text) {
            
            NSLog(@"----------");
        }];
        
        [_adviceTextView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
            NSLog(@"begin");
        }];
        
        [_adviceTextView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
            NSLog(@"end");
        }];
        [cell.contentView addSubview:_adviceTextView];
        [_adviceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(211);
        }];
    }
    if (!_stirngLenghLabel) {
        _stirngLenghLabel = [UILabel new];
        _stirngLenghLabel.text = @"200";
        _stirngLenghLabel.font = [UIFont systemFontOfSize:14];
        _stirngLenghLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:_stirngLenghLabel];
        [_stirngLenghLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(210);
        }];
    }
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.numberOfLines = 0;
        _promptLabel.font = [UIFont systemFontOfSize:12];
        _promptLabel.text = @"吐槽、建议，一切关于免费书城的话。哪怕是随便聊聊，只要是您的声音，我们都想听到~~";
        _promptLabel.textColor = kRGBColor(102, 102, 102);
        [cell.contentView addSubview:_promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_adviceTextView.mas_bottom).mas_equalTo(15);
        }];
    }
    
    // 被选中不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 290;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger len = 200 - textView.text.length;
    //实时显示字数
    self.stirngLenghLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)len];
    
    //字数限制操作
    if (textView.text.length >= 200) {
        
        textView.text = [textView.text substringToIndex:200];
        self.stirngLenghLabel.text = @"200";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (!(textView.text.length == 0)) {
        self.KVOsubNum = 0;
    }else{
        self.KVOsubNum = 1;
        
    }
    
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![[touches anyObject].view isEqual:self.adviceTextView]) {
        if ([self.adviceTextView isFirstResponder]) {
            [self.adviceTextView resignFirstResponder];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
