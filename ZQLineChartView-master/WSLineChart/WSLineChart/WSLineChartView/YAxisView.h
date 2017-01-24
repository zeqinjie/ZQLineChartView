//
//  YAxisView.h
//  WSLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAxisView : UIView
@property (copy, nonatomic) NSString *unitStr;//单位字段  默认是 萬/坪
- (id)initWithFrame:(CGRect)frame yMax:(CGFloat)yMax yMin:(CGFloat)yMin;
- (void)reloadData:(CGFloat)yMax yMin:(CGFloat)yMin;
@end
