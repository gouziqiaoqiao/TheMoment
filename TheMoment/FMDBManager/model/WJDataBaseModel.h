//
//  WJDataBaseModel.h
//  TheMoment
//
//  Created by 千锋 on 16/7/5.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJDataBaseModel : NSObject

// 正文
@property (nonatomic, copy) NSString *textContent;
// 时间
@property (nonatomic, copy) NSString *time;
// 是否循环
@property (nonatomic, copy) NSString *isCircle;
// 自定义ID
@property (nonatomic, copy) NSString *dataId;

@end
