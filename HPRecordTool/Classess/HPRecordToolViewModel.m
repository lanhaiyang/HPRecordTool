//
//  HPRecordToolViewModel.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/30.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordToolViewModel.h"

@interface HPRecordToolViewModel()

@property(nonatomic,strong) NSMutableArray<NSNumber *> *recordMaxMs;

@property(nonatomic,assign) NSInteger number;

@end

@implementation HPRecordToolViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self creatObj];
    }
    return self;
}

-(void)creatObj{
    
    _recordMaxMs = [NSMutableArray array];
}

-(void)hp_SetRecordMaxWithNumber:(float)number{
    
    if (number == 0.0) {
        number = 0.05;//默认为0.05
    }
    [_recordMaxMs addObject:@(number)];
}


-(void)defaultConfige{
    
    _number = 1;
}


-(NSInteger )getRecordMaxsAddNumber{
    
    _number = _number + 1;
    if (_number > _recordMaxMs.count) {
        return _recordMaxMs.count;
    }
    return _number;
}


-(void)recordRemoveAll{
    
    [_recordMaxMs removeAllObjects];
}


-(NSArray<NSNumber *> *)recordMaxs{
    
    return [_recordMaxMs copy];
}





@end
