//
//  HPRecordToolViewModel.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/30.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPRecordToolViewModel : NSObject

@property(nonatomic,strong) NSArray<NSNumber *> *recordMaxs;

-(void)hp_SetRecordMaxWithNumber:(float)number;

@property(nonatomic,assign) BOOL isAcitonPlayer;

-(void)recordRemoveAll;



@end

NS_ASSUME_NONNULL_END
