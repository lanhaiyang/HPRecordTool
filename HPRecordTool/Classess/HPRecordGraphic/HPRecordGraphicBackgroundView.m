//
//  HPRecordGraphicBackgroundView.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordGraphicBackgroundView.h"

@implementation HPRecordGraphicBackgroundView


- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)hp_updateDisplay{
    
    [self setNeedsDisplay];
}

-(void)hp_setRecordSizes:(NSArray<NSNumber *> *)recordSizes{
    
    _recordSizes = recordSizes;
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    _rowTopLineY = 20;
    _rowBottomLineBottomSpace = 10;
    
    [self drawBreakpoint:ctx rect:rect lineY:_rowTopLineY];
    [self drawTopLine:ctx rect:rect lineY:_rowTopLineY];
    [self drawRectangle:ctx topLineY:_rowTopLineY bottomLineY:_rowBottomLineBottomSpace rect:rect];
    [self drawBottomLine:ctx lineY:_rowBottomLineBottomSpace rect:(CGRect)rect];
}

-(void)drawRectangle:(CGContextRef)ctx topLineY:(CGFloat)topLineY bottomLineY:(CGFloat)bottomLineY rect:(CGRect)rect{
    
    CGFloat oldrectangX = 0;
    //设置笔触颜色
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    for (int i = 0; i< _recordSizes.count; i++) {
        NSNumber *recordSize = _recordSizes[i];
        CGFloat size = recordSize.floatValue;
//        printf("size = %lf \n",size);
        CGFloat h = (rect.size.height - topLineY - bottomLineY) * size;
//        printf("r = %lf h = %lf \n",rect.size.height,h);
        //画矩形，长宽相等就是正方形
        CGFloat x = oldrectangX;
        CGFloat y = rect.size.height -  bottomLineY - h;
        CGFloat w = _microsesecondSpace;
        oldrectangX = oldrectangX + w + (_rectangleSpace);
//        NSLog(@"=> %@,%lf",@(CGRectMake(x,y,w,h)),oldrectangX);
        CGContextAddRect(ctx, CGRectMake(x,y,w,h));
        //填充路径
//        CGContextFillPath(ctx);

    }
    _contentOffsetX = oldrectangX;
    CGContextFillPath(ctx);
}

//底部画线
-(void)drawBottomLine:(CGContextRef)ctx lineY:(CGFloat)lineY rect:(CGRect)rect{
    
    //画一条简单的线
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);//设置颜色有很多方法，我觉得这个方法最好用
    CGPoint points1[] = {CGPointMake(0, rect.size.height - lineY),CGPointMake(rect.size.width, rect.size.height - lineY)};
    CGContextAddLines(ctx,points1, 2);
    CGContextStrokePath(ctx);
}

//头部画线
-(void)drawTopLine:(CGContextRef)ctx rect:(CGRect)rect lineY:(CGFloat)lineY{
    
    //画一条简单的线
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);//设置颜色有很多方法，我觉得这个方法最好用
//    CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGPoint points1[] = {CGPointMake(0, lineY),CGPointMake(rect.size.width, lineY)};
    CGContextAddLines(ctx,points1, 2);

    //填充路径
    CGContextStrokePath(ctx);
}

//画线
-(void)drawLine:(CGContextRef)ctx rect:(CGRect)rect lineY:(CGFloat)lineY{
    
    //画一条简单的线
    CGPoint points1[] = {CGPointMake(rect.origin.x, rect.origin.y),CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)};
    CGContextAddLines(ctx,points1, 2);
    //描出笔触
//    CGContextStrokePath(ctx);
}

//间距点
-(void)drawBreakpoint:(CGContextRef)ctx rect:(CGRect)rect lineY:(CGFloat)lineY{
    
    
    CGFloat secondMaxSpeacH = 8;
    CGFloat secondMinSpeac = 3;
    CGFloat titleH = 20;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:12];
    CGFloat lineW = [self textW:@"00:00" font:font lineY:lineY];
//
    CGFloat x = 0;
    CGFloat h = titleH;
    CGFloat y = lineY - secondMaxSpeacH - h;
    CGFloat w = lineW;
    NSInteger startpoint = lineW/2;

    
    if (_secondMaxSpeac == 0) {
        _secondMaxSpeac = 5;
    }
    
    _microsesecondSpace = _secondSpace/10;
    _microsesecondSpace = _microsesecondSpace - _rectangleSpace;
    
    _centerOffset = _secondSpace - startpoint;
    
    CGFloat contentW = 0;
    for (NSInteger i = 0; i <= _recordMaxSecond; i++) {
        
        NSInteger minutes = (NSInteger)(i / 60);
        NSInteger second = i - (minutes * 60);
        
        
        NSString *time = [NSString stringWithFormat:@"%02ld:%02ld",minutes,second];
        CGFloat lineW = [self textW:time font:font lineY:lineY];
        if (i % _secondMaxSpeac == 0) {//大间距
            
            x = startpoint + (i * _secondSpace);
            y = lineY - secondMaxSpeacH;
            w = 2;
            h = secondMaxSpeacH;
            [self drawLine:ctx rect:CGRectMake(x, y, w, h) lineY:lineY];
            
            x = startpoint + (i * _secondSpace) - (lineW/2);
            y = lineY - secondMinSpeac - titleH;
            w = lineW;
            h = titleH;
            [self drawText:ctx rect:CGRectMake(x, y, w, h) font:font text:time];
        }else{//小间距
            
            x = startpoint + (i * _secondSpace);
            y = lineY - secondMinSpeac;
            w = 2;
            h = secondMinSpeac;
            [self drawLine:ctx rect:CGRectMake(x, y, w, h) lineY:lineY];
            
//            x = startpoint + (i * _secondSpace) - (lineW/2);
//            y = lineY - secondMinSpeac - titleH;
//            w = lineW;
//            h = titleH;
//            [self drawText:ctx rect:CGRectMake(x, y, w, h) font:font text:time];
        }
        
        contentW = contentW + _secondSpace;
        
    }
    if ([_delegate respondsToSelector:@selector(recordGraphicUpdate)]) {
        [_delegate recordGraphicUpdate];
    }
    
}

-(void)drawText:(CGContextRef )ctx rect:(CGRect)rect font:(UIFont *)font text:(NSString *)text{
    

    // 文本段落样式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping; // 结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
    textStyle.alignment = NSTextAlignmentCenter; //（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）

    // 文本属性
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
    // NSParagraphStyleAttributeName 段落样式
    [textAttributes setValue:textStyle forKey:NSParagraphStyleAttributeName];
    // NSFontAttributeName 字体名称和大小
    [textAttributes setValue:font forKey:NSFontAttributeName];
    // NSForegroundColorAttributeNam 颜色
    [textAttributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    // 绘制文字
    [text drawInRect:rect withAttributes:textAttributes];
}


-(CGFloat)textW:(NSString *)text font:(UIFont *)font lineY:(CGFloat)lineY{
    
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, lineY)];
    return size.width;
}

@end
