//
//  ContactObject.h
//  ShanHongProject
//  **********通讯录*************
//  Created by teddy on 15/7/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactObject : NSObject

+ (BOOL)fetchWithType:(NSString *)type result:(NSString *)results;

+ (NSArray *)requestData;

+ (void)cancelRequest;
@end
