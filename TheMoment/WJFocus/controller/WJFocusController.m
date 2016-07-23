//
//  WJFocusController.m
//  TheMoment
//
//  Created by 王钧 on 16/7/16.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJFocusController.h"
#import "FYCountDownView.h"
#import "WJMomentViewController.h"


#define WJCountTimeColor [UIColor colorWithRed:48/255.0 green:157/255.0 blue:216/255.0 alpha:1]

#define NUMBERS @"0123456789"

@interface WJFocusController ()<UIAlertViewDelegate, UITextFieldDelegate> {
    
    NSInteger countTime;
//    WJMomentViewController *_moment;
    
}
@property (weak, nonatomic) IBOutlet UILabel *focusText;

@property (strong, nonatomic) IBOutlet FYCountDownView * countDownView;


@property (nonatomic, weak) IBOutlet UITextField *secondTextField;

@property (weak, nonatomic) IBOutlet UITextField *minuteTextField;

@property (weak, nonatomic) IBOutlet UITextField *hourTextField;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic, strong) WJMomentViewController *moment;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSTimer *scanTimer;


@end

@implementation WJFocusController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    [self startTimer];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 创建界面
    [self creatUI];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {

    
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    // 定时器需要销毁
    [self stopTimer];
    
}

#pragma mark - 定时器
// 开启定时器
- (void)startTimer {
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(repeatPlayText) userInfo:nil repeats:YES];
    
}
// 关闭定时器
- (void)stopTimer {
    
    if (self.scanTimer) {
        [self.scanTimer invalidate];
    }
}

#pragma mark - text的展示
- (void)repeatPlayText {
    // 这里拿到数据进行展示
    
}

#pragma mark - 创建界面
- (void)creatUI {
    
    _btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:24];
    [_btn setTitle:@"开始计时" forState:UIControlStateNormal];
    [_btn setTitleColor:WJCountTimeColor forState:UIControlStateNormal];
    
    _countDownView = [[FYCountDownView alloc] initWithFrame:_countDownView.frame totalTime: countTime lineWidth:3.0 lineColor:WJCountTimeColor startBlock:nil completeBlock:nil];
    
    _hourTextField.delegate = self;
    _minuteTextField.delegate = self;
    _secondTextField.delegate = self;
    //    _minuteTextField.keyboardType = UIKeyboardTypePhonePad;
    //    _secondTextField.keyboardType = UIKeyboardTypeDefault;
    _hourTextField.returnKeyType = UIReturnKeyDone;
    _minuteTextField.returnKeyType = UIReturnKeyDone;
    _secondTextField.returnKeyType = UIReturnKeyDone;
    
    _focusText.text = [NSString stringWithFormat:@"请专注于:%@",_text];
    
}


#pragma mark - 收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger hourTime = [_hourTextField.text integerValue] * 60 * 60;
    NSInteger minTime = [_minuteTextField.text integerValue] * 60;
    countTime = hourTime + minTime + [_secondTextField.text integerValue];
    
    [self.view endEditing:YES];
    
    [self startCount];
    
    return YES;
}

#pragma mark - 限制键盘的输入只能为数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    
    /* 这里的宏必须要加n,不然键盘不能被收回*/
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
    
}


#pragma mark - 收回键盘后的传值
- (void)startCount {
    
    if (countTime == 0) {
        return;
    }
    
    __weak typeof (_btn)weakBtn= _btn;
    FYCountDownView * countView = [[FYCountDownView alloc] initWithFrame:_countDownView.frame totalTime:countTime  lineWidth:3.0 lineColor:WJCountTimeColor  startBlock:^{
        [weakBtn setTitle:@"计时中..." forState:UIControlStateNormal];
        
        // 讲输入框失去交互
        self.hourTextField.userInteractionEnabled = NO;
        self.minuteTextField.userInteractionEnabled = NO;
        self.secondTextField.userInteractionEnabled = NO;
        
    } completeBlock:^{
        [weakBtn setTitle:@"开始计时" forState:UIControlStateNormal];
        
        // 让输入框得到交互
        self.hourTextField.userInteractionEnabled = YES;
        self.minuteTextField.userInteractionEnabled = YES;
        self.secondTextField.userInteractionEnabled = YES;
        
        // 创建分享
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"任务已经完成" message:@"是否分享给小伙伴们" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
        alert.tag = 10;
        [alert show];
        
    }];
    
    [self.view addSubview:self.countDownView = countView];
    
}




#pragma mark - alert的代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 分享
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            NSLog(@"fenxiang");
            
            
            NSString *shareText = [NSString stringWithFormat:@"我已经在当下完成了 %@ 任务,你也来试试吧!",_text];
            
            // 点击cell可以进行分享
            [UMSocialData defaultData].extConfig.title = @"分享的title";
            [UMSocialData defaultData].extConfig.qqData.title = @"记录当下你所想--分享";
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
            [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UMengKey
                                              shareText:shareText
                                             shareImage:[UIImage imageNamed:@"icon"]
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                               delegate:nil];//,UMShareToSina
        }
    }
    
    // 退出当前页面的
    if (alertView.tag == 20) {
        if (buttonIndex == 1) {
            WJMomentViewController *moment = [[WJMomentViewController alloc] init];
            moment.navigationController.navigationBarHidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


#pragma mark - 开始计时按钮的点击事件
- (IBAction)countDownEvent:(UIButton *)sender {
    if (!self.countDownView.isCountingDown) {
        [self.countDownView startCountDown];
    }
}

#pragma mark - 返回上一页的按钮
- (IBAction)backBtn:(UIButton *)sender {
    
    // 如果在倒计时就提示
    if (self.countDownView.isCountingDown) {
        
        UIAlertView *backAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你真的要退出现在的事情?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        backAlert.tag = 20;
        [backAlert show];
        
    }
    else {
        WJMomentViewController *moment = [[WJMomentViewController alloc] init];
        moment.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
