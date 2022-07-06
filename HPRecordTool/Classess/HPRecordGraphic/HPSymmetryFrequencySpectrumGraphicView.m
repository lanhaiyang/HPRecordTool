//
//  HPFrequencySpectrumGraphicView.m
//  HPRecordTool
//
//  Created by sky on 2022/6/18.
//  Copyright © 2022 何鹏. All rights reserved.
//



#import "HPSymmetryFrequencySpectrumGraphicView.h"


@interface HPSymmetryFrequencySpectrumGraphicView()

/// 频谱
//@property (nonatomic, strong) CAShapeLayer *frequencySpectrumLayer;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *shapeLayerMs;
@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, assign) BOOL isExistRefreshFrequencySpectrumSize;

@property (nonatomic, assign) NSUInteger showItemCount;
@property (nonatomic, strong) NSMutableArray *leveSizeMs;
@property (nonatomic, assign) CGFloat itemHeight;

@end

@implementation HPSymmetryFrequencySpectrumGraphicView


-(instancetype)init{
    
    if (self = [super init]) {
        
        _showItemCount = 12;
        [self confige];
        [self creatObj];
    }
    return self;
}


-(NSInteger)setEvenNumberWithNumber:(NSInteger)number{
    
    if (number > 60) {
        return 60;
    }
    
    if (number%2 == 0) {
        return number;
    }else{
        return number + 1;
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    

    [self updateConfige];
}


-(void)confige{
    
//    _topSpace = 5;
//    _bottomSpace = 5;
    _edgeSpace = UIEdgeInsetsMake(5, 5, 5, 5);
    _itemWidth = 5;
    _itemSpace = 2;
    
    
    
    _direction = HPFrequencySpectrumShowDirectionCentre;
    _graphicDirect = HPRecordGraphicRectDirectCentre;
}


-(void)updateConfige{
    
    _itemHeight = self.bounds.size.height;
}

-(instancetype)initWithShowItemCount:(NSUInteger)count{
    
    if (self = [super init]) {
        
        _showItemCount = [self setEvenNumberWithNumber:count];
        [self confige];
        [self creatObj];
    }
    return self;
}


-(void)creatObj{
    
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dispalyUpdate)];
    
    //CADisplayLink的selector每秒调用次数=60/ frameInterval
    _displaylink.frameInterval = 6;
    [_displaylink addToRunLoop:[NSRunLoop currentRunLoop]
     forMode:NSDefaultRunLoopMode];
    
    self.shapeLayerMs = [NSMutableArray array];
    
    for (int i = 0; i < _showItemCount; i++) {

        // layer 自带动画
        CAShapeLayer *itemline = [CAShapeLayer layer];
        itemline.lineCap       = kCALineCapButt;
        itemline.lineJoin      = kCALineJoinRound;
        itemline.strokeColor   = [[UIColor clearColor] CGColor];
        itemline.fillColor     = [[UIColor clearColor] CGColor];
        [itemline setLineWidth:2];
        itemline.strokeColor   = [self.itemColor CGColor];
        
        [self.layer addSublayer:itemline];
        [self.shapeLayerMs addObject:itemline];
    }
    
    
    self.leveSizeMs = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < self.showItemCount/2 ; i++){
        [self.leveSizeMs addObject:@(0.1)];
    }
}


-(void)dispalyUpdate{
    
    if (_isExistRefreshFrequencySpectrumSize == YES) {
        float sizeLeve = [self.delegate hp_refreshFrequencySpectrumSize];
        if( sizeLeve < 0 || sizeLeve == 0) sizeLeve = 0.1;

        [self.leveSizeMs removeLastObject];
        [self.leveSizeMs insertObject:@(sizeLeve > 1 ? 1 : sizeLeve) atIndex:0];
        [self updateItems];
    }
}

