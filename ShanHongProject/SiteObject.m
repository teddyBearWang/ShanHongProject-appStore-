//
//  SiteObject.m
//  ShanHongProject
//
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SiteObject.h"
#import "SingleInstanceObject.h"
#import <AFNetworking.h>

static AFHTTPRequestOperation *operation = nil;
@implementation SiteObject

+ (BOOL)fetchSite
{
     BOOL ret = NO;
    //http://115.236.2.245:38019/data.ashx?t=GetSite&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSDictionary *parameter = @{@"t":@"GetSite",
                                @"returntype":@"json"};
    operation = [manager POST:Site_URL parameters:parameter success:nil failure:nil];
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        ret = YES;
        datas = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    return ret;
}

static NSArray *datas = nil;
+ (NSArray *)requestDatas
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
