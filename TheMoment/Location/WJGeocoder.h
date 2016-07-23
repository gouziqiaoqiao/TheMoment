//
//  WJGeocoder.h
//  02 - 地址的编码和反编码
//
//  Created by 千锋 on 16/6/6.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^addressBlock)(NSDictionary *);

@interface WJGeocoder : NSObject

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) addressBlock block;

// 根据经纬对获取地址
//+ (void)getAddressWithCoordinate:(CLLocationCoordinate2D) coordinate
//                      didFinshed:(void (^)(NSDictionary *infoDict))address;

// 根据地址获取经纬度
//+ (void)getCoordinateWithAddress:(NSString *) address
//                      didFinshed:(void (^)(CLLocationCoordinate2D coordinate))coordinate;


// 根据地名转经纬度
- (void)geocodeWithAddress:(NSString *)address successBlock:(void(^)(CLLocationCoordinate2D cood))successBlock;


// 根据经纬度转地名
- (void)reverseGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
