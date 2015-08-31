//
//  UntilObject.m
//  ShanHongProject
//
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "UntilObject.h"

@implementation UntilObject

//获取网络地址
+ (NSString *)getWebURL
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [user objectForKey:STATION];
    NSString *url = [dic objectForKey:@"SproxyUrl"];
    return url;
}

//获取系统时间字符串
+ (NSString *)getSystemdate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [formatter stringFromDate:now];
    return date;
}

@end
