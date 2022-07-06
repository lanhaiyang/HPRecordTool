//
//  HPRecordToolManage.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/14.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordToolManage.h"
#import <AVFoundation/AVFoundation.h>
#import "HPRecordCacheManage.h"
#import "AudioAnalyzerTool.h"
#define HPRecordSpeacTime 0.1

@interface HPRecordToolManage()<HPRecordToolProtocol>

@property (nonatomic, strong) AudioAnalyzerTool *analyzerTool;
@property(nonatomic,strong) AVAudioSession *session;
@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) HPRecordCacheManage *cacheManage;
@property(nonatomic,strong) NSTimer *timeObj;

@property(nonatomic,assign) NSTimeInterval currentTime;
@property (nonatomic, assign) AVAudioFrameCount frameLength;//每次获取的大小

@property (nonatomic, assign) AVAudioFrameCount bufferSize;

@property (nonatomic, strong) RealtimeConfige *confige;

@end


@implementation HPRecordToolManage


-(instancetype)initWithConfige:(RealtimeConfige *)confige{
    
    if (self = [super init]) {
        
        [self createWithConfige:confige];
        [self connfige];
        
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self createWithConfige:RealtimeConfige.confige];
        [self connfige];
    }
    return self;
}

-(void)connfige{
    
//    _bufferSize = 2048;
//    _frameLength = (AVAudioFrameCount)_bufferSize;
    
}

