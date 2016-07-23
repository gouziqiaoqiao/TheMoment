//
//  WJDataModel.m
//  TheMoment
//
//  Created by 千锋 on 16/7/12.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJDataModel.h"

@implementation WJDataModel


- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.textContent = dict[@"textContent"];
        self.timeNow = dict[@"noteTime"];
        self.dataId = dict[@"dataId"];
    }
    return self;
}

@end
