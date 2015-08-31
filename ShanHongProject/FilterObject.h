//
//  FilterObject.h
//  ShanHongProject
//
//  Created by teddy on 15/7/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterObject : NSObject

+ (void)cancelRequest;

+ (NSArray *)requestData;

//请求筛选服务
+ (BOOL)fetchFilterDataWithType:(NSString *)type;

@end
