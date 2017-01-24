//
//  YAxisView.m
//  ZQLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zZQ. All rights reserved.
//

#import "YAxisView.h"
#import "ZQLineChartHeader.h"
@interface YAxisView ()

@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;

@end

@implementation YAxisView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame yMax:(CGFloat)yMax yMin:(CGFloat)yMin {
    if (self = [self initWithFrame:frame]) {
        self.yMax = yMax;
        self.yMin = yMin;
    }
    return self;
}

- (void)reloadData:(CGFloat)yMax yMin:(CGFloat)yMin{
    self.yMax = yMax;
    self.yMin = yMin;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIFont *font = [UIFont systemFontOfSize:9];
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 计算坐标轴的位置以及大小
    NSDictionary *attr = @{NSFontAttributeName : font};
    
    CGSize labelSize = [@"x" sizeWithAttributes:attr];

    // Label做占据的高度
    CGFloat allLabelHeight = self.frame.size.height - ZQAxisTextGap - labelSize.height ;
    // Label之间的间隙
//    CGFloat labelMargin = (allLabelHeight + labelSize.height - (numberOfYAxisElements + 1) * labelSize.height) / numberOfYAxisElements;
    CGFloat labelMargin = (allLabelHeight - topMargin )/ZQNumberOfYAxisElements;
    [self drawLine:context startPoint:CGPointMake(self.frame.size.width-ZQLeftMargin, 0) endPoint:CGPointMake(self.frame.size.width-ZQLeftMargin, allLabelHeight) lineColor:ZQChartLineGrayColor lineWidth:1];

    NSDictionary *waterAttr = @{NSFontAttributeName : font};
    CGSize waterLabelSize = [self.unitStr.length?self.unitStr:@"萬/坪" sizeWithAttributes:waterAttr];
    CGFloat wordOrginX = self.frame.size.width-ZQLeftMargin;//self.frame.size.width - 1-5
    CGRect waterRect = CGRectMake(wordOrginX + 5 , 0,waterLabelSize.width,waterLabelSize.height);
    [self.unitStr.length?self.unitStr:@"萬/坪" drawInRect:waterRect withAttributes:@{NSFontAttributeName :font,NSForegroundColorAttributeName:TWColor_808080}];
    if (self.yMax == 0 && self.yMin == 0) {
        CGSize yLabelSize = [[NSString stringWithFormat:@"0"] sizeWithAttributes:waterAttr];
        [@"0" drawInRect:CGRectMake(wordOrginX + 5, allLabelHeight - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :font,NSForegroundColorAttributeName:TWColor_808080}];
        return;
    }
    // 添加Label
    for (int i = 0; i < ZQNumberOfYAxisElements + 1; i++) {

        CGFloat avgValue = (self.yMax - self.yMin) / ZQNumberOfYAxisElements;
//        // 判断是不是小数
//        if ([self isPureFloat:self.yMin + avgValue * i]) {
//            CGSize yLabelSize = [[NSString stringWithFormat:@"%.1f", self.yMin + avgValue * i] sizeWithAttributes:waterAttr];
//            [[NSString stringWithFormat:@"%.1f", self.yMin + avgValue * i] drawInRect:CGRectMake(wordOrginX + 5, allLabelHeight  - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :font,NSForegroundColorAttributeName:TWColor_808080}];
//        }
//        else {
//            CGSize yLabelSize = [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] sizeWithAttributes:waterAttr];
//            [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] drawInRect:CGRectMake(wordOrginX + 5, allLabelHeight - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :font,NSForegroundColorAttributeName:TWColor_808080}];
//        }
        CGSize yLabelSize = [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] sizeWithAttributes:waterAttr];
        [[NSString stringWithFormat:@"%.0f", self.yMin + avgValue * i] drawInRect:CGRectMake(wordOrginX + 5, allLabelHeight - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height) withAttributes:@{NSFontAttributeName :font,NSForegroundColorAttributeName:TWColor_808080}];
    }
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num
{
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}



@end
