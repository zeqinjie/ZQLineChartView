//
//  WSLineChartView.h
//  WSLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSLineChartHeader.h"
@interface WSLineChartView : UIView

@property (assign,nonatomic)BOOL isShowLabel;//是否显示文字
@property (assign,nonatomic)BOOL isOpenPressGes;//是否開啟長按手勢
@property (assign,nonatomic)BOOL isOpenLongPressGes;//是否開啟長按手勢
@property (assign,nonatomic)BOOL isOpenPinchGes;//是否開啟捏合手勢
@property (strong, nonatomic) NSArray *titleArr;//区域名称
@property (assign,nonatomic) BOOL isShowVerLine;//是否显示垂直线
@property (assign,nonatomic) BOOL isShowHorLine;//是否显示水平线
@property (copy, nonatomic) NSString *unitStr;//单位字段  默认是 萬/坪
/**
 多條線初始化方法
 
 @param xTitleArray Y坐標軸的標線數據
 @param yValueArray X坐標軸的數據源 多組數據
 @param yMax Y坐標軸的標線數據 最小值
 @param yMin Y坐標軸的標線數據 最大值
 */
- (instancetype)initWithFrame:(CGRect)frame
                  xTitleArray:(NSArray*)xTitleArray
                 yValueArrays:(NSArray<NSArray *>*)yValueArrays
                         yMax:(CGFloat)yMax
                         yMin:(CGFloat)yMin;

//刷新數據
- (void)reloadData:(NSArray*)xTitleArray
      yValueArrays:(NSArray<NSArray *>*)yValueArrays
              yMax:(CGFloat)yMax
              yMin:(CGFloat)yMin
         animation:(BOOL)animation;

@end
