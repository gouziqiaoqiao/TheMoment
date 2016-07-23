//
//  WJLaunchViewController.m
//  WJLaunchVC
//
//  Created by 王钧 on 16/7/15.
//  Copyright © 2016年 王钧. All rights reserved.
//

#import "WJLaunchViewController.h"
#import "AppDelegate.h"
#import "WJTabBarController.h"


#define WJScreenW [UIScreen mainScreen].bounds.size.width

#define WJScreenH [UIScreen mainScreen].bounds.size.height

@interface WJLaunchViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *button;


@end

@implementation WJLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    // 
//    [self setRootVC];
    
    // 创建界面
    [self creatUI];
    
    
    // 拿到图片
    [self getImage];
    
}

//#pragma mark - 设置自己的视图为根视图
//- (void)setRootVC {
//    
//    UIApplication *app = [UIApplication sharedApplication];
//    
//    AppDelegate *appDele = app.delegate;
//    
//    appDele.window.rootViewController = self;
//    
//}

#pragma mark - 创建界面
- (void)creatUI {
    
    self.view.frame = CGRectMake(0, 0, WJScreenW, WJScreenH);
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, WJScreenW, WJScreenH);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, WJScreenH - 30, WJScreenW, 10)];
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.hidesForSinglePage = YES;
    [self.view addSubview:_pageControl];
    
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
}



- (void)getImage {
    
    NSArray *imageArray = @[@"1.png", @"2.png", @"3.png", @"4.png"];
    _pageControl.numberOfPages = imageArray.count;
    _scrollView.contentSize = CGSizeMake(WJScreenW * imageArray.count, WJScreenH);
    
    for (int i = 0; i < imageArray.count; ++i) {
        
        NSString *imageName = imageArray[i];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageV.frame = CGRectMake(WJScreenW * i, 0, WJScreenW, WJScreenH);
        [self.scrollView addSubview:imageV];
        
        if (i == imageArray.count - 1) {
            _button.frame = CGRectMake(WJScreenW / 2 - 70, WJScreenH - 80, 140, 35);
            _button.layer.masksToBounds = YES;
            _button.layer.cornerRadius = 5;
            [_button setTitle:@"进  入" forState:UIControlStateNormal];
            _button.backgroundColor = [UIColor redColor];
            _button.tintColor = [UIColor whiteColor];
            [_button addTarget:self action:@selector(enterNextClick) forControlEvents:UIControlEventTouchUpInside];
            imageV.userInteractionEnabled = YES;
            [imageV addSubview:_button];
        }
    }
}


#pragma mark - 按钮的点击
- (void)enterNextClick {
    
    // 获取当前应用程序
    UIApplication *app = [UIApplication sharedApplication];
    WJTabBarController *tvc = [[WJTabBarController alloc] init];
    
    AppDelegate *app2 = app.delegate;
    
    
    [UIView animateWithDuration:1.0 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 0.0;
        tvc.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        app2.window.rootViewController = tvc;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            
//        });
    }];
    
}


#pragma mark - 代理代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _pageControl.currentPage = (_scrollView.contentOffset.x + WJScreenW / 2) / WJScreenW;
    
}

@end
