//
//  HPRecordPalyerToolManage.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//


/*
 
 当返回HPRecordPalyerToolSpectrum状态时
 最好不要直接渲染到主线程会很卡
 
 可以通过存储在在循环队列中
 然后用一个CADisplayLink 去获取，进行读写分离
 
 */

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HPRecordPalyerToolSuccess,
    HPRecordPalyerToolFailse,
    HPRecordPalyerToolPlayer,
    HPRecordPalyerToolPause,
    HPRecordPalyerToolStop,
    HPRecordPalyerToolSpectrum,//获得频谱数据
} HPRecordPalyerToolState;

@protocol HPRecordPalyerToolDelegate  <NSObject>

 @optional

-(void)hp_recordPlayerState:(HPRecordPalyerToolState)state info:(NSDictionary * _Nullable)info;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPRecordPalyerToolManage : NSObject


@property(nonatomic,weak) id<HPRecordPalyerToolDelegate> delegate;

-(void)hp_recordFilePath:(NSString *)path;

@property(nonatomic,assign,readonly) float duration;
@property(nonatomic,assign,readonly) float currentTime;
@property(nonatomic,assign,readonly) float timeSpace;

- (void)play;

-(void)pause;

-(void)stop;

/// 播放声音的大小
- (float)voiceSize;

@end

NS_ASSUME_NONNULL_END
