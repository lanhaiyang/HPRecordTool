//
//  HPRepetitionActionButton.m
//  HPRecordTool
//
//  Created by 何鹏 on 2021/3/29.
//  Copyright © 2021 何鹏. All rights reserved.
//

#import "HPRepetitionActionButton.h"

@interface HPRepetitionActionButton()

@property(nonatomic,assign) BOOL isPass;

@end

@implementation HPRepetitionActionButton

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _isPass = YES;
        _afterTime = 3;
        [self addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)action{
    
    if (_closeRepetition == NO) {
        

        if (_isPass == NO) {
            return;
        }
        
        _isPass = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.isPass = YES;
        });
        
        if ([self.delegate respondsToSelector:@selector(repetitionAction)]) {
            [self.delegate repetitionAction];
        }
    }else if ([self.delegate respondsToSelector:@selector(repetitionAction)]) {
        
        [self.delegate repetitionAction];
    }
    
}


@end
