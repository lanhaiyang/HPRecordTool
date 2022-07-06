//
//  HPRecordPalyerToolManage.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordPalyerToolManage.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioAnalyzerTool.h"
#define HPRecordPalyerSpace 0.1

@interface HPRecordPalyerToolManage()<HPRecordToolProtocol>

/// <AVAudioPlayerDelegate>

//@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) NSTimer *timeObj;
@property(nonatomic,assign) float currentTime;
@property (nonatomic, strong) AudioAnalyzerTool *analyzerTool;

@end

@implementation HPRecordPalyerToolManage

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self creatObj];
    }
    return self;
}

-(void)creatObj{
    
    _analyzerTool = [[AudioAnalyzerTool alloc] initWithState:HPRecordAnalyzerOutput confige:[RealtimeConfige confige]];
}

-(void)hp_recordFilePath:(NSString *)path{
    
    if (path.length == 0) {
        return;
    }
    BOOL isSuccess = [_analyzerTool playerWithFileUrl:path];
    if (isSuccess == NO && [_delegate respondsToSelector:@selector(hp_recordPlayerState:info:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolFailse info:nil];
        return;
    }else if(isSuccess == NO){
        return;
    }
    [_analyzerTool playerWithTime:0];
    _analyzerTool.meteringEnabled = YES;
    _analyzerTool.delegate = self;
    
//    NSError *error = nil;
//    NSURL *pathURL = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:&error];
//    //设置播放进度
//    _audioPlayer.currentTime = 0;
//    _audioPlayer.meteringEnabled = YES;
//    if (error != nil && [_delegate respondsToSelector:@selector(hp_recordPlayerState:)]) {
//        [_delegate hp_recordPlayerState:HPRecordPalyerToolFailse];
//    }else if (error != nil) {
//        return;
//    }
//
//    //是否循环播放
//    _audioPlayer.numberOfLoops = 0;
//    [_audioPlayer prepareToPlay];
//    _audioPlayer.delegate = self;
    
}


-(void)updateProgress{

    _currentTime = _currentTime + HPRecordPalyerSpace;
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:info:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolPlayer info:nil];
    }
}

- (void)play{
    
//    if (_audioPlayer.isPlaying == YES) {
//        return;
//    }
//
//    [self.audioPlayer play];
    
    if (_analyzerTool.isOpen == YES) {
        return;
    }
    
    [self.analyzerTool startAudioEngine];
    [self.timeObj setFireDate:[NSDate distantPast]];
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:info:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolPlayer info:nil];
    }
}

-(void)pause{
    
//    if (_audioPlayer.isPlaying == YES) {
//        [_audioPlayer pause];
//    }
    if (_analyzerTool.isOpen == YES) {
        [_analyzerTool pauseAudioEngine];
    }
    [self.timeObj setFireDate:[NSDate distantFuture]];//暂停计时器
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:info:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolPause info:nil];
    }
}


-(void)stop{
    
//    if (_audioPlayer.isPlaying == YES) {
//        [_audioPlayer stop];
//    }
//    _currentTime = 0;
//    _audioPlayer.currentTime = 0;
    
    if (_analyzerTool.isOpen == YES) {
        [_analyzerTool pauseAudioEngine];
    }
    

    _currentTime = 0;
    [_analyzerTool playerWithTime:0];
    [self.timeObj setFireDate:[NSDate distantFuture]];
    if ([_delegate respondsToSelector:@selector(hp_recordPlayerState:info:)]) {
        [_delegate hp_recordPlayerState:HPRecordPalyerToolStop info:nil];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
   
    [self stop];
}

- (float)voiceSize{
    
    float   level;
    float decibels = [_analyzerTool peakPowerForChannel:0];
    level = decibels * 2;

    return level;
}

#pragma mark - HPRecordToolProtocol


-(void)hp_recorderDidGenerateSpectrumWithDatas:(NSArray *)spectrums{
    
    if (spectrums == nil) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(hp_recordPlayerState:info:)]) {
        [self.delegate hp_recordPlayerState:HPRecordPalyerToolSpectrum info:@{@"spectrums":spectrums}];
    }
}

- (void)hp_recordWithState:(HPRecordToolRecordState)state info:(NSDictionary * _Nullable)info {
    
}


#pragma mark - 懒加载

-(float)timeSpace{
    
    return HPRecordPalyerSpace;
}

-(float)duration{
    
//    return self.audioPlayer.duration;
    return self.analyzerTool.duration;
}

-(NSTimer*)timeObj{
    
    if (_timeObj == nil){

        _timeObj = [NSTimer scheduledTimerWithTimeInterval:HPRecordPalyerSpace target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [_timeObj setFireDate:[NSDate distantFuture]];//在创建计时器的时候把计时器先暂停。
    }
    return _timeObj;
}

-(void)dealloc{
    
    if (_analyzerTool.isOpen == YES) {
        [_analyzerTool closeAudioEngine];
    }
    [_timeObj invalidate];
    _timeObj = nil;
}



@end
