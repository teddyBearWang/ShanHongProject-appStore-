//
//  SendMessageObject.m
//  ShanHongProject
//
//  Created by teddy on 15/8/24.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SendMessageObject.h"
#import <AFNetworking.h>
#import "UntilObject.h"

static AFHTTPRequestOperation *_operation = nil;
@implementation SendMessageObject

+ (BOOL)fetchWithType:(NSString *)type result:(NSString *)results
{
    BOOL ret;
    NSString *url = [UntilObject getWebURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //t=GetAdcdAdress2
    NSDictionary *parmater = @{@"t":type,
                               @"results":results,
                               @"returntype":@"json"};
    _operation = [manager POST:url parameters:parmater success:nil failure:nil];
    [_operation waitUntilFinished];
    if (_operation.responseData != nil) {
        ret = YES;
        data = [NSJSONSerialization JSONObjectWithData:_operation.responseData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return ret;
}

static NSArray *data = nil;
+ (NSArray *)requestData
{
    return data;
}

+ (void)cancelRequest
{
    if (_operation != nil) {
        [_operation cancel];
    }
}

@end
