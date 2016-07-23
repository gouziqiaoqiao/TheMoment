//
//  WJTabBarController.m
//  TheMoment
//
//  Created by 王钧 on 16/6/30.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJTabBarController.h"
#import "WJMomentViewController.h"
#import "WJMineViewController.h"

@interface WJTabBarController ()

@end

@implementation WJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建标签栏
    [self creatTabBar];
}

#pragma mark - 创建标签栏
- (void)creatTabBar {
    
    // 找到plist文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DXTabBar.plist" ofType:nil];
    
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:path];
    
    // 遍历创建控制器
    [plistArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSString *className = obj[@"className"];
        NSString *title = obj[@"title"];
        NSString *image = obj[@"image"];
        NSString *selectedImage = obj[@"selectedImage"];
        
        // 拿到类
        Class DXClass = NSClassFromString(className);
        
        WJBasicViewController *controller = [[DXClass alloc] init];
        // 设置控制器的名字(包括了tabBar和navigationBar)
        controller.title = title;
        // 设置tabBar普通状态的图片
        controller.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 设置tabBar的选中状态的图片
        controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // 创建导航控制器
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        
        // 让导航控制器成为tabBar的子控制器
        [self addChildViewController:nav];
    }];
}

@end
