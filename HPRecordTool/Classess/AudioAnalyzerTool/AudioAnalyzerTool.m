//
//  AudioAnalyzerTool.m
//  HPRecordTool
//
//  Created by sky on 2022/6/22.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import "AudioAnalyzerTool.h"
#import "RealtimeAnalyzer.h"

@interface AudioAnalyzerTool ()

@property (nonatomic, strong) RealtimeAnalyzer *analyer;
@property (nonatomic,strong) AVAudioEngine *engine;
@property (nonatomic, strong) AVAudioPlayerNode *player;
@property (nonatomic, assign) AVAudioFrameCount bufferSize;
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSNumber *> *voiceSizeInfoMs;

@property (nonatomic, strong) AVAudioFile *file;
@property (nonatomic, assign)BOOL isClose;

@end

@implementation AudioAnalyzerTool

-(instancetype)initWithState:(HPRecordAnalyzerState)state confige:(RealtimeConfige *)confige{
    
    if (self = [super init]) {
        
        _state = state;
        _modelConfige = confige;
        [self confige];
        [self creatObj];
    }
    return self;
}

-(void)creatObj{
    
    self.voiceSizeInfoMs = [NSMutableDictionary dictionary];
    self.analyer = [[RealtimeAnalyzer alloc] initWithConfige:_modelConfige];
    _engine = [[AVAudioEngine alloc] init];
    
    switch (self.state) {
        case HPRecordAnalyzerInput:{
            
            [self configeInputAudioEngine];
        }
            break;
        case HPRecordAnalyzerOutput:{
            
            [self configeOutputAudioEngine];
        }
            break;
        default:
            break;
    }
}

-(void)confige{
    
//    AVAudioFormat *outputFormat = [_player outputFormatForBus:0];
}

- (void)configeOutputAudioEngine {
    
    _player = [[AVAudioPlayerNode alloc] init];
    
    [self.engine attachNode:self.player];
    AVAudioMixerNode *mixerNode = self.engine.mainMixerNode;
    [self.engine connect:self.player to:mixerNode format:[mixerNode outputFormatForBus:0]];
    [self.engine startAndReturnError:nil];
    
    [self openAudioEngineWithMixerNode:mixerNode amplitudeLevel:5];
}

- (void)configeInputAudioEngine {
    
    AVAudioInputNode *inputNode = self.engine.inputNode;
    AVAudioMixerNode *mixerNode = self.engine.mainMixerNode;
    [self.engine connect:inputNode to:mixerNode format:[inputNode inputFormatForBus:0]];
    
    [self openAudioEngineWithMixerNode:mixerNode amplitudeLevel:25];
}

-(void)openAudioEngineWithMixerNode:(AVAudioMixerNode *)mixerNode amplitudeLevel:(int)level{
    
    //在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
    [mixerNode removeTapOnBus:0];
    __weak typeof(self) weakSelf = self;
    [mixerNode installTapOnBus:0 bufferSize:self.modelConfige.bufferSize format:[mixerNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        if (weakSelf.state == HPRecordAnalyzerOutput && weakSelf.player.isPlaying == NO) {
            return;
        }

        buffer.frameLength = weakSelf.modelConfige.bufferSize;
        
        NSArray *spectrums = [weakSelf.analyer analyse:buffer withAmplitudeLevel:level];
        if (weakSelf.meteringEnabled == YES) {
            [weakSelf voiceSizeWithChannels:spectrums];
        }
        if ([weakSelf.delegate respondsToSelector:@selector(hp_recorderDidGenerateSpectrumWithDatas:)]) {
            [weakSelf.delegate hp_recorderDidGenerateSpectrumWithDatas:spectrums];
        }
    }];
}


-(void)voiceSizeWithChannels:(NSArray<NSArray<NSNumber *> *> *)channels{
    
    
    for (int i = 0; i < channels.count; i++) {
        
        float numSum = 0.0;
        float numMax = 0.0;
        NSArray<NSNumber *> *amplitudes = channels[i];
        for (NSNumber *amplitude in amplitudes) {
            
            float value = amplitude.floatValue;
            numSum = numSum + value;
            
            if (numMax < value) {
                numMax = value;
            }
        }
        
        float avgf = numSum / amplitudes.count;
        [self.voiceSizeInfoMs setObject:@(avgf) forKey:[self getAvgMaxVodieWithChannel:i]];
        [self.voiceSizeInfoMs setObject:@(numMax) forKey:[self getPeakMaxVodieWithChannel:i]];
    }
    
}