- (void)updateItems
{
    //NSLog(@"updateMeters");
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    /*
     
     int x = self.itemWidth*0.5/self.numberOfItems;
     int z = self.itemWidth*0.2/self.numberOfItems;
     int y = self.itemWidth*0.5 - z;
     
     for(int i=0; i < (self.showItemCount / 2); i++) {
     
         UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
         
         y += x;
      
         [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2+([[self.levelArray objectAtIndex:i]intValue]+1)*z/2)];
         
         [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2-([[self.levelArray objectAtIndex:i]intValue]+1)*z/2)];
         
         CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
         itemLine.path = [itemLinePath CGPath];
         
     }
     
     */
    
    float x = 0;
    
    float viewHeightCentre = self.bounds.size.height/2;
    float viewWidthCentre = self.bounds.size.width/2;
//    NSInteger centre =
    float rightOffset = self.edgeSpace.left + ((_showItemCount/2 - 1) * self.itemSpace) + ((_showItemCount/2) * self.itemWidth);
    float leftOffset = self.bounds.size.width - (self.edgeSpace.right + ((_showItemCount/2 - 1) * self.itemSpace) + ((_showItemCount/2) * self.itemWidth));
    
    if (self.direction == HPFrequencySpectrumShowDirectionLeft) {
        
        x = 0;
    }else if(self.direction == HPFrequencySpectrumShowDirectionCentre){
        
        x = self.bounds.size.width/2;
    }else if(self.direction == HPFrequencySpectrumShowDirectionRight){
        
        x = self.bounds.size.width;
    }
    
    for (int i = 0; i < (self.showItemCount/2); i++) {
        

//        w = self.itemWidth;
//        h = self.itemHeight * leveSize.floatValue;
        


        if (self.direction == HPFrequencySpectrumShowDirectionLeft &&
            self.graphicDirect == HPRecordGraphicRectDirectTop) {
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:(self.showItemCount/2 -1)-i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectLeftLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x rightOffset:rightOffset viewHeightCentre:viewHeightCentre direct:HPRecordGraphicRectDirectTop index:i];
        }else if (self.direction == HPFrequencySpectrumShowDirectionLeft &&
                  self.graphicDirect == HPRecordGraphicRectDirectBottom){
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:(self.showItemCount/2 -1)-i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectLeftLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x rightOffset:rightOffset viewHeightCentre:viewHeightCentre direct:HPRecordGraphicRectDirectBottom index:i];
            
        }else if (self.direction == HPFrequencySpectrumShowDirectionLeft &&
                  self.graphicDirect == HPRecordGraphicRectDirectCentre){
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:(self.showItemCount/2 -1)-i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectLeftLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x rightOffset:rightOffset viewHeightCentre:viewHeightCentre direct:HPRecordGraphicRectDirectCentre index:i];
            
        }else if (self.direction == HPFrequencySpectrumShowDirectionCentre &&
                  self.graphicDirect == HPRecordGraphicRectDirectTop) {
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectCenterLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x rightOffset:rightOffset viewHeightCentre:viewHeightCentre viewWidthCentre:viewWidthCentre direct:HPRecordGraphicRectDirectTop index:i];
            
            
        }else if (self.direction == HPFrequencySpectrumShowDirectionCentre &&
                  self.graphicDirect == HPRecordGraphicRectDirectBottom){
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectCenterLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x rightOffset:rightOffset viewHeightCentre:viewHeightCentre viewWidthCentre:viewWidthCentre direct:HPRecordGraphicRectDirectBottom index:i];
            
        }else if (self.direction == HPFrequencySpectrumShowDirectionCentre &&
                  self.graphicDirect == HPRecordGraphicRectDirectCentre){
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectCenterLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x rightOffset:rightOffset viewHeightCentre:viewHeightCentre viewWidthCentre:viewWidthCentre direct:HPRecordGraphicRectDirectCentre index:i];
            
        }else if (self.direction == HPFrequencySpectrumShowDirectionRight &&
                  self.graphicDirect == HPRecordGraphicRectDirectTop) {
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:(self.showItemCount/2 -1)-i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            
            [self graphicDirectRightLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x leftOffset:leftOffset viewHeightCentre:viewHeightCentre direct:HPRecordGraphicRectDirectTop index:i];
            
        }else if (self.direction == HPFrequencySpectrumShowDirectionRight &&
                  self.graphicDirect == HPRecordGraphicRectDirectBottom){
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:(self.showItemCount/2 -1)-i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectRightLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x leftOffset:leftOffset viewHeightCentre:viewHeightCentre direct:HPRecordGraphicRectDirectBottom index:i];
            
        }else if (self.direction == HPFrequencySpectrumShowDirectionRight &&
                  self.graphicDirect == HPRecordGraphicRectDirectCentre){
            
            NSNumber *leftLeveSize = [self.leveSizeMs objectAtIndex:(self.showItemCount/2 -1)-i];
            NSNumber *rightLeveSize = [self.leveSizeMs objectAtIndex:i];
            
            [self graphicDirectRightLineWithLeftleve:leftLeveSize.floatValue rightLeveSize:rightLeveSize.floatValue x:&x leftOffset:leftOffset viewHeightCentre:viewHeightCentre direct:HPRecordGraphicRectDirectCentre index:i];
            
        }
        
    }
    
    UIGraphicsEndImageContext();
}

