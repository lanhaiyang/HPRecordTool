//
//  RealtimeAnalyzer.h
//  AudioSpectrumDemo
//
//  Created by user on 2019/5/16.
//  Copyright © 2019 adu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#import "RealtimeConfige.h"
NS_ASSUME_NONNULL_BEGIN

@interface RealtimeAnalyzer : NSObject

@property (nonatomic, assign, readonly) int fftSize;

//- (instancetype)initWithFFTSize:(int)fftSize;
-(instancetype)initWithConfige:(RealtimeConfige *)confige;
- (NSArray *)analyse:(AVAudioPCMBuffer *)buffer withAmplitudeLevel:(int)amplitudeLevel;

@end

NS_ASSUME_NONNULL_END
