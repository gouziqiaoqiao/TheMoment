//
//  WJNewsModel.m
//  TheMoment
//
//  Created by 王钧 on 16/7/13.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJNewsModel.h"

@implementation WJNewsModel


- (NSString *)description {
    NSString *str = [NSString stringWithFormat:@"%@  `   %@    `%@    `%@",_article_url, _title, _source, _behot_time];
    return str;
}

@end
