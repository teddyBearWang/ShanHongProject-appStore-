//
//  QiXiangObject.h
//  ShanHongProject
//  ********气象国土***********
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiXiangObject : NSObject

+ (BOOL)fetchWithType:(NSString *)type;

//返回数组数据
+ (NSArray *)requestDatas;

+ (void)cancelRequest;

@end
