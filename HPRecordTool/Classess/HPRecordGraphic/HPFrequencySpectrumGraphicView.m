//
//  HPFrequencySpectrumGraphicView.m
//  HPRecordTool
//
//  Created by sky on 2022/7/4.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import "HPFrequencySpectrumGraphicView.h"

@interface HPFrequencySpectrumGraphicView()

@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, assign) BOOL isExistMethod;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) NSArray<NSArray<NSNumber *> *> *spectra;

@end

@implementation HPFrequencySpectrumGraphicView

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self creatObj];
        [self confige];
        [self setupView];
    }
    return self;
}


-(void)creatObj{
    
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dispalyUpdate)];
    
    //CADisplayLink的selector每秒调用次数=60/ frameInterval
    _displaylink.frameInterval = 6;
    [_displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)confige {
    CGFloat barSpace = self.frame.size.width / (CGFloat)(80 * 3 - 1); //80与RealtimeAnalyzer中frequencyBands数一致
    self.itemWidth = barSpace * 2;
    self.edgeSpace = UIEdgeInsetsMake(10, 10, 10, 10);
    self.itemSpace = barSpace;
    self.backgroundColor = [UIColor clearColor];
}


- (void)setupView {
    [self.layer addSublayer:self.gradientLayer];
}

-(void)dispalyUpdate{
    
    
    if (self.isExistMethod == YES) {
        _spectra = [self.delegate hp_getFrquecySpectrumData];
        [self updateShowSpectraWithSpectra:_spectra];
    }
}

- (CGFloat)translateAmplitudeToHeight:(float)amplitude {
    
    CGFloat valid = self.bounds.size.height - self.edgeSpace.bottom - self.edgeSpace.top;
    CGFloat barHeight = 0;
    barHeight = valid * (CGFloat)amplitude * 3;
    if (barHeight < 3) {
        barHeight = 3;
    }
    return barHeight;
}


-(void)updateShowSpectraWithSpectra:(NSArray<NSArray<NSNumber *> *> *)spectra{
    
    if (spectra.count == 0) {
        return;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    NSUInteger count = [spectra.firstObject count];
    for (int i = 0; i < count; i++) {

        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat height = 0;
        switch (_direction) {
            case HPFrequencySpectrumShowDirectionLeft:{
                
                x = (CGFloat)i * (self.itemWidth + self.itemSpace) + self.itemSpace + self.edgeSpace.right;
                float spectraFloat = [self getSpectraFloatNumberWithIndex:i spectra:spectra];
                height = [self translateAmplitudeToHeight:spectraFloat];
                y = ((self.bounds.size.height - self.edgeSpace.top - self.edgeSpace.bottom) - height)/2;
                if (x < self.edgeSpace.left || self.bounds.size.width - self.edgeSpace.right < x) {
                    continue;
                }
            }
                break;
            case HPFrequencySpectrumShowDirectionCentre:{
                
                NSInteger centerIndex = count/2;
                if (centerIndex >= i) {
                    
                    float space = (self.bounds.size.width - self.edgeSpace.left - self.edgeSpace.right)/2 - (centerIndex*_itemSpace + centerIndex*_itemWidth);
                    x = space + (CGFloat)(i * (self.itemWidth + self.itemSpace) + self.itemSpace + self.edgeSpace.right);
                    if (x < self.edgeSpace.left) {
                        continue;
                    }
                }else{
                    float space = (self.bounds.size.width - self.edgeSpace.left - self.edgeSpace.right)/2;
                    x = space + (CGFloat)((i - centerIndex) * (self.itemWidth + self.itemSpace) + self.itemSpace + self.edgeSpace.right);
                    if (x > self.bounds.size.width - self.edgeSpace.right) {
                        continue;
                    }
                }
                float spectraFloat = [self getSpectraFloatNumberWithIndex:i spectra:spectra];
                height = [self translateAmplitudeToHeight:spectraFloat];
                y = ((self.bounds.size.height - self.edgeSpace.top - self.edgeSpace.bottom) - height)/2;
            }
                break;
            case HPFrequencySpectrumShowDirectionRight:{
                
                x = self.bounds.size.width - (CGFloat)(i * (self.itemWidth + self.itemSpace) + self.itemSpace + self.edgeSpace.right);
                float spectraFloat = [self getSpectraFloatNumberWithIndex:i spectra:spectra];
                height = [self translateAmplitudeToHeight:spectraFloat];
                y = ((self.bounds.size.height - self.edgeSpace.top - self.edgeSpace.bottom) - height)/2;
                if (x < self.edgeSpace.left) {
                    continue;
                }
            }
                break;
            default:
                break;
        }
        CGRect rect = CGRectMake(x, y, self.itemWidth, height);
        UIBezierPath *bar = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.itemWidth, self.itemWidth)];
        [leftPath appendPath:bar];
    }
    
    CAShapeLayer *leftMaskLayer = [CAShapeLayer layer];
    leftMaskLayer.path = leftPath.CGPath;
    self.gradientLayer.frame = CGRectMake(0, self.edgeSpace.top, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.edgeSpace.top - self.edgeSpace.bottom);
    self.gradientLayer.mask = leftMaskLayer;
    [CATransaction commit];
}


-(float)getSpectraFloatNumberWithIndex:(NSInteger)index spectra:(NSArray<NSArray<NSNumber *> *> *)spectras{
    
    float spectraFloat = 0;
    for (int sectoin = 0; sectoin < spectras.count; sectoin++) {

        
        NSArray *rows = [spectras objectAtIndex:sectoin];
        if (rows.count < index) {
            continue;//越界
        }
        NSNumber *floatNumber = rows[index];
        float spectra = floatNumber.floatValue;
        if (spectraFloat < spectra) {
            spectraFloat = spectra;
        }
    }
//    return spectraFloat;
    if (spectraFloat == 0) {
        spectraFloat = 0.05;
    }
    return spectraFloat;
}


-(void)setDelegate:(id<HPRecordGraphicProtocol>)delegate{
    
    _delegate = delegate;
    _isExistMethod = [self.delegate respondsToSelector:@selector(hp_getFrquecySpectrumData)];
}

#pragma mark - 懒加载

-(void)setItemColor:(UIColor *)itemColor{
    
    _itemColor = itemColor;
    _gradientLayer.backgroundColor = itemColor.CGColor;
}


- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.backgroundColor = [UIColor grayColor].CGColor;
//        _gradientLayer.colors = @[(id)[UIColor colorWithRed:235/255.0 green:18/255.0 blue:26/255.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0].CGColor];
//        _gradientLayer.locations = @[@0.6, @1.0];
    }
    return _gradientLayer;
}

@end
