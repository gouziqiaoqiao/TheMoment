//
//  WJGyroscopeController.m
//  TheMoment
//
//  Created by 王钧 on 16/7/16.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJGyroscope.h"
#import <CoreMotion/CoreMotion.h>
#import "FYCountDownView.h"
#import "MBProgressHUDManager.h"
@interface WJGyroscope () <UIAccelerometerDelegate, UIAlertViewDelegate>{

    NSInteger _count;
    
}

@property (nonatomic, strong) MBProgressHUDManager *hudManager;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, assign) CMAcceleration acceleration;


@end


@implementation WJGyroscope

#pragma mark - 懒加载
- (MBProgressHUDManager *)hudManager {
    
    if (!_hudManager) {
        _hudManager = [[MBProgressHUDManager alloc] init];
    }
    return _hudManager;
}

// 判断手机是否加速
- (void)getPhoneAcceleration {
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    // 获取硬件数据的更新间隙
    self.motionManager.accelerometerUpdateInterval = 0.5;
    [self startAction];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMessage];

        
    });
    
    [self stopAction];
}

#pragma mark - 显示提示框
- (void)showMessage {
    CMAccelerometerData *data = [self.motionManager accelerometerData];
    self.acceleration = data.acceleration;
    // 平放手机
    BOOL ret =  fabs(self.acceleration.x) <= 0.7 && fabs(self.acceleration.y) <= 0.7 && fabs(self.acceleration.z) >= 0.99  && fabs(self.acceleration.z) <= 1.2;

    if (!ret) {
        UIAlertView *keepAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请放下手机,继续做现在的事情^_^" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        keepAlert.delegate = self;
        [keepAlert show];
        _count = 0;
    }
}

#pragma mark - alert代理
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:1.0 animated:YES];
    });
}

#pragma mark - Pull
 
 - (void)startAction {
 
     // isAccelerometerActive 判断加速计是否已经激活
     if (self.motionManager.isAccelerometerActive == NO) {
     
         // 开始更新硬件数据
         [self.motionManager startAccelerometerUpdates];
     }
 }


 - (void)stopAction {
     if (self.motionManager.isAccelerometerActive == YES) {
     
     // 结束更新硬件数据
     [self.motionManager stopAccelerometerUpdates];
     }
 }

 #pragma mark - Push
 
 - (void)pushTest {
     // 1. 判断是否支持加速计硬件
     BOOL available = [self.motionManager isAccelerometerAvailable];
     if (available == NO) {
         NSLog(@"加速计不能用");
         return;
     }
 
    //  Push(按照accelerometerUpdateInterval定时推送回来)
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

        // CMAcceleration 是表示加速计数据的结构体
        CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"%f, %f, %f", acceleration.x, acceleration.y, acceleration.z);
    }];

    // 结束获取硬件数据
    [self.motionManager stopAccelerometerUpdates];
 }






// 获取到手机的重力值
//- (void)getPhoneGravity {
//
//    // 获得各个方向的重力值
//    double gravityX = _motionManager.deviceMotion.gravity.x;
//    double gravityY = _motionManager.deviceMotion.gravity.y;
//    double gravityZ = _motionManager.deviceMotion.gravity.z;
//    
//    NSLog(@"x:%f y:%f z:%f",gravityX, gravityY, gravityZ);
//    
//    // 获得手机的倾斜角
//    // 这是手机与水平面的夹角
//    double zTheta = atan2(gravityZ, sqrtf(gravityX * gravityX + gravityY * gravityY)) / M_PI * 180.0;
//    // 这是手机自身旋转的角度
//    double xyTheta = atan2(gravityX, gravityY) / M_PI * 180.0;
//    NSLog(@"%f %f",zTheta, xyTheta);
//    
//}



@end
