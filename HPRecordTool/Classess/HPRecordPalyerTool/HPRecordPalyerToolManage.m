//
//  HPRecordPalyerToolManage.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordPalyerToolManage.h"
#import <AVFoundation/AVFoundation.h>

#define HPRecordPalyerSpace 0.1

@interface HPRecordPalyerToolManage()<AVAudioPlayerDelegate>

@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) NSTimer *timeObj;
@property(nonatomic,assign) float currentTime;

@end

@implementation HPRecordPalyerToolManage

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)hp_recordFilePath:(NSString *)path{
    
    if (path.length == 0) {
        return;
    }
    
    NSError *error = nil;
    NSURL *pathURL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&error];
    //设置播放进度
    _audioPlayer.currentTime = 0;
    if (error != nil && [_delegate respondsToSelector:@selector(hp_recordPlayerState:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolFailse];
    }else if (error != nil) {
        return;
    }
    
    //是否循环播放
    _audioPlayer.numberOfLoops = 0;
    [_audioPlayer prepareToPlay];
    _audioPlayer.delegate = self;
    
}


-(void)updateProgress{

    _currentTime = _currentTime + HPRecordPalyerSpace;
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolPlayer];
    }
}

- (void)play{
    
    if (_audioPlayer.isPlaying == YES) {
        return;
    }
    
    [self.audioPlayer play];
    [self.timeObj setFireDate:[NSDate distantPast]];
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolPlayer];
    }
}

-(void)pause{
    
    if (_audioPlayer.isPlaying == YES) {
        [_audioPlayer pause];
    }
    [self.timeObj setFireDate:[NSDate distantFuture]];//暂停计时器
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolPause];
    }
}

-(void)stop{
    
    if (_audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    _currentTime = 0;
    _audioPlayer.currentTime = 0;
    [self.timeObj setFireDate:[NSDate distantFuture]];
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolStop];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
   
    [self stop];
}


#pragma mark - 懒加载

-(float)timeSpace{
    
    return HPRecordPalyerSpace;
}

-(float)duration{
    
    return self.audioPlayer.duration;
}

-(NSTimer*)timeObj{
    
    if (_timeObj == nil){

        _timeObj = [NSTimer scheduledTimerWithTimeInterval:HPRecordPalyerSpace target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [_timeObj setFireDate:[NSDate distantFuture]];//在创建计时器的时候把计时器先暂停。
    }
    return _timeObj;
}

-(void)dealloc{
    
    [_timeObj invalidate];
    _timeObj = nil;
}


@end
