//
//  WJTime.m
//  TheMoment
//
//  Created by 千锋 on 16/7/12.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJTime.h"

@implementation WJTime

#pragma mark - 时间--->时间戳
- (NSString *)getTimeStampWithTime:(NSDate *)date {
    
    NSString *timeStamp = [NSString stringWithFormat:@"%lf",[date timeIntervalSince1970]];
    NSLog(@"timeStamp:%@", timeStamp);
    return timeStamp;
}

#pragma mark - 时间戳--->时间
- (NSString *)getTimeWithTimeStamp:(NSString *)timeStamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Chongqing"];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue];
    
    // 将时间转化为字符串返回
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}



@end
