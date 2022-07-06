//
//  RealtimeConfige.h
//  HPRecordTool
//
//  Created by sky on 2022/6/23.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RealtimeConfige : NSObject

/// 默认配置
+(RealtimeConfige *)confige;


/// 设置缓存路径
///
/// 如果为空默认使用 - 使用框架自带的路径
/// 格式:
///   路径/文件名.格式
///   格式要和audioFormat 设置的格式对应
/// 需要注意续录，过程中路径不要发送改变
/// 只有确认录音完成后，才改变路径，不然会出现覆盖问题
-(instancetype)initWithCachePath:(NSString *)cachePath;


@property (nonatomic, strong, readonly) NSString *cachePath;
// 路径的后缀
@property (nonatomic, strong, readonly) NSString *pathExtension;

/// 音频格式
/// 如:
/// [NSNumber numberWithInt: kAudioFormatMPEG4AAC] m4a
/// [NSNumber numberWithInt: kAudioFormatLinearPCM] caf
@property (nonatomic, strong) NSNumber *audioFormat;

/*
 
 下面是控制录音或频谱参数
 
 */

/// 默认取2048
@property (nonatomic, assign) int bufferSize;

/// 返回个数 默认80个
@property (nonatomic, assign) int frequencyBands;

// 开始频谱 默认为100
@property (nonatomic, assign) float startFrequency;
// 结束频谱 默认为18000.0
@property (nonatomic, assign) float endFrequency;

//采样率
@property (nonatomic, assign) float samplingRate;

// 通道数
@property (nonatomic, assign) unsigned int channel;

//缓动系数，数值越大动画越"缓" 默认为0.5
@property (nonatomic, assign) float spectrumSmooth;

@end

NS_ASSUME_NONNULL_END
