//
//  HPRecordGraphicView.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/19.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPRecordGraphicView : UIView


@property(nonatomic,assign) NSInteger recordMaxSecond;//多少秒
@property(nonatomic,assign) CGFloat secondSpace;//一秒间距

@property(nonatomic,strong) NSString *maxSecondFormat;

/// 重绘
-(void)graphicUpdate;

-(void)hp_setRecordSizes:(NSArray<NSNumber *> *)recordSizes;

-(void)hp_offsetXWithZero;

-(void)hp_PlayerWihtDuration:(float)duration moreSpace:(float)moreSpace;

-(void)defalueNumber;

- (NSString *)dateFormSeconds:(NSInteger)totalSeconds;


@end

NS_ASSUME_NONNULL_END
