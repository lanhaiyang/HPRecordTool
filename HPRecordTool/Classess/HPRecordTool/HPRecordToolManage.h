//
//  HPRecordToolManage.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/14.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPRecordToolProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface HPRecordToolManage : NSObject

/// 录音缓存
@property(nonatomic,strong,readonly) NSString *cachePath;
/// 是否在录音
@property(nonatomic,assign,readonly) BOOL isRecorder;

@property(nonatomic,assign,readonly) NSTimeInterval currentTime;

@property(nonatomic,assign,readonly) HPRecordToolRecordState state;

/// 录音状态
@property(nonatomic,weak) id<HPRecordToolProtocol> delegate;

-(void)startRecord;

-(void)stopRecord;

-(void)pauseRecord;

-(void)reset;//重置


/// 获取声音大小
- (float)voiceSize;

/// 获得声音大小以分贝为单位 0-120
- (float)voiceSizeDB;



@end

NS_ASSUME_NONNULL_END
