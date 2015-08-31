//
//  RainChartController.h
//  ShanHongProject
//
//  Created by teddy on 15/6/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainChartController : UIViewController
@property (nonatomic, strong) NSString *title_name; //标题
@property (nonatomic, strong)NSString *requestType; //请求类型
@property (nonatomic, strong) NSString *stcd; //请求序列号
@property (nonatomic) int chartType;  //图表类型，1：表示折线图；2：表示柱状图

@end
