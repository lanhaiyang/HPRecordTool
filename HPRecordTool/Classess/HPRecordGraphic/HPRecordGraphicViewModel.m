//
//  HPRecordGraphicViewModel.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/19.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordGraphicViewModel.h"

@implementation HPRecordGraphicViewModel

-(void)update{
    
    if (_recordMaxSecond == 0) {
        _recordMaxSecond = 60;
    }
    if (_secondSpace == 0) {
        _secondSpace = 50;
    }
    _graphicW = (_recordMaxSecond * _secondSpace) + _secondSpace;
}

-(CGFloat)axleViewY{
    
    return 10;
}

-(CGFloat)axleViewW{
    
    return 5;
}

+ (NSString *)dateFormSeconds:(NSInteger)totalSeconds{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    fmt.dateFormat = @"mm:ss";
    return [fmt stringFromDate:date];
}

@end
