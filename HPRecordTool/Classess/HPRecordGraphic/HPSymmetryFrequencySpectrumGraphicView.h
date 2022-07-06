//
//  HPFrequencySpectrumGraphicView.h
//  HPRecordTool
//
//  Created by sky on 2022/6/18.
//  Copyright © 2022 何鹏. All rights reserved.
//

/// 该类用于绘制录音频谱


#import <UIKit/UIKit.h>
#import "HPRecordGraphicProtocol.h"
#import "HPRecordGraphicBase.h"


NS_ASSUME_NONNULL_BEGIN

@interface HPSymmetryFrequencySpectrumGraphicView : UIView

@property (nonatomic, weak) id<HPRecordGraphicProtocol> delegate;


/// 如果直接使用init - 则显示默认显示12个
///
-(instancetype)initWithShowItemCount:(NSUInteger)count;


@property (nonatomic, strong) UIColor *itemColor;


@property (nonatomic, assign) UIEdgeInsets edgeSpace;


//// 频谱到顶部的间距
//@property (nonatomic, assign) CGFloat topSpace;
//
//// 频谱到底部的间距
//@property (nonatomic, assign) CGFloat bottomSpace;

// item 的宽度
@property (nonatomic, assign) CGFloat itemWidth;

// item 和 item 之间间距
@property (nonatomic, assign) CGFloat itemSpace;

// 显示方向
@property (nonatomic, assign) HPFrequencySpectrumShowDirectionState direction;


@property(nonatomic,assign) HPRecordGraphicRectDirect graphicDirect;

@end

NS_ASSUME_NONNULL_END
