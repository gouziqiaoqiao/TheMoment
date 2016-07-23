//
//  WJNewsModel.h
//  TheMoment
//
//  Created by 王钧 on 16/7/13.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface WJNewsModel : NSObject<YYModel>

// 标题
@property (nonatomic, copy) NSString *title;

// 来源
@property (nonatomic, copy) NSString *source;
// 点击连接
@property (nonatomic, copy) NSString *article_url;

// 时间
@property (nonatomic, copy) NSString *behot_time;


- (NSString *)description;

@end
