//
//  WJDataCell.m
//  TheMoment
//
//  Created by 千锋 on 16/7/12.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJDataCell.h"

@interface WJDataCell ()


@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation WJDataCell

- (void)awakeFromNib {
    // Initialization code
    
    
}



#pragma mark - 赋值
- (void)setModel:(WJDataModel *)model {
    
    _model = model;
    _noteLabel.text = model.textContent;
    _timeLabel.text = model.timeNow;
}



@end
