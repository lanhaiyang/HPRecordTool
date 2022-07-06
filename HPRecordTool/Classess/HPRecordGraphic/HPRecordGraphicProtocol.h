//
//  HPRecordGraphicProtocol.h
//  HPRecordTool
//
//  Created by sky on 2022/6/18.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HPFrequencySpectrumShowDirectionLeft,
    HPFrequencySpectrumShowDirectionRight,
    HPFrequencySpectrumShowDirectionCentre,
} HPFrequencySpectrumShowDirectionState;

NS_ASSUME_NONNULL_BEGIN

@protocol HPRecordGraphicProtocol <NSObject>

-(float)hp_refreshFrequencySpectrumSize;


-(NSArray<NSArray<NSNumber *> *> *)hp_getFrquecySpectrumData;

@end

NS_ASSUME_NONNULL_END
