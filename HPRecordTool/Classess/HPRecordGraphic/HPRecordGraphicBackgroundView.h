//
//  HPRecordGraphicBackgroundView.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPRecordGraphicBase.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HPRecordGraphicBackgroundDelegate  <NSObject>

 @optional

-(void)recordGraphicUpdate;

@end

@interface HPRecordGraphicBackgroundView : UIView

@property(nonatomic,assign) HPRecordGraphicRectDirect graphicDirect;

@property(nonatomic,strong,readonly) NSArray<NSNumber *> *recordSizes;//0 - 1

/// 绘画矩阵
/// @param recordSizes 绘画矩阵的数据 0 - 1
-(void)hp_setRecordSizes:(NSArray<NSNumber *> *)recordSizes;


/// 更新绘画
-(void)hp_updateDisplay;

/// 是否从非零点开始
@property(nonatomic,assign) BOOL isZeroStart;

@property(nonatomic,assign) NSInteger recordMaxSecond;//多少秒
@property(nonatomic,assign) NSInteger secondMaxSpeac;//几秒一个大间距
@property(nonatomic,assign) CGFloat secondSpace;//一秒间距
@property(nonatomic,assign) CGFloat rectangleSpace;//声音矩阵与声音矩阵的间距
@property(nonatomic,assign) CGFloat fontSize;

@property(nonatomic,assign,readonly) CGFloat microsesecondSpace;
@property(nonatomic,assign,readonly) CGFloat centerOffset;
@property(nonatomic,assign,readonly) CGFloat contentOffsetX;
@property(nonatomic,assign,readonly) CGFloat firstRectangX;
@property(nonatomic,assign,readonly) CGFloat rowTopLineY ;
@property(nonatomic,assign,readonly) CGFloat rowBottomLineBottomSpace ;

@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic,strong) UIColor *lineColor;
@property(nonatomic,strong) UIColor *rectangleColor;

@property(nonatomic,weak) id<HPRecordGraphicBackgroundDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
