//
//  XAxisView.m
//  ZQLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zZQ. All rights reserved.
//

#import "XAxisView.h"
#import "ZQLineChartHeader.h"
#import "NSMutableAttributedString+StringContentColor.h"
@interface XAxisView ()

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArrays;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;
@property (assign, nonatomic) CGFloat defaultSpace;
/**
 *  记录坐标轴的第一个frame
 */
@property (assign, nonatomic) CGRect firstFrame;
@property (assign, nonatomic) CGRect firstStrFrame;//第一个点的文字的frame

@end

@implementation XAxisView

#pragma mark - lifeCycle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
        xTitleArray:(NSArray*)xTitleArray
       yValueArrays:(NSArray*)yValueArrays
               yMax:(CGFloat)yMax
               yMin:(CGFloat)yMin{
    self = [self initWithFrame:frame];
    if (self) {
        [self reloadData:xTitleArray yValueArrays:yValueArrays yMax:yMax yMin:yMin];
    }
    return self;
}

#pragma mark - setter && getter
- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    [self setNeedsDisplay];
}

- (void)setIsPressing:(BOOL)isPressing{
    _isPressing = isPressing;
    [self setNeedsDisplay];
}

#pragma mark - drawView
//繪畫
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ///
    [self drawLine:context startPoint:CGPointMake(0, 0) endPoint:CGPointMake(self.frame.size.width, 0) lineColor:ZQChartLineGrayColor lineWidth:1 isArc:NO];
    ////////////////////// X轴文字 //////////////////////////
    // 添加坐标轴Label
    for (int i = 0; i < self.xTitleArray.count; i++) {
        NSString *title = self.xTitleArray[i];
        
        [[UIColor blackColor] set];
        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
        CGSize labelSize = [title sizeWithAttributes:attr];
        
        CGRect titleRect = CGRectMake((i + 1) * self.pointGap - labelSize.width / 2,self.frame.size.height - labelSize.height,labelSize.width,labelSize.height);
        CGFloat verLineY = self.frame.size.height - labelSize.height-10;
        if (self.isShowVerLine) {
            verLineY = 0;
        }
        if (i == 0) {
            self.firstFrame = titleRect;
            if (titleRect.origin.x < 0) {
                titleRect.origin.x = 0;
            }
            
            [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:ZQChartTextColor}];
            
            //画垂直X轴的竖线
            [self drawLine:context
                startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
                  endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, verLineY)
                 lineColor:ZQChartLineGrayColor
                 lineWidth:0.6
                     isArc:NO];
        }
        // 如果Label的文字有重叠，那么不绘制
        CGFloat maxX = CGRectGetMaxX(self.firstFrame);
        if (i != 0) {
            if ((maxX + 3) > titleRect.origin.x) {
                //不绘制
                
            }else{
                
                [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:ZQChartTextColor}];
                //画垂直X轴的竖线 self.frame.size.height - labelSize.height-10
                [self drawLine:context
                    startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
                      endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, verLineY)
                     lineColor:ZQChartLineGrayColor
                     lineWidth:0.6
                         isArc:NO];
                
                self.firstFrame = titleRect;
            }
        }else {
            if (self.firstFrame.origin.x < 0) {
                
                CGRect frame = self.firstFrame;
                frame.origin.x = 0;
                self.firstFrame = frame;
            }
        }

    }
    
    //////////////// 画原点上的x轴 ///////////////////////
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];
    
    [self drawLine:context
        startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5)
          endPoint:CGPointMake(self.frame.size.width, self.frame.size.height - textSize.height - 5)
         lineColor:ZQChartLineGrayColor
         lineWidth:0.6
             isArc:NO];
    

    
    //////////////// 画水平分割线 ///////////////////////
    if (self.isShowHorLine) {
        CGFloat separateMargin = (self.frame.size.height  - ZQAxisTextGap - textSize.height - topMargin  - 5 * 1) / ZQNumberOfYAxisElements;
        for (int i = 0; i < ZQNumberOfYAxisElements; i++) {
            
            [self drawLine:context
                startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
                  endPoint:CGPointMake(0+self.frame.size.width, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
                 lineColor:[UIColor lightGrayColor]
                 lineWidth:.1
                     isArc:NO];
        }
    }
    /////////////////////// 根据数据源画折线 /////////////////////////
    if (self.yValueArrays && self.yValueArrays.count > 0){
        NSArray *chartLineColorArr = @[ZQChartLineBlueColor,ZQChartLineOrangeColor,ZQChartLineGreenColor];
        for (int i = 0 ; i < self.yValueArrays.count; i++) {
            NSArray *yValueArray = self.yValueArrays[i];
            [self drawDataLineContext:context yValueArray:yValueArray textSize:textSize lineColor:chartLineColorArr[i%3]];
        }
    }
    
    //长按时进入
    if(self.isPressing)
    {
        if (self.yValueArrays && self.yValueArrays.count > 0){
            [self drawPressLineContext:context yValueArrays:self.yValueArrays textSize:textSize];
        }
    }
    
}

