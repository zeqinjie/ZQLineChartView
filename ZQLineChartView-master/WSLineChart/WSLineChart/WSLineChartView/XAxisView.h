//
//  XAxisView.h
//  WSLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAxisView : UIView


@property (assign, nonatomic) CGFloat pointGap;//点之间的距离
@property (assign,nonatomic) BOOL isShowLabel;//是否显示文字

@property (assign,nonatomic) BOOL isPressing;//是不是按状态

@property (assign, nonatomic) CGPoint currentLoc; //长按时当前定位位置
@property (assign, nonatomic) CGPoint screenLoc; //相对于屏幕位置
@property (strong, nonatomic) NSArray *titleArr;//区域名称
@property (assign,nonatomic) BOOL isShowVerLine;//是否显示垂直线
@property (assign,nonatomic) BOOL isShowHorLine;//是否显示水平线
@property (copy, nonatomic) NSString *unitStr;//单位字段  默认是 萬/坪
- (id)initWithFrame:(CGRect)frame
        xTitleArray:(NSArray*)xTitleArray
       yValueArrays:(NSArray*)yValueArrays
               yMax:(CGFloat)yMax
               yMin:(CGFloat)yMin;

- (void)reloadData:(NSArray*)xTitleArray
      yValueArrays:(NSArray*)yValueArrays
              yMax:(CGFloat)yMax
              yMin:(CGFloat)yMin;
@end
