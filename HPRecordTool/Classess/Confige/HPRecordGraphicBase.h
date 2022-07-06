//
//  HPRecordGraphicBase.h
//  HPRecordTool
//
//  Created by 何鹏 on 2021/4/11.
//  Copyright © 2021 何鹏. All rights reserved.
//

#ifndef HPRecordGraphicBase_h
#define HPRecordGraphicBase_h

typedef enum : NSUInteger {
    HPRecordGraphicRectDirectBottom,
    HPRecordGraphicRectDirectTop,
    HPRecordGraphicRectDirectCentre,
} HPRecordGraphicRectDirect;


typedef enum : NSUInteger {
    HPRecordAnalyzerOutput,//播放
    HPRecordAnalyzerInput,//录音
} HPRecordAnalyzerState;


#endif /* HPRecordGraphicBase_h */
