//
//  WJRandomShowView.m
//  TheMoment
//
//  Created by 王钧 on 16/7/1.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//


/*!
 *  随机展示数据的视图
 */

#import "WJRandomShowView.h"
#import "WJMomentViewController.h"

@interface WJRandomShowView ()

// 正文
@property (nonatomic, strong) UILabel *textLabel;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

// 作者
@property (nonatomic, strong) UILabel *name;

@property (nonatomic, strong) UILabel *addLabel;

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation WJRandomShowView

// init
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}


#pragma mark - 创建界面
- (void)creatUI {
    
    // 创建
    _textLabel = [[UILabel alloc] init];
    // 允许换行
    _textLabel.numberOfLines = 0;
    // 设置字体大小
    _textLabel.font = [UIFont systemFontOfSize:13.0f];
    // 设置字体颜色
    _textLabel.textColor = [UIColor lightGrayColor];
    // 添加到父视图
    [self addSubview:_textLabel];
    
    // 创建
    _titleLabel = [[UILabel alloc] init];
    // 对齐
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    // 颜色
    _titleLabel.textColor = [UIColor lightGrayColor];
    // 添加
    [self addSubview:_titleLabel];
    
    // 创建
    _name = [[UILabel alloc] init];
    _name.textColor = [UIColor lightGrayColor];
    // 对齐
    _name.textAlignment = NSTextAlignmentRight;
    _name.font = [UIFont systemFontOfSize:12.0f];
    // 添加
    [self addSubview:_name];
    
//    
//    _addLabel = [[UILabel alloc] init];
//    _addLabel.text = @"加入到计划中吧!^-^";
//    _addLabel.textColor = [UIColor lightGrayColor];
//    _addLabel.font = [UIFont systemFontOfSize:12.0];
//    _addLabel.textAlignment = NSTextAlignmentRight;
//    [self addSubview:_addLabel];
    
    _addBtn = [[UIButton alloc] init];
    _addBtn.frame = CGRectMake(0, 0, 30, 30);
    NSAttributedString *attr = [WJNSAttributed mixImage:[UIImage imageNamed:@"dx_addtonote"] text:@"加入到计划中吧!^-^" textFont:12.0f textColor:[UIColor lightGrayColor]];
    [_addBtn setAttributedTitle:attr forState:UIControlStateNormal];
//    [_addBtn setImage:[UIImage imageNamed:@"dx_addtonote"] forState:UIControlStateNormal];
    [self addSubview:_addBtn];
    
}


#pragma mark - 设置约束
- (void)layoutSubviews {
    
    // 标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(150);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.height.mas_equalTo(30);
        
    }];
    
    // 名字
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_titleLabel.mas_right);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(21);
    }];
    
    
    // 正文
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.right.mas_equalTo(_titleLabel.mas_right);
        make.top.mas_equalTo(_name.mas_bottom).offset(4);
    }];
    
    
    
    // 添加按钮
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_textLabel.mas_bottom).offset(16);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(21);
        make.centerX.mas_equalTo(_textLabel.mas_centerY);
        
    }];
    
//    // 添加文字
//    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(_addBtn.mas_top);
//        make.height.mas_equalTo(_addBtn.mas_height);
//        make.centerY.mas_equalTo(_addBtn.mas_centerY);
//        make.right.mas_equalTo(_addBtn.mas_left).offset(2);
//    }];
    
    
}




#pragma mark - 赋值
- (void)setModel:(WJRandomShowModel *)model {
    
    _model = model;

    _titleLabel.text = model.name[@"zh-Hans"];
    _textLabel.text = model.desc[@"zh-Hans"];
    _name.text = model.writer[@"zh-Hans"];
    
    NSLog(@"%@",model);
}


@end