-(void)graphicDirectRightLineWithLeftleve:(float)leftleve
                           rightLeveSize:(float)rightLeve
                                   x:(float *)x
                         leftOffset:(float)leftOffset
                    viewHeightCentre:(float)viewHeightCentre
                              direct:(HPRecordGraphicRectDirect)direct
                                   index:(NSInteger)index{
    
    
    float y = 0;
    float w = 0;
    float h = 0;
    if (index == 0) {
        *x = *x - self.edgeSpace.right;
    }else{
        *x = *x - self.itemWidth - self.itemSpace;
    }
    
    float  validHeight = self.itemHeight - self.edgeSpace.top - self.edgeSpace.bottom;
    
    if (direct == HPRecordGraphicRectDirectTop) {
        
        y = self.edgeSpace.top;
        w = self.itemWidth;
        h = validHeight  * leftleve;
    }else if(direct  == HPRecordGraphicRectDirectCentre){
        
        w = self.itemWidth;
        h = validHeight * leftleve;
        y = viewHeightCentre - h/2;
    }else if(direct == HPRecordGraphicRectDirectBottom){
        
        h = validHeight  * leftleve;
        w = self.itemWidth;
        y = self.bounds.size.height - self.edgeSpace.bottom - h;
    }
    
    if ((*x - w ) > self.edgeSpace.left) {
        //left
        UIBezierPath *itemLeftLinePath = [UIBezierPath bezierPath];
        [itemLeftLinePath moveToPoint:CGPointMake(*x, y)];
        [itemLeftLinePath addLineToPoint:CGPointMake(*x, y + h)];
        
        CAShapeLayer *left = [self.shapeLayerMs objectAtIndex:index];
        left.strokeColor   = [self.itemColor CGColor];
        left.path = [itemLeftLinePath CGPath];
        
    }
    

    // right
    float leftX = ((index + 1) * self.itemSpace) + (index * self.itemWidth);
    leftX = leftOffset - leftX; // 偏移
    
    if (direct == HPRecordGraphicRectDirectTop) {
        
        y = self.edgeSpace.top;
        w = self.itemWidth;
        h = validHeight  *  rightLeve;
    }else if(direct  == HPRecordGraphicRectDirectCentre){
        
        w = self.itemWidth;
        h = validHeight * rightLeve;
        y = viewHeightCentre - h/2;
    }else if(direct == HPRecordGraphicRectDirectBottom){
        
        h = validHeight  * rightLeve;
        w = self.itemWidth;
        y = self.bounds.size.height - self.edgeSpace.bottom - h;
    }
    
    if ((leftX - w ) > self.edgeSpace.left) {
        
        UIBezierPath *itemRightLinePath = [UIBezierPath bezierPath];
        [itemRightLinePath moveToPoint:CGPointMake(leftX, y)];
        [itemRightLinePath addLineToPoint:CGPointMake(leftX, y + h)];
        
        CAShapeLayer *right = [self.shapeLayerMs objectAtIndex:(index + (_showItemCount/2))];
        right.strokeColor   = [self.itemColor CGColor];
        right.path = [itemRightLinePath CGPath];
    }
    

    
}


-(void)graphicDirectCenterLineWithLeftleve:(float)leftleve
                           rightLeveSize:(float)rightLeve
                                   x:(float *)x
                         rightOffset:(float)rightOffset
                    viewHeightCentre:(float)viewHeightCentre
                          viewWidthCentre:(float)viewWidthCentre
                              direct:(HPRecordGraphicRectDirect)direct
                                   index:(NSInteger)index{
    
    float y = 0;
    float w = 0;
    float h = 0;
    
    if (index == 0) {
        *x = *x - self.itemSpace;
    }else{
        *x = *x - self.itemSpace - self.itemWidth;
    }
    /* 先回到中间的正常位置 + 右边位置偏移量所产生的间距 */
    float right = viewWidthCentre + ((index * self.itemSpace) + ((index + 1)*self.itemWidth));
    
    float  validHeight = self.itemHeight - self.edgeSpace.top - self.edgeSpace.bottom;
    
    if (direct == HPRecordGraphicRectDirectTop) {
        
        y = self.edgeSpace.top;
        w = self.itemWidth;
        h = validHeight  * leftleve;
    }else if(direct  == HPRecordGraphicRectDirectCentre){
        
        w = self.itemWidth;
        h = validHeight * leftleve;
        y = viewHeightCentre - h/2;
    }else if(direct == HPRecordGraphicRectDirectBottom){
        
        h = validHeight  * leftleve;
        w = self.itemWidth;
        y = self.bounds.size.height - self.edgeSpace.bottom - h;
    }
    
    if (*x > self.edgeSpace.left) { //可以继续添加左边
        
        UIBezierPath *itemLeftLinePath = [UIBezierPath bezierPath];
        [itemLeftLinePath moveToPoint:CGPointMake(*x, y)];
        [itemLeftLinePath addLineToPoint:CGPointMake(*x, y + h)];
        
        CAShapeLayer *left = [self.shapeLayerMs objectAtIndex:index];
        left.strokeColor   = [self.itemColor CGColor];
        left.path = [itemLeftLinePath CGPath];
    }
    
    if (right < self.bounds.size.width - self.edgeSpace.right) {// 有边可以继续添加
        
        UIBezierPath *itemRightLinePath = [UIBezierPath bezierPath];
        [itemRightLinePath moveToPoint:CGPointMake(right, y)];
        [itemRightLinePath addLineToPoint:CGPointMake(right, y + h)];
        
        CAShapeLayer *right = [self.shapeLayerMs objectAtIndex:(index + (_showItemCount/2))];
        right.strokeColor   = [self.itemColor CGColor];
        right.path = [itemRightLinePath CGPath];
    }
}


