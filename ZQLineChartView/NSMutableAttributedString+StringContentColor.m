//
//  NSMutableAttributedString+StringContentColor.m
//  ZQLineChartView
//
//  Created by zhengzqin on 16/8/31.
//  Copyright © 2016年 zhengzqin. All rights reserved.
//

#import "NSMutableAttributedString+StringContentColor.h"
//检查是否为空对象
#define CHECK_NULL(object) ([object isKindOfClass:[NSNull class]]?nil:object)
//空对象 赋予空字符串
#define NullClass(object) (CHECK_NULL(object)?object:@"")
//字符串化
#define NSNumToNSString(object) (CHECK_NULL(object)?[NSString stringWithFormat:@"%@",object]:@"")
@implementation NSMutableAttributedString (StringContentColor)

- (NSMutableAttributedString *)attributeString:(NSString *)context
                                          text:(NSString *)text
                                   contextFont:(UIFont *)contextFont
                                  contextColor:(UIColor *)contextColor
                                      textFont:(UIFont *)textFont
                                     textColor:(UIColor *)textColor{
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:context];
    [self setAttributedString:[[NSAttributedString alloc]initWithString:NullClass(context)]];
    [self addAttributes:@{NSFontAttributeName:contextFont, NSForegroundColorAttributeName:contextColor} range:NSMakeRange(0, [NullClass(context) length])];
    NSRange textRange = [context rangeOfString:NullClass(text)];
    if (textFont) {
        [self addAttribute:NSFontAttributeName value:textFont range:textRange];
    }
    if (textColor) {
        [self addAttribute:NSForegroundColorAttributeName value:textColor range:textRange];
    }
    return self;
}

- (NSMutableAttributedString *)attributeString:(NSString *)context color:(UIColor *)color font:(UIFont *)font{
    [self setAttributedString:[[NSAttributedString alloc]initWithString:NullClass(context)]];
    [self addAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color} range:NSMakeRange(0, [NullClass(context) length])];
    return self;
}

- (NSMutableAttributedString *)attributeString:(NSString *)context
                                     lineSpace:(CGFloat)lineSpace{
    [self setAttributedString:[[NSAttributedString alloc]initWithString:NullClass(context)]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [NullClass(context) length])];
    return self;
}

- (NSMutableAttributedString *)attributeString:(NSString *)context
                                          text:(NSString *)text
                                   contextFont:(UIFont *)contextFont
                                  contextColor:(UIColor *)contextColor
                                      textFont:(UIFont *)textFont
                                     textColor:(UIColor *)textColor
                                     lineSpace:(CGFloat)lineSpace{
    NSMutableAttributedString *attributeString = [self attributeString:context text:text contextFont:contextFont contextColor:contextColor textFont:textFont textColor:textColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [NullClass(context) length])];
    return attributeString;
    
}

- (NSMutableAttributedString *)attributeString:(NSString *)context
                                          text:(NSString *)text
                                    subiteText:(NSString *)subiteText
                                   contextFont:(UIFont *)contextFont
                                      textFont:(UIFont *)textFont
                                subiteTextFont:(UIFont *)subiteTextFont
                                     wordColor:(UIColor *)wordColor{
    NSMutableAttributedString *attributeString =  [self attributeString:context text:text contextFont:contextFont contextColor:wordColor textFont:textFont textColor:wordColor];
    NSRange subiteTextRange = [context rangeOfString:NullClass(subiteText)];
    if (subiteTextFont) {
        [self addAttribute:NSFontAttributeName value:textFont range:subiteTextRange];
    }
    return attributeString;
}
@end
