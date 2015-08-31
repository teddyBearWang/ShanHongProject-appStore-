//
//  WeatherObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WeatherObject.h"
#import <AFNetworking.h>
#import "UntilObject.h"

//http://115.236.169.28/webserca/data.ashx?t=GetSWeather&results=%E6%B7%B3%E5%AE%89&returntype=json
static   AFHTTPRequestOperation *operation = nil;
static NSString *_url = nil;
@implementation WeatherObject

+ (BOOL)fetch:(NSString *)stution
{
    BOOL ret;
    _url = [UntilObject getWebURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":@"GetSWeather",@"results":stution,@"returntype":@"json"};
    operation = [manager POST:_url parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != 0) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
}

static NSArray *datas = nil;
+ (NSArray *)requestData
{
    return datas;
}

+ (void)cancelRequest
{
    if (operation != nil) {
        [operation cancel];
    }
}

@end
