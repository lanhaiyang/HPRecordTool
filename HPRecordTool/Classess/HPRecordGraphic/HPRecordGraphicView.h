//
//  HPRecordGraphicView.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/19.
//  Copyright © 2020 何鹏. All rights reserved.
//
//  具体可以去更新: https://github.com/lanhaiyang/HPRecordTool

#import <UIKit/UIKit.h>
#import "HPRecordGraphicBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPRecordGraphicView : UIView


@property(nonatomic,assign) HPRecordGraphicRectDirect graphicDirect;

@property(nonatomic,assign) NSInteger recordMaxSecond;//多少秒
@property(nonatomic,assign) CGFloat secondSpace;//一秒间距

@property(nonatomic,assign) BOOL isZeroStart;

@property(nonatomic,strong) NSString *maxSecondFormat;

/// 重绘
-(void)graphicUpdate;

-(void)hp_setRecordSizes:(NSArray<NSNumber *> *)recordSizes;

-(void)hp_offsetXWithZero;

-(void)hp_PlayerWihtDuration:(float)duration moreSpace:(float)moreSpace;

-(void)defalueNumber;



@end

NS_ASSUME_NONNULL_END
