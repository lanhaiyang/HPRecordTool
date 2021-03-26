//
//  HPRecordGraphicBackgroundView.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HPRecordGraphicBackgroundDelegate  <NSObject>

 @optional

-(void)recordGraphicUpdate;

@end

@interface HPRecordGraphicBackgroundView : UIView

@property(nonatomic,strong,readonly) NSArray<NSNumber *> *recordSizes;//0 - 1
-(void)hp_setRecordSizes:(NSArray<NSNumber *> *)recordSizes;
@property(nonatomic,assign) NSInteger recordMaxSecond;//多少秒
@property(nonatomic,assign) NSInteger secondMaxSpeac;//几秒一个大间距
@property(nonatomic,assign) CGFloat secondSpace;//一秒间距
@property(nonatomic,assign) CGFloat rectangleSpace;//声音矩阵与声音矩阵的间距
@property(nonatomic,assign,readonly) CGFloat microsesecondSpace;
@property(nonatomic,assign,readonly) CGFloat centerOffset;
@property(nonatomic,assign,readonly) CGFloat contentOffsetX;

@property(nonatomic,assign,readonly) CGFloat rowTopLineY ;
@property(nonatomic,assign,readonly) CGFloat rowBottomLineBottomSpace ;

@property(nonatomic,weak) id<HPRecordGraphicBackgroundDelegate> delegate;

-(void)hp_updateDisplay;

@end

NS_ASSUME_NONNULL_END
