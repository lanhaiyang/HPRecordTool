//
//  HPRecordGraphicView.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/19.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordGraphicView.h"
#import "HPRecordGraphicBackgroundView.h"
#import "HPRecordGraphicViewModel.h"
#import "HPRecordTimeAxleView.h"

@interface HPRecordGraphicView()<HPRecordGraphicBackgroundDelegate>

@property(nonatomic,strong) HPRecordGraphicViewModel *graphicViewModel;
@property(nonatomic,strong) UIScrollView *timeListView;
@property(nonatomic,strong) HPRecordGraphicBackgroundView *graphicBackgroundView;
@property(nonatomic,strong) HPRecordTimeAxleView *axleView;
@property(nonatomic,assign) CGFloat viewW;
@property(nonatomic,assign) CGFloat duration;
//@property(nonatomic,strong) UIView *view;
@end

@implementation HPRecordGraphicView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self layout];
        [self graphicUpdate];
    }
    return self;
}


-(void)layout{
    
    [self addSubview:self.timeListView];
    [self.timeListView addSubview:self.graphicBackgroundView];
    [self addSubview:self.axleView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _viewW = (self.bounds.size.width/2);
    self.timeListView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.graphicBackgroundView.frame = CGRectMake(0, 0, _graphicViewModel.graphicW + self.bounds.size.width/2, self.bounds.size.height);
//    self.timeListView.contentSize = CGSizeMake(_graphicViewModel.graphicW + self.bounds.size.width/2, 0);
//    _view.frame = CGRectMake(self.bounds.size.width/2 - 0.5, 40, 1, 20);
    
    _graphicViewModel.axleViewH = self.bounds.size.height -
    _graphicViewModel.axleViewY;
 
    if (_isZeroStart == YES) {
        
        CGFloat w = _graphicViewModel.axleViewW;
        CGFloat x = _graphicBackgroundView.firstRectangX - w/2;
        self.axleView.frame = CGRectMake(x, _graphicViewModel.axleViewY, w, _graphicViewModel.axleViewH);
    }else{
        
        self.axleView.frame = CGRectMake(0, _graphicViewModel.axleViewY, _graphicViewModel.axleViewW, _graphicViewModel.axleViewH);
    }
}

-(void)graphicUpdate{
    
    self.graphicViewModel.recordMaxSecond = _recordMaxSecond;
    self.graphicViewModel.secondSpace = _secondSpace;
    [self.graphicViewModel update];
    self.graphicBackgroundView.recordMaxSecond = self.graphicViewModel.recordMaxSecond;
    self.graphicBackgroundView.secondSpace = self.graphicViewModel.secondSpace;
    
    [self.graphicBackgroundView hp_updateDisplay];
}

-(void)recordGraphicUpdate{
    
    self.timeListView.contentSize = CGSizeMake(_graphicViewModel.graphicW + self.bounds.size.width/2  - _graphicBackgroundView.centerOffset, 0);
    

}


-(void)hp_setRecordSizes:(NSArray<NSNumber *> *)recordSizes{
    
    [self.graphicBackgroundView hp_setRecordSizes:recordSizes];
    
    CGFloat offset = 0;
    if (_isZeroStart == YES) {
        
        offset = recordSizes.count * (_graphicBackgroundView.microsesecondSpace + _graphicBackgroundView.rectangleSpace) + _graphicBackgroundView.firstRectangX;
    }else{
        offset = recordSizes.count * (_graphicBackgroundView.microsesecondSpace + _graphicBackgroundView.rectangleSpace);
    }
    if (offset > _viewW + self.graphicBackgroundView.centerOffset) {
     
        self.timeListView.contentOffset = CGPointMake(offset - _viewW - self.graphicBackgroundView.centerOffset , 0);
        
        CGFloat x = _viewW + self.graphicBackgroundView.centerOffset;
        CGFloat y = _axleView.frame.origin.y;
        CGFloat w = _axleView.frame.size.width;
        CGFloat h = _axleView.frame.size.height;
        _axleView.frame = CGRectMake(x, y, w, h);
    }else{
        
        CGFloat x = offset;
        CGFloat y = _axleView.frame.origin.y;
        CGFloat w = _axleView.frame.size.width;
        CGFloat h = _axleView.frame.size.height;
        _axleView.frame = CGRectMake(x, y, w, h);
    }
}

-(void)defalueNumber{

//    _numebr = 0;
    _duration = 0;
}

-(void)hp_offsetXWithZero{
    
    self.timeListView.contentOffset = CGPointMake(0 , 0);
    CGFloat x = 0;
    CGFloat y = _axleView.frame.origin.y;
    CGFloat w = _axleView.frame.size.width;
    CGFloat h = _axleView.frame.size.height;
    _axleView.frame = CGRectMake(x, y, w, h);
}

-(void)hp_PlayerWihtDuration:(float)duration moreSpace:(float)moreSpace{
    
    if (duration * moreSpace >= _viewW + self.graphicBackgroundView.centerOffset) {
    
        self.timeListView.contentOffset = CGPointMake((duration - _duration) * moreSpace, 0);
        
        CGFloat x = _viewW + self.graphicBackgroundView.centerOffset;
        CGFloat y = _axleView.frame.origin.y;
        CGFloat w = _axleView.frame.size.width;
        CGFloat h = _axleView.frame.size.height;
        _axleView.frame = CGRectMake(x, y, w, h);
    }else{
        
        _duration = duration;
        CGFloat x = duration * moreSpace;
        CGFloat y = _axleView.frame.origin.y;
        CGFloat w = _axleView.frame.size.width;
        CGFloat h = _axleView.frame.size.height;
        _axleView.frame = CGRectMake(x, y, w, h);
    }
}



#pragma mark - 懒加载

-(void)setGraphicDirect:(HPRecordGraphicRectDirect)graphicDirect{
    
    _graphicDirect = graphicDirect;
    _graphicBackgroundView.graphicDirect = graphicDirect;
}

-(void)setIsZeroStart:(BOOL)isZeroStart{
    
    _isZeroStart = isZeroStart;
    _graphicBackgroundView.isZeroStart = isZeroStart;
    [_graphicBackgroundView hp_updateDisplay];
    


}

-(CGFloat)secondSpace{
    
    return _graphicViewModel.secondSpace;
}

-(NSInteger)recordMaxSecond{
    
    if (_recordMaxSecond == 0) {
        return 60;
    }
    return _recordMaxSecond;
}




-(UIScrollView *)timeListView{
    
    if (_timeListView == nil) {
        _timeListView = [[UIScrollView alloc] init];
        _timeListView.userInteractionEnabled = NO;
        _timeListView.showsHorizontalScrollIndicator = NO;
        _timeListView.showsVerticalScrollIndicator = NO;
    }
    return _timeListView;
}

-(HPRecordGraphicBackgroundView *)graphicBackgroundView{
    
    if (_graphicBackgroundView == nil) {
        
        _graphicBackgroundView = [[HPRecordGraphicBackgroundView alloc] init];
//        _graphicBackgroundView.recordMaxSecond = 60;
        _graphicBackgroundView.rectangleSpace = 2;
        _graphicBackgroundView.delegate = self;
//        _graphicBackgroundView.textColor = [UIColor greenColor];
//        _graphicBackgroundView.lineColor = [UIColor yellowColor];
//        _graphicBackgroundView.rectangleColor = [UIColor blueColor];
    }
    return _graphicBackgroundView;
}

-(HPRecordGraphicViewModel *)graphicViewModel{
    
    if (_graphicViewModel == nil) {
        _graphicViewModel = [[HPRecordGraphicViewModel alloc] init];
    }
    return _graphicViewModel;
}

-(HPRecordTimeAxleView *)axleView{
    
    if (_axleView == nil) {
        _axleView = [[HPRecordTimeAxleView alloc] init];
    }
    return _axleView;
}

@end
