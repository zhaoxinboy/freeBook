//
//  QDRGuidePageViewController.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/23.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "QDRGuidePageViewController.h"
#import "AppDelegate.h"
#import "QDRTabBarViewController.h"

@interface QDRGuidePageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation QDRGuidePageViewController{
    UIButton *nextBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = @[@"guidepage1", @"guidepage2"];
    [self createScrollview];
    // Do any additional setup after loading the view.
}

- (void)createScrollview{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(kWindowW * self.imageArray.count, kWindowH);//设置内容大小
    self.scrollView.bounces = NO; // 不可回弹
    self.scrollView.pagingEnabled = YES;//是否分页
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWindowW, 0, kWindowW, kWindowH)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.image = [UIImage imageNamed:self.imageArray[i]];
        [self.scrollView addSubview:img];
        BOOL result = i == (self.imageArray.count-1) ? 1:0;
        if (result) {
            nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nextBtn.frame = CGRectMake(kWindowW / 2 - 70, kWindowH - 42 - 50, 140, 42);
            nextBtn.layer.masksToBounds = YES;
            nextBtn.layer.cornerRadius = 21;
            nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            nextBtn.layer.borderWidth = 1;
            [nextBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [nextBtn addTarget:self action:@selector(buttonToNextView) forControlEvents:UIControlEventTouchUpInside];
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [img addSubview:nextBtn];
        }
        img.userInteractionEnabled = YES;
    }
//    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 20)];
//    self.pageControl.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:self.pageControl];
//    self.pageControl.numberOfPages = self.imageArray.count;
//    self.pageControl.currentPage = 0;
}


- (void)buttonToNextView{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    QDRTabBarViewController *tab = [[QDRTabBarViewController alloc] init];
    self.view.window.rootViewController = tab;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.pageControl.currentPage = scrollView.contentOffset.x/self.view.frame.size.width;
//}

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
