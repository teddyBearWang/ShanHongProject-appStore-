//
//  WeatherObject.h
//  ShanHongProject
//  ********天气***********
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject
+ (BOOL)fetch:(NSString *)stution;

+ (NSArray *)requestData;

+ (void)cancelRequest;

@end
