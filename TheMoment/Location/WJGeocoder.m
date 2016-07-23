//
//  WJGeocoder.m
//  02 - 地址的编码和反编码
//
//  Created by 千锋 on 16/6/6.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJGeocoder.h"

@interface WJGeocoder ()

@property (nonatomic, copy) void (^successBlock)(CLLocationCoordinate2D);


@property (nonatomic, strong) NSDictionary *address;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end



@implementation WJGeocoder

- (CLGeocoder *)geocoder {
    
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

/*!
 *  地名->经纬度
 */
- (void)geocodeWithAddress:(NSString *)address successBlock:(void(^)(CLLocationCoordinate2D cood))successBlock {
    self.successBlock = successBlock;
    //1.获得输入的地址
//    NSString *address=self.addressField.text;
    if (address.length == 0) {
        //  给个默认的地址的经纬度，这里设置的是成都的经纬度
        _coordinate = CLLocationCoordinate2DMake(30.659462, 104.065735);
        if (self.successBlock) {
            self.successBlock(_coordinate);
        }
    } else {
        //2.开始地理编码
        //说明：调用下面的方法开始编码，不管编码是成功还是失败都会调用block中的方法
        [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
            if (error || placemarks.count==0) {
                //self.detailAddressLabel.text=@"你输入的地址没找到，可能在月球上";
            }
            else {  //  编码成功，找到了具体的位置信息
                //打印查看找到的所有的位置信息
                /*
                 name:名称
                 locality:城市
                 country:国家
                 postalCode:邮政编码
                 */
                for (CLPlacemark *placemark in placemarks) {
                    NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
                }
                
                //取出获取的地理信息数组中的第一个显示在界面上
                CLPlacemark *firstPlacemark=[placemarks firstObject];
                
                // 拿到经纬度
                _coordinate = firstPlacemark.location.coordinate;
                if (self.successBlock) {
                    self.successBlock(_coordinate);
                }
            }
        }];
    }
}

/**
 *  反地理编码：经纬度坐标—>地名
 */
- (void)reverseGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate {
    //1.获得输入的经纬度
//    NSString *longtitudeText=self.longitudeField.text;
//    NSString *latitudeText=self.latitudeField.text;
    if (!coordinate.latitude || !coordinate.longitude) {
        return;
    }
    else {
        CLLocationDegrees latitude= coordinate.latitude;
        CLLocationDegrees longitude=coordinate.longitude;
        
        CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        //2.反地理编码
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error||placemarks.count == 0) {
                //self.reverdeDetailAddressLabel.text=@"你输入的地址没找到，可能在月球上";
            }
            else {//编码成功
                //显示最前面的地标信息
                CLPlacemark *firstPlacemark=[placemarks firstObject];
                NSDictionary * addressDic = firstPlacemark.addressDictionary;
                self.block(addressDic);
            }
        }];
    }
}

@end
