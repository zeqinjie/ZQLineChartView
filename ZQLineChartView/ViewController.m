//
//  ViewController.m
//  ZQLineChartView
//
//  Created by zhengzeqin on 2017/1/24.
//  Copyright © 2017年 addcn. All rights reserved.
//

#import "ViewController.h"
#import "ZQLineChartView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    
    ZQLineChartView *ZQLine = [[ZQLineChartView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width , 200)];
    [ZQLine reloadData:xArray yValueArrays:yArray yMax:280 yMin:100 animation:YES];
    ZQLine.titleArr = @[@"本建案",@"北投区",@"台北市"];
    ZQLine.isOpenPressGes = YES;
    //    ZQLine.isShowHorLine = YES;
    ZQLine.isShowVerLine = YES;
    [self.view addSubview:ZQLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