-(void)createWithConfige:(RealtimeConfige *)confige{
    
    _confige = confige;
    
    _analyzerTool = [[AudioAnalyzerTool alloc] initWithState:HPRecordAnalyzerInput confige:confige];
    _analyzerTool.delegate = self;
    _analyzerTool.meteringEnabled = YES;
    
    if (_confige.pathExtension.length != 0 && _confige.cachePath.length != 0) {
        self.cacheManage.cachePath = confige.cachePath;
        self.cacheManage.pathExtension = confige.pathExtension;
    }
    
    [self.cacheManage hp_removeMainRecordFile];
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (_session == nil && [_delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
        _state = HPRecordToolRecordFailse;
        [_delegate hp_recordWithState:HPRecordToolRecordFailse info:nil];
    }
    
}


-(void)reset{
    
    _currentTime = 0;
    [self.cacheManage hp_removeMainRecordFile];
}

-(void)startRecord{
    
    if (self.isRecorder == YES && _session == nil) {
        return;
    }
    
    //2.获取文件路径
    NSString *path = @"";
    if ([self.cacheManage hp_isExistCacheMainRecordPath] == NO) {
        
        path = [self.cacheManage hp_cacheMainRecordPath];
    }else{
        
        path = [self.cacheManage hp_cacheAssistRecordPath];
    }
    
    NSURL *cachePathURL = [NSURL fileURLWithPath:path];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:cachePathURL settings:[self configeInfo] error:nil];
    
    if (_recorder == nil && [_delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
        _state = HPRecordToolRecordFailse;
        //音频格式和文件存储格式不匹配,无法初始化Recorder
        [_delegate hp_recordWithState:HPRecordToolRecordFailse info:nil];
        return;
    }else if ([_delegate respondsToSelector:@selector(hp_recordWithState:info:)]){
        
        _state = HPRecordToolRecordSuccess;
        //成功
        [_delegate hp_recordWithState:HPRecordToolRecordSuccess info:nil];
    }
    
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];
    
    if ([_delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
        _state = HPRecordToolRecordStart;
        [_delegate hp_recordWithState:HPRecordToolRecordStart info:nil];
    }
    
    [self.timeObj setFireDate:[NSDate distantPast]];
    [_analyzerTool startAudioEngine];
}

-(void)stopRecord{
    
    if (self.isRecorder == NO) {
        [_recorder stop];
    }
    
    //    _currentTime = 0;
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([_delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
        _state = HPRecordToolRecordStop;
        [_delegate hp_recordWithState:HPRecordToolRecordStop info:nil];
    }
    [self.timeObj setFireDate:[NSDate distantFuture]];//暂停计时器
    [self composeRecord];
    [_analyzerTool closeAudioEngine];
}

-(void)pauseRecord{
    
    if (self.isRecorder == NO) {
        return;
    }
    
    [_recorder stop];
    if ([_delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
        _state = HPRecordToolRecordPause;
        [_delegate hp_recordWithState:HPRecordToolRecordPause info:nil];
    }
     [self.timeObj setFireDate:[NSDate distantFuture]];//暂停计时器
    [self composeRecord];
    [_analyzerTool pauseAudioEngine];
}

-(void)composeRecord{
    
    NSString *fromPath = [self.cacheManage hp_cacheMainRecordPath];
    NSString *toAudio = [self.cacheManage hp_cacheAssistRecordPath];
    [self addAudio:fromPath toAudio:toAudio];
}

- (float)voiceSize{
    
    [self.recorder updateMeters];
    //    return pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -60.0f; // use -80db Or use -60dB, which I measured in a silent room.
    float   decibels    = [_recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels){
        level = 0.0f;
    }
    else if (decibels >= 0.0f){
        level = 1.0f;
    }
    else{
        float   root            = 5.0f; //modified level from 2.0 to 5.0 is neast to real test
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    return level;
}

- (float)analyzerVoiceSize{
    
    float decibels = [_analyzerTool peakPowerForChannel:0];
    float level = decibels * 2;
    return level;
}

- (float)voiceSizeDB{

    float db = [self voiceSize] * 120;//0-120
    return db;
}

#pragma mark 音频的拼接：追加某个音频在某个音频的后面
/**
   音频的拼接

   @param fromPath 前段音频路径
   @param toPath 后段音频路径
 */
-(void)addAudio:(NSString *)fromPath toAudio:(NSString *)toPath{
    
    if (fromPath.length == 0 || toPath.length == 0) {
        return;
    }
    
    
    if ([_cacheManage hp_isExistFileWithFilePath:fromPath] == NO ||
        [_cacheManage hp_isExistFileWithFilePath:toPath] == NO) {
        
        if ([self.delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
            [self.delegate hp_recordWithState:HPRecordToolRecordCompoundSuccess info:nil];
        }
        return;
    }

    // 1. 获取两个音频源
    AVURLAsset *audioAsset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:fromPath]];
    AVURLAsset *audioAsset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:toPath]];

    // 2. 获取两个音频素材中的素材轨道
    AVAssetTrack *audioAssetTrack1 = [[audioAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    AVAssetTrack *audioAssetTrack2 = [[audioAsset2 tracksWithMediaType:AVMediaTypeAudio] firstObject];

    // 3. 向音频合成器, 添加一个空的素材容器
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];

    // 4. 向素材容器中, 插入音轨素材
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset1.duration) ofTrack:audioAssetTrack1 atTime:kCMTimeZero error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset2.duration) ofTrack:audioAssetTrack2 atTime:audioAsset1.duration error:nil];

    // 5. 根据合成器, 创建一个导出对象, 并设置导出参数
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    
    [self.cacheManage hp_removeRecordFile];
    session.outputURL = [NSURL fileURLWithPath:[self.cacheManage hp_cacheMainRecordPath]];
    // 导出类型
    session.outputFileType = AVFileTypeAppleM4A;

    // 6. 开始导出数据
    __weak typeof(self) weakSelf = self;
    [session exportAsynchronouslyWithCompletionHandler:^{
  
          AVAssetExportSessionStatus status = session.status;
          /**
             AVAssetExportSessionStatusUnknown,
             AVAssetExportSessionStatusWaiting,
             AVAssetExportSessionStatusExporting,
             AVAssetExportSessionStatusCompleted,
             AVAssetExportSessionStatusFailed,
             AVAssetExportSessionStatusCancelled
           */
          switch (status) {
               case AVAssetExportSessionStatusUnknown:
//                  NSLog(@"未知状态");
               break;
               case AVAssetExportSessionStatusWaiting:
//                  NSLog(@"等待导出");
               break;
               case AVAssetExportSessionStatusExporting:
//                  NSLog(@"导出中");
               break;
               case AVAssetExportSessionStatusCompleted:{
          
//                  NSLog(@"导出成功，路径是：%@", outputPath);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if ([weakSelf.delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
                           [weakSelf.delegate hp_recordWithState:HPRecordToolRecordCompoundSuccess info:nil];
                       }
                   });
               }
               break;
               case AVAssetExportSessionStatusFailed:{
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if ([weakSelf.delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
                           [weakSelf.delegate hp_recordWithState:HPRecordToolRecordCompoundFailse info:nil];
                       }
                   });
               }
               break;
               case AVAssetExportSessionStatusCancelled:{
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if ([weakSelf.delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
                           [weakSelf.delegate hp_recordWithState:HPRecordToolRecordCompoundFailse info:nil];
                       }
                   });
               }
               break;
               default:
               break;
           }
     }];
}

