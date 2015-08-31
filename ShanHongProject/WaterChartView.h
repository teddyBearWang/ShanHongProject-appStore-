//
//  WaterChartView.h
//  ShanHongProject
//
//  Created by teddy on 15/7/1.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterChartView : UIView

@property (nonatomic, strong)NSArray *x_labels; //x坐标

@property (nonatomic, strong) NSArray *y_values;//y坐标


- (id)initWithCustomFrame:(CGRect)frame withX_labels:(NSArray *)x_labels withY_values:(NSArray *)y_values;

- (void)refreshChart;

@end
