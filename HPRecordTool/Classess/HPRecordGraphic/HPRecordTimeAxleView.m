//
//  HPRecordTimeAxleView.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/19.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordTimeAxleView.h"

@interface HPRecordTimeAxleView()

@property(nonatomic,strong) UIView *topRound;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIView *bottomRound;

@end

@implementation HPRecordTimeAxleView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self confige];
        [self layout];
    }
    return self;
}

-(void)confige{
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.bounds.size.width;
    CGFloat h = 5;
    _topRound.frame = CGRectMake(x, y, w, h);
    
    w = 1;
    x = (self.bounds.size.width/2) - (w/2);
    y = h;
    h = self.bounds.size.height - (2 * h);
    _line.frame = CGRectMake(x, y, w, h);
    
    x = 0;
    h = 5;
    y = self.bounds.size.height - h;
    w = self.bounds.size.width;
    _bottomRound.frame = CGRectMake(x, y, w, h);
    
    
}

-(void)layout{
    
    _topRound = [[UIView alloc] init];
    _topRound.backgroundColor = [UIColor blackColor];
    _topRound.layer.cornerRadius = 2.5;
    [self addSubview:_topRound];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor blackColor];
    [self addSubview:_line];
    
    _bottomRound = [[UIView alloc] init];
    _bottomRound.backgroundColor = [UIColor blackColor];
    _bottomRound.layer.cornerRadius = 2.5;
    [self addSubview:_bottomRound];
}


@end
