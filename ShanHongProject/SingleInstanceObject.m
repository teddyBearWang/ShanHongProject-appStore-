//
//  SingleInstanceObject.m
//  ShanHongProject
//  **********单例模式*****************
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SingleInstanceObject.h"

static SingleInstanceObject *instance = nil;
@implementation SingleInstanceObject
+ (SingleInstanceObject *)defaultInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SingleInstanceObject alloc] init];
    });
    return instance;
}


@end
