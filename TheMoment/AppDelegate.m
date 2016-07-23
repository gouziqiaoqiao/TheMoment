//
//  AppDelegate.m
//  TheMoment
//
//  Created by 王钧 on 16/6/30.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "AppDelegate.h"
#import "WJLaunchViewController.h"
#import "WJTabBarController.h"

@interface AppDelegate ()

@property (nonatomic, strong) WJFMDBManager *manager;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    // 设置根视图
    [self setRootViewController];
    
    // 设置分享
    [self setShare];

    // 设置通知
    [self setLocalNotification];
    

    // APP进程启动
    // 如果正常通过icon启动 launchOptions为nil
    // 如果通过其他方式启动，比如通知（推送）launchOptions 有值
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        
        // 通过本地通知来启动APP进程
        [self showMessage:[NSString stringWithFormat:@"%@",launchOptions]];
        //  跳到你想调到的页面
    }
    
    
    
    return YES;
}

#pragma mark - 设置通知
- (void)setLocalNotification {
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // 通知方式类型
        UIUserNotificationType type = UIUserNotificationTypeAlert |UIUserNotificationTypeBadge |UIUserNotificationTypeSound;
        // 将类型赋给设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        // 将设置注册给通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // 老方法
    else {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound];
    }
    
    // 创建本地通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 设置启动时间
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
    
    // 方法调用后徽标设置为零
    localNotification.applicationIconBadgeNumber = 0;
    
    NSMutableArray *marray = [self.manager selectAllData];

    
    if (marray.count != 0) {
        localNotification.applicationIconBadgeNumber = marray.count;
    }
    
    if (marray.count == 0) {
        
        // 将角标置为0
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    // 加入到队列中
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - 懒加载
- (WJFMDBManager *)manager {

    if (!_manager) {
        _manager = [[WJFMDBManager alloc] init];
    }
    return _manager;
}

#pragma mark - 设置根视图
- (void)setRootViewController {

    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 判断这个程序是否是第一次启动
    // 讲数据存储到本地去
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"d:%@,,,,p%@", defaults, NSHomeDirectory());
    
    // 设置需要存储的数据
    // 判断plist文件中的isLaunched是否存在
    if (![defaults objectForKey:@"isLaunched"]) {
        [defaults setObject:@"NO" forKey:@"isLaunched"];
        [defaults synchronize];
    }
    if ([[defaults objectForKey:@"isLaunched"] isEqualToString:@"NO"]) {
        WJLaunchViewController *wjLaunchVC = [[WJLaunchViewController alloc]init];
        self.window.rootViewController = wjLaunchVC;
        [defaults setObject:@"YES" forKey:@"isLaunched"];
        [defaults synchronize];
    }
    else if ([[defaults objectForKey:@"isLaunched"] isEqualToString:@"YES"]) {
        WJTabBarController *tbc = [[WJTabBarController alloc] init];
        self.window.rootViewController = tbc;
    }
    [self.window makeKeyAndVisible];
    
}

#pragma mark - 设置分享
- (void)setShare {

    // 设分享功能
    // 设置社会化分享组件appKey
    [UMSocialData setAppKey:UMengKey];
    // 设置微信
    [UMSocialWechatHandler setWXAppId:@"wxb605db67cb3cf6e9" appSecret:@"9e5b4af2928db905df35debd31b5d7b4" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:@"1105537682" appKey:@"Gx0adD5PHu4TQvTF" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    // [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}


- (void)showMessage:(NSString *)noti {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:noti delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    
    [alert show];
}

// 当收到本地通知后调用该方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    // 判断程序在前台还是后台，来决定是否跳转页面，如果程序在前台，依然后收到通知，但是收到之后不应该跳转页面
    if (application.applicationState == UIApplicationStateActive) {
        
        
        return;
    }
    if (application.applicationState == UIApplicationStateInactive) {
        
        // 处于后台的任务的
        
    
    }
    NSLog(@"notification:%@",notification);
}

#pragma mark - 配置系统回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
    [self setLocalNotification];
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self setLocalNotification];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
