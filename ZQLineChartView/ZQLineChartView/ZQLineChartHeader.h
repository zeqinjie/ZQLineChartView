//
//  ZQLineChartHeader.h
//  ZQLineChart
//
//  Created by zhengzeqin on 2017/1/23.
//  Copyright © 2017年 zZQ. All rights reserved.
//

#ifndef ZQLineChartHeader_h
#define ZQLineChartHeader_h
#import "UIColor+Util.h"
#import "TWColor.h"
#define ZQChartTextColor                 [UIColor colorWithHexString:@"999999"]
#define ZQChartLineWhiteColor            [UIColor whiteColor]
#define ZQChartLineGrayColor             [UIColor colorWithHexString:@"ebebeb"]
#define ZQChartLineBlueColor             [UIColor colorWithHexString:@"437dff"]
#define ZQChartLineGreenColor            [UIColor colorWithHexString:@"40c598"]
#define ZQChartLineOrangeColor           [UIColor colorWithHexString:@"ff9c40"]
#define ZQChartLineGedColor              [UIColor colorWithHexString:@"d43f26"]
#define topMargin 30   // 为顶部留出的空白
#define ZQLastSpace 20  //最后一个的空格大小
#define ZQNumberOfYAxisElements 5 // y轴分为几段
#define ZQWord_Left_Line     5//Y坐标轴文字 距离线的距离
/**非修改**/
#define ZQAxisTextGap 5 //注意该值不能被修改 x轴文字与坐标轴间隙
#define ZQLeftMargin 45  //留出右边Y坐标轴 的文字区域视图宽度
#define ZQScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZQ(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define ZQWordRectWith  70
#endif /* ZQLineChartHeader_h */
