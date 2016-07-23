//
//  WJLocationManager.m
//  01 - MKMapView
//
//  Created by 千锋 on 16/6/7.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJLocationManager.h"



@implementation WJLocationManager


// 重写init方法
- (instancetype)init {
    
    if (self = [super init]) {
        
        // 1.检查位置服务是否可用
        if ([WJLocationManager locationServicesEnabled]) {
            NSLog(@"定位服务可用");
            // 2.设置plist文件
            // 在info.plist文件中添加NSLocationAlwaysUsageDescription字段,其对应的类型是字符串，可以设置成任意字符串
            // 3.授权总是打开
            [self requestAlwaysAuthorization];
            
            // 设置导航类型
            [self setActivityType:CLActivityTypeOther];
            
            // 设置位移量更新数据
            [self setDistanceFilter:5];
            
            // 设置定位精度
            [self setDesiredAccuracy:kCLLocationAccuracyBest];
            
        }
        else {
            
            NSLog(@"定位服务不可用");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"定位服务不可用" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    return self;
}


@end
