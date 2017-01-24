//
//  ViewController.m
//  WSLineChart
//
//  Created by iMac on 16/11/14.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#import "WSLineChartView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    [self test1];
    
}

- (void)test1{
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    NSMutableArray *y1Array = [NSMutableArray array];
    NSMutableArray *y2Array = [NSMutableArray array];
    NSMutableArray *y3Array = [NSMutableArray array];
    //    NSMutableArray *y3Array = [NSMutableArray array];
    for (NSInteger i = 0; i < 24; i++) {
        
        [xArray addObject:@"16-09"];
        [y1Array addObject:[NSString stringWithFormat:@"%.2lf",130.0+arc4random_uniform(70)]];
        [y2Array addObject:[NSString stringWithFormat:@"%.2lf",135.0+arc4random_uniform(60)]];
        [y3Array addObject:[NSString stringWithFormat:@"%.2lf",145.0+arc4random_uniform(50)]];
        
    }
    [yArray addObject:y1Array];
    [yArray addObject:y2Array];
    [yArray addObject:y3Array];
    
    WSLineChartView *wsLine = [[WSLineChartView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width , 200)];
    [wsLine reloadData:xArray yValueArrays:yArray yMax:280 yMin:100 animation:YES];
    wsLine.titleArr = @[@"本建案",@"北投区",@"台北市"];
    wsLine.isOpenPressGes = YES;
//    wsLine.isShowHorLine = YES;
    wsLine.isShowVerLine = YES;
    [self.view addSubview:wsLine];
}

- (void)test2{
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        
        [xArray addObject:@"16-09"];
        [yArray addObject:[NSString stringWithFormat:@"%.2lf",30.0+arc4random_uniform(70)]];
        
    }

    WSLineChartView *wsLine = [[WSLineChartView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300) xTitleArray:xArray yValueArrays:@[yArray] yMax:100 yMin:30];
    wsLine.isOpenPressGes = YES;
    wsLine.isShowHorLine = YES;
    wsLine.isShowLabel = YES;
    [self.view addSubview:wsLine];
}


@end
