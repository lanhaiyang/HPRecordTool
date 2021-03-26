//
//  HPRecordGraphicViewModel.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/19.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPRecordGraphicViewModel : NSObject

@property(nonatomic,assign) NSInteger recordMaxSecond;//多少秒
@property(nonatomic,assign) CGFloat secondSpace;//一秒间距
@property(nonatomic,assign,readonly) CGFloat graphicW;

@property(nonatomic,assign) CGFloat maxWidth;

@property(nonatomic,assign,readonly) CGFloat axleViewY;
@property(nonatomic,assign,readonly) CGFloat axleViewW;
@property(nonatomic,assign) CGFloat axleViewH;

+ (NSString *)dateFormSeconds:(NSInteger)totalSeconds;

-(void)update;

@end

NS_ASSUME_NONNULL_END
