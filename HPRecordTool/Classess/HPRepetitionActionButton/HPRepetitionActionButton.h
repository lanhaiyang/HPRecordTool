//
//  HPRepetitionActionButton.h
//  HPRecordTool
//
//  Created by 何鹏 on 2021/3/29.
//  Copyright © 2021 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HPRepetitionActionDelegate  <NSObject>

 @optional

-(void)repetitionAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPRepetitionActionButton : UIButton

@property(nonatomic,assign) BOOL closeRepetition;

@property(nonatomic,assign) NSInteger afterTime;

@property(nonatomic,weak) id<HPRepetitionActionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
