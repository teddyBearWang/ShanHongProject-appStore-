//
//  FloodObject.h
//  ShanHongProject
//
//  Created by teddy on 15/6/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloodObject : NSObject

+ (BOOL)fetch;

+ (NSArray *)requestData;

//获取汛情详情
+ (BOOL)fetchWithType:(NSString *)type;

+ (void)cancelRequest;

@end
