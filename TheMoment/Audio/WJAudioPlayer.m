  //
//  WJAudioViewController.m
//  01 - MKMapView
//
//  Created by zeb on 16/7/9.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>



@interface WJAudioPlayer () <AVAudioPlayerDelegate>{

    // 音频播放器只能声明成全局变量
    AVAudioPlayer *_audioPlayer;
    
}


@end

@implementation WJAudioPlayer


#pragma mark - 开始播放
- (void)playWithName:(NSString *)name {
    if (_audioPlayer.isPlaying) {
        return;
    }
    // 1.创建音频播放器对象
    /**
     参数1:需要播放的音频的地址(本地货网页的)
     参数2:错误信息
     */
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    
    [_audioPlayer prepareToPlay];
    // 2.开始播放
    [_audioPlayer play];
    
    // 3.设置代理
    _audioPlayer.delegate = self;
    
    
}

#pragma mark - delegate代理方法
// 音频播放被中断的时候会调用这个方法
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"一般这个方法中会站厅音频");
    [player stop];
}

// 中断结束的时候会调用这个方法
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    // 一般在这个方法中继续播放音频
    [player play];
    NSLog(@"结束播放");
}

// 解码错误的时候会调用这个方法
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"文件出错");
}

@end
