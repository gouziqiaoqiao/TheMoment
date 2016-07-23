//
//  WJDataModel.h
//  TheMoment
//
//  Created by 千锋 on 16/7/12.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJDataModel : NSObject

@property (nonatomic, copy) NSString *textContent;

@property (nonatomic, copy) NSString *timeNow;

@property (nonatomic, copy) NSString *dataId;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
