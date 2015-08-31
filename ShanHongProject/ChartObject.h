//
//  ChartObject.h
//  ZDWater
// *************折线图或者柱状图对象*******************
//  Created by teddy on 15/5/28.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartObject : NSObject


/*
 *type: 请求方式
 *results:凭借字段
 */
+ (BOOL)fetcChartDataWithType:(NSString *)type results:(NSString *)result;

/*
 *获取X轴上的数据数组
 */
+ (NSMutableArray *)requestXLables;

/*
 *获取Y轴上的数据数组
 */
+ (NSMutableArray *)requestYValues;

@end
