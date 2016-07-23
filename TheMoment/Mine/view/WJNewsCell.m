//
//  WJNewsCell.m
//  TheMoment
//
//  Created by 王钧 on 16/7/13.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJNewsCell.h"

@interface WJNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation WJNewsCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(WJNewsModel *)model {

    _model = model;
    
    _titleLabel.text = model.title;
    _sourceLabel.text = [NSString stringWithFormat:@"来源:%@", model.source];
    
    WJTime *time = [[WJTime alloc] init];
    NSLog(@"%@",model.behot_time);
    CGFloat timeValue = [model.behot_time floatValue] / 1000.f;
    NSLog(@"%.6f", timeValue);
    NSString *timeStr = [NSString stringWithFormat:@"%.6f",timeValue];
    
    _timeLabel.text = [time getTimeWithTimeStamp:timeStr];
    
}


@end
