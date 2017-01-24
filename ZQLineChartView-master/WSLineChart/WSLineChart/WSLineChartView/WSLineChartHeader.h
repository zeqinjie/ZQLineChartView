//
//  WSLineChartHeader.h
//  WSLineChart
//
//  Created by zhengzeqin on 2017/1/23.
//  Copyright © 2017年 zws. All rights reserved.
//

#ifndef WSLineChartHeader_h
#define WSLineChartHeader_h
#import "UIColor+Util.h"
#import "TWColor.h"
#define WSChartTextColor                 [UIColor colorWithHexString:@"999999"]
#define WSChartLineWhiteColor            [UIColor whiteColor]
#define WSChartLineGrayColor             [UIColor colorWithHexString:@"ebebeb"]
#define WSChartLineBlueColor             [UIColor colorWithHexString:@"437dff"]
#define WSChartLineGreenColor            [UIColor colorWithHexString:@"40c598"]
#define WSChartLineOrangeColor           [UIColor colorWithHexString:@"ff9c40"]
#define WSChartLineGedColor              [UIColor colorWithHexString:@"d43f26"]
#define topMargin 30   // 为顶部留出的空白
#define WSLastSpace 20  //最后一个的空格大小
#define WSNumberOfYAxisElements 5 // y轴分为几段
#define WSWord_Left_Line     5//Y坐标轴文字 距离线的距离
/**非修改**/
#define WSAxisTextGap 5 //注意该值不能被修改 x轴文字与坐标轴间隙
#define WSLeftMargin 45  //留出右边Y坐标轴 的文字区域视图宽度
#define WSScreenWidth [UIScreen mainScreen].bounds.size.width
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#endif /* WSLineChartHeader_h */
