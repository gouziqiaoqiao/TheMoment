//
//  WJTextAdd.h
//  TheMoment
//
//  Created by zeb on 16/7/2.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJTextAdd;
@protocol TextAddDelegate <NSObject>

- (BOOL)WJTextAddShouldReturn:(WJTextAdd *)textAdd;



@end


@interface WJTextAdd : UIView

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) id <TextAddDelegate> delegate;

- (void)beginEditing;

- (void)endEditing;



@end
