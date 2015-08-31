//
//  SendMessageObject.h
//  ShanHongProject
//  ************发送短信***************
//  Created by teddy on 15/8/24.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendMessageObject : NSObject

+ (BOOL)fetchWithType:(NSString *)type result:(NSString *)results;

+ (NSArray *)requestData;

+ (void)cancelRequest;
@end
