//
//  WaterChartView.m
//  ShanHongProject
//
//  Created by teddy on 15/7/1.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterChartView.h"
#import "UUChart.h"

@interface WaterChartView()<UUChartDataSource>
{
    UUChart *chartView; //图表
}

@end

@implementation WaterChartView

- (id)initWithCustomFrame:(CGRect)frame withX_labels:(NSArray *)x_labels withY_values:(NSArray *)y_values
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.x_labels = x_labels;
        self.y_values = y_values;
        [self initChartView];
        
    }
    return self;
}

- (void)initChartView
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20)
                                              withSource:self
                                               withStyle:UUChartLineStyle];
    [chartView showInView:self];
    
}

- (void)refreshChart
{
    [self initChartView];
}

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    return self.x_labels;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    @try {
        return self.y_values;
    }
    @catch (NSException *exception) {
        
    }
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUBrown];
}

#pragma mark 折线图专享功能
//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    if (index == 4) {
        return YES;
    }else{
        return NO;
    }
}

//判断显示竖线条
- (BOOL)UUChart:(UUChart *)chart ShowVericationLineAtIndex:(NSInteger)index
{
    if (index == 0) {
        return YES;
    }else{
        return NO;
    }
}

@end
