//
//  ProjectObject.h
//  ShanHongProject
//
//  Created by teddy on 15/6/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectObject : NSObject

//请求工情服务
+ (BOOL)fetch:(NSString *)type withProject:(NSString *)project;

+ (NSArray *)requestData;

+ (void)cancelRequest;

//请求筛选服务
//+ (BOOL)fetchFilterData;
@end
