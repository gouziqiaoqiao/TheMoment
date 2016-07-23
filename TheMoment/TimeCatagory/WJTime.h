//
//  WJTime.h
//  TheMoment
//
//  Created by 千锋 on 16/7/12.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJTime : NSObject

- (NSString *)getTimeStampWithTime:(NSDate *)date;

- (NSString *)getTimeWithTimeStamp:(NSString *)timeStamp;

@end
