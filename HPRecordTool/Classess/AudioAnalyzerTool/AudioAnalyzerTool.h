//
//  AudioAnalyzerTool.h
//  HPRecordTool
//
//  Created by sky on 2022/6/22.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HPRecordGraphicBase.h"
#import "HPRecordToolProtocol.h"
#import "RealtimeConfige.h"

NS_ASSUME_NONNULL_BEGIN


@interface AudioAnalyzerTool : NSObject

@property (nonatomic, strong,readonly) RealtimeConfige *modelConfige;

@property (nonatomic, assign,readonly) HPRecordAnalyzerState state;

@property (nonatomic, weak) id<HPRecordToolProtocol> delegate;


-(instancetype)initWithState:(HPRecordAnalyzerState)state confige:(RealtimeConfige *)confige;


-(BOOL)playerWithFileUrl:(NSString *)fileUrl;


-(void)playerWithTime:(float)seekTime;

/* 是否打开计量功能 */;
@property (nonatomic, assign) BOOL meteringEnabled;

@property (nonatomic, assign, readonly) BOOL isOpen;


@property (nonatomic, assign) float currentTime;

@property (nonatomic, assign,readonly) NSInteger duration;


- (BOOL)startAudioEngine ;

- (void)closeAudioEngine ;

- (void)pauseAudioEngine ;

/// 必须 调用 startAudioEngine  而且 meteringEnabled = YES
- (float)peakPowerForChannel:(NSUInteger)channelNumber;

/// 必须 调用 startAudioEngine  而且 meteringEnabled = YES
-(float)averagePowerForChannel:(NSUInteger)channel;

-(void)voiceSizeWithChannels:(NSArray<NSArray<NSNumber *> *> *)channels;


-(NSURL *)urlWithDealStringPath:(NSString *)fileUrl;

@end

NS_ASSUME_NONNULL_END
