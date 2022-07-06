//
//  HPFrequencySpectrumGraphicView.h
//  HPRecordTool
//
//  Created by sky on 2022/7/4.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPRecordGraphicProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPFrequencySpectrumGraphicView : UIView

@property (nonatomic, weak) id<HPRecordGraphicProtocol> delegate;


@property (nonatomic, strong) UIColor *itemColor;


@property (nonatomic, assign) UIEdgeInsets edgeSpace;

// item 的宽度
@property (nonatomic, assign) CGFloat itemWidth;

// item 和 item 之间间距
@property (nonatomic, assign) CGFloat itemSpace;

// 显示方向
@property (nonatomic, assign) HPFrequencySpectrumShowDirectionState direction;


@end

NS_ASSUME_NONNULL_END
