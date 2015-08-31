//
//  UULineChart.h
//  UUChartDemo
//*******折线图*******
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    15
#define UULabelHeight    10
#define UUYLabelwidth     30
#define UUTagLabelwidth     80

@interface UULineChart : UIView

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin; //Y数值的最小值
@property (nonatomic) CGFloat yValueMax;//Y值得最大值

@property (nonatomic, assign) CGRange markRange; //标记范围

@property (nonatomic, assign) CGRange chooseRange; //选择范围

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine; //显示横线条
@property (nonatomic, retain) NSMutableArray *ShowVericationLine; //显示竖线条
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray; //显示最大最小值

-(void)strokeChart;

@end
