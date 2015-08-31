//
//  LoginToken.h
//  ShanHongProject
//
//  Created by teddy on 15/7/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginToken : NSObject

+ (BOOL)fetchWithUserName:(NSString *)name Psw:(NSString *)psw Version:(NSString *)version CityName:(NSString *)city;

+ (NSArray *)requestDatas;

@end