-(void)graphicDirectLeftLineWithLeftleve:(float)leftleve
                           rightLeveSize:(float)rightLeve
                                   x:(float *)x
                         rightOffset:(float)rightOffset
                    viewHeightCentre:(float)viewHeightCentre
                              direct:(HPRecordGraphicRectDirect)direct
                               index:(NSInteger)index{
    
    
    float y = 0;
    float w = 0;
    float h = 0;
    if (index == 0) {
        *x = self.edgeSpace.left;
    }else{
        *x = *x + self.itemWidth + self.itemSpace;
    }
    
    float  validHeight = self.itemHeight - self.edgeSpace.top - self.edgeSpace.bottom;
    
    if (direct == HPRecordGraphicRectDirectTop) {
        
        y = self.edgeSpace.top;
        w = self.itemWidth;
        h = validHeight  * leftleve;
    }else if(direct  == HPRecordGraphicRectDirectCentre){
        
        w = self.itemWidth;
        h = validHeight * leftleve;
        y = viewHeightCentre - h/2;
    }else if(direct == HPRecordGraphicRectDirectBottom){
        
        h = validHeight  * leftleve;
        w = self.itemWidth;
        y = self.bounds.size.height - self.edgeSpace.bottom - h;
    }
    
    if ((*x + w ) > self.bounds.size.width - self.edgeSpace.right) {
        
        return;
    }
    
    //left
    UIBezierPath *itemLeftLinePath = [UIBezierPath bezierPath];
    [itemLeftLinePath moveToPoint:CGPointMake(*x, y)];
    [itemLeftLinePath addLineToPoint:CGPointMake(*x, y + h)];
    
    CAShapeLayer *left = [self.shapeLayerMs objectAtIndex:index];
    left.strokeColor   = [self.itemColor CGColor];
    left.path = [itemLeftLinePath CGPath];
    
    // right
    float rightX = (*x - self.edgeSpace.left) + _itemSpace;
    rightX = rightOffset + rightX; // 偏移
    
    
    
    
    if ((rightX + w ) > self.bounds.size.width - self.edgeSpace.right) {
        
        return;
    }
    
    if (direct == HPRecordGraphicRectDirectTop) {
        
        y = self.edgeSpace.top;
        w = self.itemWidth;
        h = validHeight  *  rightLeve;
    }else if(direct  == HPRecordGraphicRectDirectCentre){
        
        w = self.itemWidth;
        h = validHeight * rightLeve;
        y = viewHeightCentre - h/2;
    }else if(direct == HPRecordGraphicRectDirectBottom){
        
        h = validHeight  * rightLeve;
        w = self.itemWidth;
        y = self.bounds.size.height - self.edgeSpace.bottom - h;
    }
    
    UIBezierPath *itemRightLinePath = [UIBezierPath bezierPath];
    [itemRightLinePath moveToPoint:CGPointMake(rightX, y)];
    [itemRightLinePath addLineToPoint:CGPointMake(rightX, y + h)];
    
    CAShapeLayer *right = [self.shapeLayerMs objectAtIndex:(index + (_showItemCount/2))];
    right.strokeColor   = [self.itemColor CGColor];
    right.path = [itemRightLinePath CGPath];
    
}

-(void)hp_stop{
    
    [self stopDisplayLink];
}

- (void)stopDisplayLink{
    
    [self.displaylink invalidate];
    self.displaylink = nil;
}


#pragma mark - 懒加载

-(void)setDelegate:(id<HPRecordGraphicProtocol>)delegate{
    
    _delegate = delegate;
    _isExistRefreshFrequencySpectrumSize = [delegate respondsToSelector:@selector(hp_refreshFrequencySpectrumSize)];
}


@end
