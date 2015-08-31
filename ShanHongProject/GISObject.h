//
//  GISObject.h
//  ShanHongProject
//
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GISObject : NSObject

+ (BOOL)fetch;

+ (NSArray *)requestData;

+ (void)cancelRequest;

@end
