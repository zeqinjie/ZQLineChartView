
//
//  ZQLineChartView.m
//  ZQLineChart
//
//  Created by iMac on 16/11/17.
//  Copyright © 2016年 zZQ. All rights reserved.
//

#import "ZQLineChartView.h"
#import "XAxisView.h"
#import "YAxisView.h"

@interface ZQLineChartView ()

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArrays;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;
@property (strong, nonatomic) YAxisView *yAxisView;
@property (strong, nonatomic) XAxisView *xAxisView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat pointGap;
@property (assign, nonatomic) CGFloat defaultSpace;//间距
@property (assign, nonatomic) CGFloat moveDistance;
@property (strong, nonatomic) UITapGestureRecognizer *tapGes;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGes;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGes;
@end

@implementation ZQLineChartView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self creatLine];
        [self creatYAxisView];//劃Y軸單位視圖
        [self creatXAxisView];//劃X軸數據視圖
        [self initGes];//開啟手勢
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                  xTitleArray:(NSArray*)xTitleArray
                 yValueArrays:(NSArray<NSArray *>*)yValueArrays
                         yMax:(CGFloat)yMax
                         yMin:(CGFloat)yMin{
    self = [self initWithFrame:frame];
    if (self) {
        [self reloadData:xTitleArray yValueArrays:yValueArrays yMax:yMax yMin:yMin animation:YES];//設置數據
    }
    return self;
}

#pragma mark - setter
- (void)setIsShowLabel:(BOOL)isShowLabel{
    _isShowLabel = isShowLabel;
    self.xAxisView.isShowLabel = isShowLabel;
    [self.xAxisView setNeedsDisplay];
}

- (void)setIsOpenPressGes:(BOOL)isOpenPressGes{
    _isOpenPressGes = isOpenPressGes;
    self.tapGes.enabled = isOpenPressGes;
}

- (void)setIsOpenLongPressGes:(BOOL)isOpenLongPressGes{
    _isOpenLongPressGes = isOpenLongPressGes;
    self.longPressGes.enabled = isOpenLongPressGes;
}

- (void)setIsOpenPinchGes:(BOOL)isOpenPinchGes{
    _isOpenPinchGes = isOpenPinchGes;
    self.pinchGes.enabled = isOpenPinchGes;
}

- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    self.xAxisView.titleArr = titleArr;
}

- (void)setIsShowVerLine:(BOOL)isShowVerLine{
    _isShowVerLine = isShowVerLine;
    self.xAxisView.isShowVerLine = isShowVerLine;
}

- (void)setIsShowHorLine:(BOOL)isShowHorLine{
    _isShowHorLine = isShowHorLine;
    self.xAxisView.isShowHorLine = isShowHorLine;
}

- (void)setUnitStr:(NSString *)unitStr{
    _unitStr = unitStr;
    self.xAxisView.unitStr = unitStr;
    self.yAxisView.unitStr = unitStr;
}

- (void)setIsShowDynamic:(BOOL)isShowDynamic{
    _isShowDynamic = isShowDynamic;
    self.xAxisView.isShowDynamic = isShowDynamic;
}

#pragma mark - initUI

- (void)creatLine{
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height- 15 -0.6, self.frame.size.width, 0.6)];
    bottomLine.backgroundColor = ZQChartLineGrayColor;
    [self addSubview:bottomLine];
    
//    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.6)];
//    topLine.backgroundColor = ZQChartLineGrayColor;
//    [self addSubview:topLine];
}

- (void)creatYAxisView {
    if (!self.yAxisView) {
        self.yAxisView = [[YAxisView alloc]initWithFrame:CGRectMake(self.frame.size.width - ZQLeftMargin ,0, ZQLeftMargin, self.frame.size.height)];
        [self addSubview:self.yAxisView];
    }
}

- (void)creatXAxisView {
    if (!self.xAxisView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - ZQLeftMargin, self.frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        self.xAxisView = [[XAxisView alloc]initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        [_scrollView addSubview:self.xAxisView];
    }
}

#pragma mark - function
- (void)reloadData:(NSArray*)xTitleArray
      yValueArrays:(NSArray<NSArray *>*)yValueArrays
              yMax:(CGFloat)yMax
              yMin:(CGFloat)yMin
         animation:(BOOL)animation{

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
    self.xAxisView.frame = CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + ZQLastSpace, self.frame.size.height);
    self.scrollView.contentSize = self.xAxisView.frame.size;
    [self.yAxisView reloadData:self.yMax yMin:self.yMin];
    [self.xAxisView reloadData:xTitleArray yValueArrays:yValueArrays yMax:self.yMax yMin:self.yMin];
    [self.scrollView setContentOffset:CGPointZero];
    if (animation) {
        ZQ(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                [weakSelf.scrollView scrollRectToVisible:CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + ZQLastSpace, self.frame.size.height) animated:NO];
            }];
        });
    }


}


