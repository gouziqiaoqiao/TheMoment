//
//  WJWebViewController.m
//  TheMoment
//
//  Created by 王钧 on 16/7/13.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJWebViewController.h"

@interface WJWebViewController ()<UIWebViewDelegate>

@end

@implementation WJWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /***************UIWebView****************/
    // 网页加载 UIWebView -> UIView
    // 1.实例化
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[UIScreen mainScreen]bounds].size.height - 64)];
    // 2.背景颜色
    webView.backgroundColor = [UIColor lightGrayColor];
    
    // NSURL:网址 - 将字符串转为网址
    // 3.取值
    NSURL *url = [NSURL URLWithString:self.url];
    //NSURLRequest:将一个网址变为可以进行网络请求的网址
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 网页加载
    [webView loadRequest:request];
    // delegate
    webView.delegate = self;
    webView.tag = 10;
    // 3.添加
    [self.view addSubview:webView];
    
    // 如果Xcode版本为7.0+，需要在info.plist文件里面加上NSAppTransportSecurity(dic)类型，由他展开一个选项：NSAllowsArbitraryLoads(bool)类型，设置为YES
    
    // 四个按钮
    NSArray *array = @[@"重载",@"停止加载",@"后退",@"前进"];
    for (int i = 0 ; i < array.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i;
        button.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width / 4 * i, [[UIScreen mainScreen] bounds].size.height - 30, [[UIScreen mainScreen] bounds].size.width / 4, 30);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark - 按钮点击事件
-(void)buttonClick:(UIButton *)button {
    // 获取webView
    UIWebView *webView = (UIWebView *)[self.view viewWithTag:10];
    switch (button.tag) {
        case 0: {
            // 重载
            [webView reload];
        }
            break;
        case 1: {
            // 停止加载
            [webView stopLoading];
        }
            break;
        case 2: {
            // 后退
            [webView goBack];
        }
            break;
        case 3: {
            // 前进
            [webView goForward];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 遵守协议
// 网页开始加载
-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"网页开始加载");
    // 等待小图标（小菊花）
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
// 网页结束加载
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"网页完成加载");
    [KVNProgress showSuccessWithStatus:@"加载完成"];
}
// 网页加载失败
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 您的网路不稳定，请稍后重试
    [KVNProgress showErrorWithStatus:@"网页加载失败"];
    
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
