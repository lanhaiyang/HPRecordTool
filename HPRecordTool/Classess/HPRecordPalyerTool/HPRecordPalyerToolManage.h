//
//  HPRecordPalyerToolManage.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HPRecordPalyerToolSuccess,
    HPRecordPalyerToolFailse,
    HPRecordPalyerToolPlayer,
    HPRecordPalyerToolPause,
    HPRecordPalyerToolStop,
} HPRecordPalyerToolState;

@protocol HPRecordPalyerToolDelegate  <NSObject>

 @optional

-(void)hp_recordPlayerState:(HPRecordPalyerToolState)state;

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

@end

NS_ASSUME_NONNULL_END
