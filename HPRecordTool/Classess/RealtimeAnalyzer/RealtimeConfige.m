//
//  RealtimeConfige.m
//  HPRecordTool
//
//  Created by sky on 2022/6/23.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import "RealtimeConfige.h"
#
@implementation RealtimeConfige

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self creatObj];
    }
    return self;
}

-(instancetype)initWithCachePath:(NSString *)cachePath{
    
    if (self = [super init]) {
        
        _cachePath = cachePath;
        [self setPath];
        [self creatObj];
    }
    return self;
}

+(RealtimeConfige *)confige{
    
    return [[RealtimeConfige alloc] init];
}

-(void)setPath{
    
    _pathExtension = [_cachePath pathExtension];
    if (_pathExtension.length == 0) {//后缀是否存在
        _cachePath = nil;
        _pathExtension = nil;
    }
    
    // 从路径后-完整的文件名（带后缀）
    NSString *exestr = [_cachePath lastPathComponent];
    if (exestr.length == 0) {
        _cachePath = nil;
    }
    
    // 文件路径是否存在
    NSString *filePath = [_cachePath stringByReplacingOccurrencesOfString:exestr withString:@""];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
        _cachePath = nil;
    }
    
}

-(void)creatObj{
    
    _channel = 2;
    // m4a
    _audioFormat = [NSNumber numberWithInt:kAudioFormatMPEG4AAC];
    _samplingRate = 44100.0;
    _bufferSize = 2048;
    _frequencyBands = 80;
    _startFrequency = 100.0;
    _endFrequency = 18000.0;
    _spectrumSmooth = 0.5;
}

@end
