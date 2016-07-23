//
//  WJLocationViewController.m
//  TheMoment
//
//  Created by zeb on 16/7/9.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WJLocationManager.h"
#import "WJGeocoder.h"

#define PI 3.14


@interface WJLocationViewController ()<CLLocationManagerDelegate, MKMapViewDelegate> {
    WJAudioPlayer *audioPlayer;
}

// 声明一个地图对象
@property (nonatomic, strong) MKMapView *mapView;

// 定位管理对象
@property (nonatomic, strong) WJLocationManager *manager;


@property (nonatomic, strong) UITextField *textField;


@property (nonatomic, assign) CLLocationCoordinate2D location;
@end


@implementation WJLocationViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self creatUI];
    
    
    // 创建地图
    [self creatMap];
    
    
    // 添加手势
    [self addGesture];


    // 开始定位
    [self.manager startUpdatingLocation];

}

#pragma mark -  创建界面
- (void)creatUI {
    audioPlayer = [[WJAudioPlayer alloc] init];
    
//    self.navigationController.navigationBarHidden = YES;
    
    // 创建textField
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    _textField.placeholder = @"请输入具体地址";
//    _textField.text = @"成都一环路西二段17号";
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.backgroundColor = [UIColor cyanColor];
    self.navigationItem.titleView = _textField;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loacationWithAdddress:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = locationItem;
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"dx_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark - 返回按钮的点击事件
- (void)backClick:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 添加手势
- (void)addGesture {
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    // 将手势添加到地图上
    [self.mapView addGestureRecognizer:longPress];
    
}

// 实现手势事件
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint point = [longPress locationInView:self.mapView];
    
    // 将地图上的坐标点转换成经纬度
    // 参数1:坐标点
    // 参数2:指定地图
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    NSLog(@"%f, %f", coordinate.latitude, coordinate.longitude);
    // 手动添加锚点的位置
    _location = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    // 添加锚点
    [self addMapAnnotationWithCoordinate:coordinate];
    
}


#pragma mark - 懒加载
- (WJLocationManager *)manager {
    
    if (!_manager) {
        _manager = [[WJLocationManager alloc] init];
        // 设置代理
        _manager.delegate = self;
    }
    return _manager;
}



#pragma mark - 创建地图
- (void)creatMap {
    
    // 1.实例化地图对象
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    // 2.显示在界面上
    [self.view addSubview:_mapView];
    
    // 3.地图类型
    // MKMapTypeStandard = 0,标准
    // MKMapTypeSatellite,卫星地图
    // MKMapTypeHybrid,前两者结合
    [_mapView setMapType:MKMapTypeHybrid];
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
}


#pragma mark - 通过位置定位
- (void)loacationWithAdddress:(UIButton *)btn {
    // 4.地图的定位
    // span:精确度,值越小,精度越高,(范围:0 ~ 1)
    NSLog(@">>>>>>>>>>>>>>>%@",[NSThread currentThread]);
    // 拿到经纬度
    WJGeocoder *geo = [[WJGeocoder alloc] init];
    [geo geocodeWithAddress:_textField.text successBlock:^(CLLocationCoordinate2D coordinate) {
        
        [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude), MKCoordinateSpanMake(0.001, 0.001))];
        
        // 按钮点击后的位置
        _location = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        
        
        // 5.加锚点(大头针)
        [self addMapAnnotationWithCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
    }];

    
    [self.textField resignFirstResponder];
    
    // 6.设置代理
    _mapView.delegate = self;
    
}



#pragma mark - 通过经纬度去添加锚点
- (void)addMapAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<%@",[NSThread currentThread]);
    // 通过类方法拿地址
    WJGeocoder *geocoder = [[WJGeocoder alloc] init];
    [geocoder reverseGeocodeWithCoordinate:coordinate];
    
    _location = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    
    NSMutableDictionary *address = [NSMutableDictionary new];
    geocoder.block = ^(NSDictionary * addressDict) {
        
        [address setValuesForKeysWithDictionary:addressDict];
        
        NSLog(@"address:%@", address);
    };
    // 声明一个锚点对象
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    // 设置经纬度
    annotation.coordinate = coordinate;
    // 在锚点上显示文字
    // 城市
    annotation.title = address[@"City"];
    NSLog(@"---------%@",annotation);
    // 街道
    annotation.subtitle = address[@"Thoroughfare"];
    // 添加到地图上
    [self.mapView addAnnotation:annotation];
}

#pragma mark - 定制锚点样式(通过协议方法去实现的)
// 通过协议方法去定制大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // 定制锚点和定制tableView的cell的方法一样,MKAnnotationView和cell一样可以复用
    // 1.去复用池中查看是否有可以复用的MKAnnotationView
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"iden"];
    
    // 2.判断是否找到可以复用的MKAnnotationView,如果没有就创建一个新的
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"iden"];
    }
    
    // 3.定制锚点的样式
    // 设置图片
    annotationView.image = [[UIImage imageNamed:@"dx_annotation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字
    annotationView.canShowCallout = YES;
    
    
    // 4.返回MKAnnotationView
    return annotationView;
}
#pragma mark - 由经纬度计算两点的距离
double lantitudeLongitudeDistance(CLLocation *newLocation, CLLocationCoordinate2D location) {
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    
    double radlat1 = PI*newLocation.coordinate.latitude/180.0f;
    double radlat2 = PI*location.latitude/180.0f;
    
    //now long.
    double radlong1 = PI*newLocation.coordinate.longitude/180.0f;
    double radlong2 = PI*location.longitude/180.0f;
    
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    
    
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    
    return dist;
}

#pragma mark - CLLocationManagerDelegate
// 这个方法会调用多次
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // 获取到当前位置的经纬度
//    CLLocationCoordinate2D coord = newLocation.coordinate;
    
    // 这里的location的经纬度应该是设定位置的经纬度
    // 判断两个点之间的距离达到触发条件
    double distance = lantitudeLongitudeDistance(newLocation, _location);
    NSLog(@"----------------------distance:%.2f",distance);
    
    
    if (distance <= 100 && distance >= 10) {
        NSLog(@"到了");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"到达目的地" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [audioPlayer playWithName:@"sound effect-1.mp3"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        });
    }
    
    
    if (distance <= 1000 && distance >= 100) {
        
        NSLog(@"要到了");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"即将到达目的地" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [audioPlayer playWithName:@"sound effect-0.mp3"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    
    // 通过经纬度去确定地图显示的范围
    //    [_mapView setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    //
    //    [self addMapAnnotationWithCoordinate:newLocation.coordinate];
    
    
}

@end