#pragma mark - 音频的剪切


/**
   音频的剪切

   @param audioPath 要剪切的音频路径
   @param fromTime 开始剪切的时间点
   @param toTime 结束剪切的时间点
   @param outputPath 剪切成功后的音频路径
  */
+(void)cutAudio:(NSString *)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime outputPath:(NSString *)outputPath{

     // 1. 获取音频源
     AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];

     // 2. 创建一个音频会话, 并且,设置相应的配置
     AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
     session.outputFileType = AVFileTypeAppleM4A;
     session.outputURL = [NSURL fileURLWithPath:outputPath];
    CMTime startTime = CMTimeMake(fromTime, 1);
    CMTime endTime = CMTimeMake(toTime, 1);
    session.timeRange = CMTimeRangeFromTimeToTime(startTime, endTime);

     // 3. 导出
     [session exportAsynchronouslyWithCompletionHandler:^{
          AVAssetExportSessionStatus status = session.status;
          if (status == AVAssetExportSessionStatusCompleted)
          {
                NSLog(@"导出成功");
          }
     }];
}

-(void)updateProgress{
    
    _currentTime = _currentTime + HPRecordSpeacTime;
    if ([_delegate respondsToSelector:@selector(hp_recordWithState:info:)]) {
        _state = HPRecordToolProgressChange;
        
//        if (_recorder.format.magicCookie == nil) {
            [_delegate hp_recordWithState:HPRecordToolProgressChange info:nil];
//            return;
//        }
//        AVAudioPCMBuffer *pcmBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:_recorder.format frameCapacity:_frameLength];
//        pcmBuffer.frameLength = _frameLength;
        
        // AVAudioFormat -> AVAudioPCMBuffer

//        [_delegate hp_recordWithState:HPRecordToolProgressChange info:@{@"pcmBuffer":pcmBuffer}];
    }
}

#pragma mark - HPRecordToolProtocol

- (void)hp_recorderDidGenerateSpectrumWithDatas:(NSArray *)spectrums{
    
    if (spectrums == nil) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(hp_recorderDidGenerateSpectrumWithDatas:)]) {
        [self.delegate hp_recorderDidGenerateSpectrumWithDatas:spectrums];
    }
}

-(void)hp_recordWithState:(HPRecordToolRecordState)state info:(NSDictionary  * _Nullable )info{
    
}

#pragma mark - 懒加载

-(NSString *)cachePath{
    
    if ([_cacheManage hp_isExistCacheMainRecordPath] == YES) {
        return [self.cacheManage hp_cacheMainRecordPath];
    }
    return nil;
}

-(BOOL)isRecorder{
    
    return _recorder.isRecording;
}

-(NSTimeInterval)currentTime{
    
    return _currentTime;
}

-(NSDictionary *)configeInfo{
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: (self.confige.samplingRate == 0?8000:self.confige.samplingRate)],AVSampleRateKey,
                                   // 音频格式
                                   (self.confige.audioFormat == nil?[NSNumber numberWithInt: kAudioFormatMPEG4AAC]:self.confige.audioFormat),AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:32],AVLinearPCMIsFloatKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: (self.confige.channel == 0?1:self.confige.channel)], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    return recordSetting;
}


-(HPRecordCacheManage *)cacheManage{
    
    if (_cacheManage == nil) {
        _cacheManage = [[HPRecordCacheManage alloc] init];
    }
    return _cacheManage;
}

-(NSTimer*)timeObj{
    
    if (_timeObj == nil){
        
        // 一微秒
        _timeObj = [NSTimer scheduledTimerWithTimeInterval:HPRecordSpeacTime target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [_timeObj setFireDate:[NSDate distantFuture]];//在创建计时器的时候把计时器先暂停。
    }
    return _timeObj;
}

-(void)dealloc{
    
    [_timeObj invalidate];
    _timeObj = nil;
}


@end