-(NSURL *)urlWithDealStringPath:(NSString *)fileUrl{
    
    if (fileUrl.length > 0) {// 中文转码
        
        // 检查有没有进行过编码，有编码的情况下不再进行编码
        // 取参数部分进行编码
        
        NSString *URLString2 = [fileUrl stringByRemovingPercentEncoding];
        NSString *lastPathComponent = URLString2.lastPathComponent;// 如果是lastPathComponent，则“？”后面必然是参数
        NSRange queryRange = [lastPathComponent rangeOfString:@"?"];//
        if (queryRange.location != NSNotFound && queryRange.length > 0) {
            NSString *queryOrignal = [lastPathComponent substringWithRange:NSMakeRange(queryRange.location+1, lastPathComponent.length -queryRange.location-1)];
            NSString *queryEncode = [queryOrignal stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSString *lastPathComponentEncode = [lastPathComponent stringByReplacingOccurrencesOfString:queryOrignal withString:queryEncode];
            NSString *URLString3 = [URLString2.stringByDeletingLastPathComponent stringByAppendingPathComponent:lastPathComponentEncode];
            
            fileUrl = URLString3;
        }
    }
    
    NSURL *filePath = [NSURL fileURLWithPath:fileUrl];
    
    return filePath;
}


-(BOOL)playerWithFileUrl:(NSString *)fileUrl{
    
    if(fileUrl.length == 0 || self.state != HPRecordAnalyzerOutput){
        return NO;
    }
    
    NSURL *filePath = [self urlWithDealStringPath:fileUrl];
    
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"Kuba Oms - My Love.mp3" withExtension:nil];
//    NSURL *filePath = [NSURL fileURLWithPath:fileUrl];
//    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"Kuba Oms - My Love.mp3" withExtension:nil];
    NSError *error = nil;
    _file = [[AVAudioFile alloc] initForReading:filePath error:&error];
    if (error) {
#if DEBUG
        NSLog(@"create AVAudioFile error: %@", error);
#endif
        return NO;
    }
    [self.player stop];
    [self.player scheduleFile:_file atTime:nil completionHandler:nil];
    
    [self durationWithVideo:filePath];

    
//    [self.player play];
    return YES;
}

- (void)durationWithVideo:(NSURL *)fileUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:fileUrl options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    _duration = second;
    
}

-(void)playerWithTime:(float)seekTime{
    
    // start engine and player
    if (_state == HPRecordAnalyzerInput) {
        return;
    }
    
//    if (_engine == nil || _player == nil || _file == nil || _isClose == YES) {
//        return;
//    }
//    AVAudioFormat *outputFormat = [_player outputFormatForBus:0];
//    AVAudioFramePosition startSampleTime = _player.lastRenderTime.sampleTime + time * outputFormat.sampleRate;
//    AVAudioTime *startTime = [AVAudioTime timeWithSampleTime:startSampleTime atRate:outputFormat.sampleRate];
//    [_player playAtTime:startTime];
    
    seekTime = seekTime > self.duration ? self.duration : seekTime;
    
    AVAudioFile *tempFile = self.file;

    
    seekTime = seekTime > 0 ? seekTime : 0;
    
    AVAudioFramePosition seekFrame = seekTime * tempFile.processingFormat.sampleRate;
    AVAudioFrameCount frameCount = (AVAudioFrameCount)(tempFile.length - seekFrame);
    
    [self.player stop];
    
    //开始播放
    if (seekFrame < (AVAudioFramePosition)tempFile.length) {
        
        [self.player scheduleSegment:tempFile startingFrame:seekFrame frameCount:frameCount atTime:nil completionHandler:^{
            
        }];
    }

}

-(NSString *)getPeakMaxVodieWithChannel:(int)channel{
    
    return [NSString stringWithFormat:@"%d-max",channel];
}

-(NSString *)getAvgMaxVodieWithChannel:(int)channel{
    
    return [NSString stringWithFormat:@"%d",channel];
}

- (float)peakPowerForChannel:(NSUInteger)channelNumber{
    
    int chanelIndex = (int)channelNumber;
    NSNumber *avgf = [self.voiceSizeInfoMs objectForKey:[self getPeakMaxVodieWithChannel:chanelIndex]];
    return avgf.floatValue;
}

-(float)averagePowerForChannel:(NSUInteger)channel{
    
    int chanelIndex = (int)channel;
    NSNumber *avgf = [self.voiceSizeInfoMs objectForKey:[self getAvgMaxVodieWithChannel:chanelIndex]];
    return avgf.floatValue;
}


- (BOOL)startAudioEngine {
    if(_isOpen == YES) return NO;
    
    // start engine and player
    NSError *nsErr = nil;
    if (self.engine.isRunning == NO) {
        
        [self.engine prepare];
        [_engine startAndReturnError:&nsErr];
    }
    
    if (!nsErr) {
        _isOpen = YES;
        [self.player play];
        return YES;
    }
    
    _isOpen = NO;
    return NO;
}

- (void)closeAudioEngine {
    if(_isOpen == NO || _engine.isRunning == NO) return;
    _isOpen = NO;
    _isClose = YES;
    [self.player stop];
    [self.engine stop];
}

- (void)pauseAudioEngine {
    if(_isOpen == NO || _engine.isRunning == NO) return;
    _isOpen = NO;
    [self.player pause];
    [self.engine pause];
}


-(void)dealloc{
    
    [self closeAudioEngine];
    _engine = nil;
    _player = nil;
}

#pragma mark - 懒加载


@end
