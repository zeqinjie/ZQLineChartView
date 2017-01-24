//
//  NSMutableAttributedString+StringContentColor.h
//  ZQLineChartView
//
//  Created by zhengzqin on 16/8/31.
//  Copyright © 2016年 zhengzqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (StringContentColor)
/**
 *  富文本顏色
 *
 *  @param context      全文本
 *  @param text         部分內容
 *  @param contextFont  全文本 字體大小
 *  @param contextColor 全文本 字體顏色
 *  @param textFont     部分內容 字體大小
 *  @param textColor    部分內容 字體顏色
 *
 */
- (NSMutableAttributedString *)attributeString:(NSString *)context
                                          text:(NSString *)text
                                   contextFont:(UIFont *)contextFont
                                  contextColor:(UIColor *)contextColor
                                      textFont:(UIFont *)textFont
                                     textColor:(UIColor *)textColor;


- (NSMutableAttributedString *)attributeString:(NSString *)context
                                         color:(UIColor *)color
                                          font:(UIFont *)font;
/**
 间隙文本

 @param context   文本内容
 @param lineSpace 间隙大小

 */
- (NSMutableAttributedString *)attributeString:(NSString *)context
                                     lineSpace:(CGFloat)lineSpace;


/**
 *  富文本顏色
 *
 *  @param context      全文本
 *  @param text         部分內容
 *  @param contextFont  全文本 字體大小
 *  @param contextColor 全文本 字體顏色
 *  @param textFont     部分內容 字體大小
 *  @param textColor    部分內容 字體顏色
 *  @param lineSpace 间隙大小
 */
- (NSMutableAttributedString *)attributeString:(NSString *)context
                                          text:(NSString *)text
                                   contextFont:(UIFont *)contextFont
                                  contextColor:(UIColor *)contextColor
                                      textFont:(UIFont *)textFont
                                     textColor:(UIColor *)textColor
                                     lineSpace:(CGFloat)lineSpace;


/**
 富文本顏色

 @param context <#context description#>
 @param text <#text description#>
 @param subiteText <#subiteText description#>
 @param contextFont <#contextFont description#>
 @param textFont <#textFont description#>
 @param subiteTextFont <#subiteTextFont description#>
 @param wordColor <#wordColor description#>
 @return <#return value description#>
 */
- (NSMutableAttributedString *)attributeString:(NSString *)context
                                          text:(NSString *)text
                                    subiteText:(NSString *)subiteText
                                   contextFont:(UIFont *)contextFont
                                      textFont:(UIFont *)textFont
                                subiteTextFont:(UIFont *)subiteTextFont
                                     wordColor:(UIColor *)wordColor;
@end
