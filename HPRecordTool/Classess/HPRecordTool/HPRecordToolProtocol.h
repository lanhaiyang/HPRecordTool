//
//  HPRecordToolProtocol.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/14.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HPRecordToolRecordSuccess,
    HPRecordToolRecordFailse,
    HPRecordToolRecordStop,//进入停止
    HPRecordToolRecordPause,//进入暂停
    HPRecordToolRecordCompoundSuccess,//合成成功，可以试听
    HPRecordToolRecordCompoundFailse,//合成失败，可以试听
    HPRecordToolRecordStart,//开始录音
    HPRecordToolProgressChange,//进度发生改变
} HPRecordToolRecordState;

NS_ASSUME_NONNULL_BEGIN

@protocol HPRecordToolProtocol <NSObject>

-(void)hp_recordWithState:(HPRecordToolRecordState)state;


@end

NS_ASSUME_NONNULL_END