- (void)drawDataLineContext:(CGContextRef)context yValueArray:(NSArray *)yValueArray textSize:(CGSize)textSize lineColor:(UIColor *)lineColor{
    //画折线
    for (NSInteger i = 0; i < yValueArray.count; i++) {
        //如果是最后一个点
        if (i == yValueArray.count-1) {
            
            NSString *endValue = yValueArray[i];
            CGFloat chartHeight = self.frame.size.height - textSize.height - ZQAxisTextGap - topMargin;
            CGPoint endPoint = CGPointMake((i+1)*self.pointGap, chartHeight -  (endValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
            UIColor *drawDotColor = lineColor;
            if (!endValue.length) {//當前數據為空
                drawDotColor = [UIColor clearColor];
            }
            //画最后一个点
            CGContextSetFillColorWithColor(context, drawDotColor.CGColor);//填充颜色
            CGContextAddArc(context, endPoint.x, endPoint.y, 3, 0, 2*M_PI, 0); //添加一个圆
            CGContextDrawPath(context, kCGPathFill);//绘制填充
            if (_isShowLabel) {
                //画点上的文字
                NSString *str = [NSString stringWithFormat:@"%.0f", endValue.floatValue];
                // 判断是不是小数
                if ([self isPureFloat:endValue.floatValue]) {
                    str = [NSString stringWithFormat:@"%.1f", endValue.floatValue];
                }
                NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
                CGSize strSize = [str sizeWithAttributes:attr];
                CGRect strRect = CGRectMake(endPoint.x-strSize.width/2,endPoint.y-strSize.height,strSize.width,strSize.height);
                // 如果点的文字有重叠，那么不绘制
                CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                if (i != 0) {
                    if ((maxX + 3) > strRect.origin.x) {
                        //不绘制
    
                    }else{
                        [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:ZQChartTextColor}];
    
                        self.firstStrFrame = strRect;
                    }
                }else {
                    if (self.firstStrFrame.origin.x < 0) {
                        
                        CGRect frame = self.firstStrFrame;
                        frame.origin.x = 0;
                        self.firstStrFrame = frame;
                    }
                }
            }

            
        }else {
            NSString *startValue = yValueArray[i];
            NSString *endValue = yValueArray[i+1];
            
            CGFloat chartHeight = self.frame.size.height - textSize.height - ZQAxisTextGap - topMargin;
            CGPoint startPoint = CGPointMake((i+1)*self.pointGap, chartHeight -  (startValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
            CGPoint endPoint = CGPointMake((i+2)*self.pointGap, chartHeight -  (endValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
            
            CGFloat normal[1]={1};
            CGContextSetLineDash(context,0,normal,0); //画实线
            UIColor *drawLineColor = lineColor,*drawDotColor = lineColor;
            if (!endValue.length || !startValue.length) {
                //當字符串是空字符是 隱藏
                drawLineColor = [UIColor clearColor];
            }
            [self drawLine:context startPoint:startPoint endPoint:endPoint lineColor:drawLineColor lineWidth:2 isArc:YES];
            
            if (!startValue.length) {//當前數據為空
                drawDotColor = [UIColor clearColor];
            }
            //画点
//            UIColor*aColor = [UIColor lightGrayColor]; //点的颜色
            CGContextSetFillColorWithColor(context, drawDotColor.CGColor);//填充颜色
            CGContextAddArc(context, startPoint.x, startPoint.y, 3, 0, 2*M_PI, 0); //添加一个圆
            CGContextDrawPath(context, kCGPathFill);//绘制填充
            
            
            if (_isShowLabel) {
                
                //画点上的文字
                NSString *str = str = [NSString stringWithFormat:@"%.0f", startValue.floatValue];
                // 判断是不是小数
                if ([self isPureFloat:startValue.floatValue]) {
                    str = [NSString stringWithFormat:@"%.1f", startValue.floatValue];
                }
                NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
                CGSize strSize = [str sizeWithAttributes:attr];
                
                CGRect strRect = CGRectMake(startPoint.x-strSize.width/2,startPoint.y-strSize.height,strSize.width,strSize.height);
                if (i == 0) {
                    self.firstStrFrame = strRect;
                    if (strRect.origin.x < 0) {
                        strRect.origin.x = 0;
                    }
                    
                    [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:ZQChartTextColor}];
                }
                // 如果点的文字有重叠，那么不绘制
                CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                //            NSLog(@"%f   %f",maxX,strRect.origin.x);
                if (i != 0) {
                    if ((maxX + 3) > strRect.origin.x) {
                        //不绘制
                        
                    }else{
                        
                        [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:ZQChartTextColor}];
                        
                        self.firstStrFrame = strRect;
                    }
                }else {
                    if (self.firstStrFrame.origin.x < 0) {
                        
                        CGRect frame = self.firstStrFrame;
                        frame.origin.x = 0;
                        self.firstStrFrame = frame;
                    }
                }
            }
        }
        
        
    }
}



- (void)drawPressLineContext:(CGContextRef)context yValueArrays:(NSArray *)yValueArrays textSize:(CGSize)textSize{
//    NSLog(@"%f",_currentLoc.x/self.pointGap);

    int nowPoint = _currentLoc.x/self.pointGap;
    NSArray *buildVaules,*areaValues,*cityValues;
    if (yValueArrays.count >= 1)buildVaules = yValueArrays[0];//當前建案
    if (yValueArrays.count >= 2)areaValues = yValueArrays[1];//本區
    if (yValueArrays.count >= 3)cityValues = yValueArrays[2];//本市
    
    if(nowPoint >= 0 && nowPoint < [cityValues count]) {//if(nowPoint >= 0 && nowPoint < [cityValues count])
        NSString *buildVaule,*areaValue,*cityValue;
        if (buildVaules.count > nowPoint) buildVaule = [buildVaules objectAtIndex:nowPoint];
        if (areaValues.count > nowPoint) areaValue = [areaValues objectAtIndex:nowPoint];
        if (cityValues.count > nowPoint) cityValue = [cityValues objectAtIndex:nowPoint];
        
//        NSString *num = [cityValues objectAtIndex:nowPoint];
        CGFloat chartHeight = self.frame.size.height - textSize.height - 5 - topMargin;
        
        CGPoint selectPoint = CGPointMake((nowPoint+1)*self.pointGap, chartHeight -  (cityValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
        
        CGContextSaveGState(context);

        NSDictionary *unitAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
        CGSize unitSize = [[NSString stringWithFormat:@"%@:%@",self.unitStr.length?self.unitStr:@"萬/坪",self.xTitleArray[nowPoint]] sizeWithAttributes:unitAttr];
        
        //画文字所在的位置  动态变化
        CGPoint drawPoint = [self drawPointWithSize:unitSize selectPoint:selectPoint isDynamic:self.isShowDynamic];

        //画选中的红线
        [self drawLine:context startPoint:CGPointMake(selectPoint.x, 0) endPoint:CGPointMake(selectPoint.x, self.frame.size.height- textSize.height - 5) lineColor:ZQChartLineGedColor lineWidth:1 isArc:NO];
        
        if (self.titleArr.count) {
            //画矩形
            [self drawRectangleRect:CGRectMake(drawPoint.x, drawPoint.y, 70, 60) context:context color:[UIColor colorWithHexString:@"233540" alpha:0.75]];
            
            //画文字内容
            [self drawContextPoint:drawPoint nowPoint:nowPoint buildVaule:buildVaule areaValue:areaValue cityValue:cityValue];
        }
        // 交界点
//        CGRect myOval = {selectPoint.x-2, selectPoint.y-2, 4, 4};
//        CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
//        CGContextAddEllipseInRect(context, myOval);
//        CGContextFillPath(context);
    }
}

//画线
- (void)drawLine:(CGContextRef)context
      startPoint:(CGPoint)startPoint
        endPoint:(CGPoint)endPoint
       lineColor:(UIColor *)lineColor
       lineWidth:(CGFloat)width
           isArc:(BOOL)isArc{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    if (isArc) {
        //        CGPoint cp1 = CGPointMake(endPoint.x + (startPoint.x - endPoint.x) / 2.0, startPoint.y );
        //        CGPoint cp2 = CGPointMake(endPoint.x + (startPoint.x - endPoint.x) / 2.0, endPoint.y);
        //        CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, endPoint.x, endPoint.y);
        CGPoint midPoint = [self midPointForPoints:startPoint point2:endPoint];
        CGPoint contrPoint1 = [self controlPointForPoints:midPoint point2:startPoint];
        CGPoint contrPoint2 = [self controlPointForPoints:midPoint point2:endPoint];
        CGContextAddQuadCurveToPoint(context,contrPoint1.x,contrPoint1.y,midPoint.x,midPoint.y);
        CGContextAddQuadCurveToPoint(context,contrPoint2.x,contrPoint2.y,endPoint.x,endPoint.y);
    }else{
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    }
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);

}

//画矩形
- (void)drawRectangleRect:(CGRect)rect context:(CGContextRef)context color:(UIColor *)color{
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGFloat filletRadius = 5;
    
    CGContextMoveToPoint(context, minx, midy);
   
    CGContextAddArcToPoint(context, minx, miny, midx, miny, filletRadius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, filletRadius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, filletRadius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, filletRadius);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
//    CGContextClosePath(context);
//    CGContextSaveGState(context);
}

//画线内容
- (void)drawContextPoint:(CGPoint)drawPoint
                nowPoint:(NSInteger)nowPoint
              buildVaule:(NSString *)buildVaule
               areaValue:(NSString *)areaValue
               cityValue:(NSString *)cityValue{
    //画矩形 画选中的数值
    if (self.titleArr.count >= 1)[[self attribuStrValue:buildVaule text:self.titleArr[0]]drawAtPoint:CGPointMake(drawPoint.x+5, drawPoint.y+8)];
    
    if (self.titleArr.count >= 2)[[self attribuStrValue:areaValue text:self.titleArr[1]]drawAtPoint:CGPointMake(drawPoint.x+5, drawPoint.y+23)];
    
    if (self.titleArr.count >= 3)[[self attribuStrValue:cityValue text:self.titleArr[2]]drawAtPoint:CGPointMake(drawPoint.x+5, drawPoint.y+38)];
    
}

- (NSAttributedString *)attribuStrValue:(NSString *)value text:(NSString *)text{
    NSString *context;
    NSMutableAttributedString *att;
    text = [NSString stringWithFormat:@"%@:",text];
    if (!value.length) {
        context = [NSString stringWithFormat:@"%@-",text];
    }else{
        context = [NSString stringWithFormat:@"%@%.0f",text,[value floatValue]];
        if ([self isPureFloat:[value floatValue]]) {
            context = [NSString stringWithFormat:@"%@%.1f",text,[value floatValue]];
        }
    }
    att = [[NSMutableAttributedString new]attributeString:context text:text contextFont:[UIFont systemFontOfSize:10] contextColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:10] textColor:[UIColor colorWithHexString:@"d1d1d1"]];
    return att;
}

#define GAP  10
- (CGPoint)drawPointWithSize:(CGSize)unitSize selectPoint:(CGPoint)selectPoint isDynamic:(BOOL)isDynamic{
    //画文字所在的位置  动态变化
    CGPoint drawPoint = CGPointZero;
    CGFloat staticPointX = selectPoint.x;
    if(_screenLoc.x >((ZQScreenWidth-ZQLeftMargin)/2) && _screenLoc.y < 80) {
        //如果按住的位置在屏幕靠右边边并且在屏幕靠上面的地方   那么字就显示在按住位置的左上角40 60位置
        drawPoint = CGPointMake(_currentLoc.x-40-unitSize.width, 80-60);
        staticPointX = staticPointX - ZQWordRectWith - GAP;
    }
    else if(_screenLoc.x >((ZQScreenWidth-ZQLeftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
        drawPoint = CGPointMake(_currentLoc.x-40-unitSize.width, self.frame.size.height-20 -60);
        staticPointX = staticPointX - ZQWordRectWith - GAP;
    }
    else if(_screenLoc.x >((ZQScreenWidth-ZQLeftMargin)/2)) {
        //如果按住的位置在屏幕靠右边边并且在屏幕靠下面的地方   那么字就显示在按住位置的左上角40 60位置
        drawPoint = CGPointMake(_currentLoc.x-40-unitSize.width, _currentLoc.y-60);
        staticPointX = staticPointX - ZQWordRectWith - GAP;
    }
    else if (_screenLoc.x <= ((ZQScreenWidth-ZQLeftMargin)/2) && _screenLoc.y < 80) {
        //如果按住的位置在屏幕靠左边边并且在屏幕靠上面的地方   那么字就显示在按住位置的右上角上角40 40位置
        drawPoint = CGPointMake(_currentLoc.x+40, 80-60);
        staticPointX = staticPointX + GAP;
    }
    else if (_screenLoc.x <= ((ZQScreenWidth-ZQLeftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
        drawPoint = CGPointMake(_currentLoc.x+40, self.frame.size.height-20 -60);
        staticPointX = staticPointX + GAP;
    }
    else if(_screenLoc.x  <= ((ZQScreenWidth-ZQLeftMargin)/2)) {
        //如果按住的位置在屏幕靠左边并且在屏幕靠下面的地方    那么字就显示在按住位置的右上角40 60位置
        drawPoint = CGPointMake(_currentLoc.x+40, _currentLoc.y-60);
        staticPointX = staticPointX + GAP;
    }
    if (!isDynamic) {
        drawPoint.x = staticPointX;
        drawPoint.y = (self.frame.size.height - 60)/2;
    }
    
    return drawPoint;
}

#pragma mark - function

- (void)reloadData:(NSArray*)xTitleArray
      yValueArrays:(NSArray*)yValueArrays
              yMax:(CGFloat)yMax
              yMin:(CGFloat)yMin{

    self.xTitleArray = xTitleArray;
    self.yValueArrays = yValueArrays;
    self.yMax = yMax;
    self.yMin = yMin;
    if (xTitleArray.count > 600) {
        _defaultSpace = 5;
    }
    else if (xTitleArray.count > 400 && xTitleArray.count <= 600){
        _defaultSpace = 10;
    }
    else if (xTitleArray.count > 200 && xTitleArray.count <= 400){
        _defaultSpace = 30;
    }
    else if (xTitleArray.count > 100 && xTitleArray.count <= 200){
        _defaultSpace = 40;
    }
    else {
        _defaultSpace = 50;
    }
    self.pointGap = _defaultSpace;
    self.isPressing = NO;
    [self setNeedsDisplay];
}
// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num {
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}

- (CGPoint)midPointForPoints:(CGPoint) p1 point2:(CGPoint) p2 {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

- (CGPoint)controlPointForPoints:(CGPoint) p1 point2:(CGPoint) p2 {
    CGPoint controlPoint = [self midPointForPoints:p1 point2:p2];
    CGFloat diffY = fabs(p2.y - controlPoint.y);
    
    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    
    return controlPoint;
}
@end