- (void)initGes{
    //點擊手勢
    self.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event_tapGessAction:)];
    [self.xAxisView addGestureRecognizer:self.tapGes];
    self.tapGes.enabled = NO;
    //捏合手势
    self.pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.xAxisView addGestureRecognizer:self.pinchGes];
    self.pinchGes.enabled = NO;
    //长按手势
    self.longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
    [self.xAxisView addGestureRecognizer:self.longPressGes];
    self.longPressGes.enabled = NO;
}

#pragma mark - action
// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == 3) {
        
        if (self.xAxisView.frame.size.width-ZQLastSpace <= self.scrollView.frame.size.width) { //当缩小到小于屏幕宽时，松开回复屏幕宽度
            
            CGFloat scale = self.scrollView.frame.size.width / (self.xAxisView.frame.size.width-ZQLastSpace);
            
            self.pointGap *= scale;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.xAxisView.frame;
                frame.size.width = self.scrollView.frame.size.width+ZQLastSpace;
                self.xAxisView.frame = frame;
            }];
            
            self.xAxisView.pointGap = self.pointGap;
            
        }else if (self.xAxisView.frame.size.width-ZQLastSpace >= self.xTitleArray.count * _defaultSpace){
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.xAxisView.frame;
                frame.size.width = self.xTitleArray.count * _defaultSpace + ZQLastSpace;
                self.xAxisView.frame = frame;
                
            }];
            
            self.pointGap = _defaultSpace;
            
            self.xAxisView.pointGap = self.pointGap;
        }
    }else{
        
        CGFloat currentIndex,leftMagin;
        if( recognizer.numberOfTouches == 2 ) {
            //2.获取捏合中心点 -> 捏合中心点距离scrollviewcontent左侧的距离
            CGPoint p1 = [recognizer locationOfTouch:0 inView:self.xAxisView];
            CGPoint p2 = [recognizer locationOfTouch:1 inView:self.xAxisView];
            CGFloat centerX = (p1.x+p2.x)/2;
            leftMagin = centerX - self.scrollView.contentOffset.x;
            //            NSLog(@"centerX = %f",centerX);
            //            NSLog(@"self.scrollView.contentOffset.x = %f",self.scrollView.contentOffset.x);
            //            NSLog(@"leftMagin = %f",leftMagin);
            
            
            currentIndex = centerX / self.pointGap;
            //            NSLog(@"currentIndex = %f",currentIndex);
            
            
            
            self.pointGap *= recognizer.scale;
            self.pointGap = self.pointGap > _defaultSpace ? _defaultSpace : self.pointGap;
            if (self.pointGap == _defaultSpace) {
                NSLog(@"已经放至最大");
            }
            self.xAxisView.pointGap = self.pointGap;
            recognizer.scale = 1.0;
            
            self.xAxisView.frame = CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + ZQLastSpace, self.frame.size.height);
            
            self.scrollView.contentOffset = CGPointMake(currentIndex*self.pointGap-leftMagin, 0);
            //            NSLog(@"contentOffset = %f",self.scrollView.contentOffset.x);
            
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.xAxisView.frame.size.width, 0);
}


- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
        CGPoint location = [longPress locationInView:self.xAxisView];
        //相对于屏幕的位置
        CGPoint screenLoc = CGPointMake(location.x - self.scrollView.contentOffset.x, location.y);
        [self.xAxisView setScreenLoc:screenLoc];
        if (ABS(location.x - _moveDistance) > self.pointGap) { //不能长按移动一点点就重新绘图  要让定位的点改变了再重新绘图
            
//            [self.xAxisView setIsShowLabel:YES];
            [self.xAxisView setIsPressing:YES];
            self.xAxisView.currentLoc = location;
            _moveDistance = location.x;
        }
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        _moveDistance = 0;
        //恢复scrollView的滑动
//        [self.xAxisView setIsPressing:NO];
        [self.xAxisView setIsShowLabel:NO];
        
    }
}

- (void)event_tapGessAction:(UITapGestureRecognizer *)gess{
    CGPoint location = [gess locationInView:self.xAxisView];
    //相对于屏幕的位置
    CGPoint screenLoc = CGPointMake(location.x - self.scrollView.contentOffset.x, location.y);
    NSLog(@"screenLoc = %@",NSStringFromCGPoint(screenLoc));
    [self.xAxisView setScreenLoc:screenLoc];
    
//    [self.xAxisView setIsShowLabel:YES];
    [self.xAxisView setIsPressing:YES];
    self.xAxisView.currentLoc = location;
    _moveDistance = location.x;
}


@end
