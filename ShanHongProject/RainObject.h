//
//  RainObject.h
//  ShanHongProject
//  *********雨情数据***********
//  Created by teddy on 15/6/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface RainObject : NSObject

+ (BOOL)fetch:(NSString *)requestType withReaults:(NSString *)type;

+ (NSArray *)requestData;

+ (void)cancelRequest;

@end
