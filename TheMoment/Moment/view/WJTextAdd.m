//
//  WJTextAdd.m
//  TheMoment
//
//  Created by zeb on 16/7/2.
//  Copyright © 2016年 wangjun. All rights reserved.
//

/*!
 *  下拉添加
 */

#import "WJTextAdd.h"
#import "WJMomentViewController.h"

@interface WJTextAdd ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *randomBtn;
@end

@implementation WJTextAdd

#pragma mark - 创建界面
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textField];
        [self addSubview:self.voiceBtn];
        [self addSubview:self.randomBtn];
        self.voiceBtn.hidden = YES;
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(15);
            make.centerY.equalTo(self);
        }];
        [@[self.voiceBtn,self.randomBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.right.offset(-20);
            make.left.equalTo(self.textField.mas_right);
            make.centerY.equalTo(self.textField);
        }];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.top.equalTo(self.textField.mas_bottom);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"下拉添加" attributes:@{NSForegroundColorAttributeName: [UIColor cyanColor],
                                                                                                     NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    }
    return _textField;
}

#pragma mark - 语言按钮
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_voiceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];// dx_voice
        [_voiceBtn addTarget:self action:@selector(voiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

#pragma mark - 随机展示数据按钮
- (UIButton *)randomBtn {
    if (!_randomBtn) {
        _randomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_randomBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];// dx_random
        [_randomBtn addTarget:self action:@selector(randomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomBtn;
}


#pragma mark - actions

- (void)voiceBtnClicked:(UIButton*)btn {
    
    NSLog(@"voice");
    
}

- (void)randomBtnClicked:(UIButton*)btn {
    
    
    NSLog(@"random");
    
}

#pragma mark - public methods

- (void)beginEditing {
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"我想..." attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                                 NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    [self.textField becomeFirstResponder];
}

- (void)endEditing {
    
    self.textField.text = nil;
    
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"下拉添加" attributes:@{NSForegroundColorAttributeName: [UIColor cyanColor],
                                                                                                 NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    [self.textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    NSLog(@"eeeeeeeeeeee%@",textField.text);
    
    
    [self.textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(WJTextAddShouldReturn:)]) {
        return [self.delegate WJTextAddShouldReturn:self];
        
    }
    
    return YES;
}




#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.randomBtn.hidden = (BOOL)newString.length;
    self.voiceBtn.hidden = !self.randomBtn.hidden;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.randomBtn.hidden = NO;
    self.voiceBtn.hidden = !self.randomBtn.hidden;
    return YES;
}



@end
