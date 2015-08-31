//
//  ProjectObject.m
//  ShanHongProject
//  *******工情对象*********
//  Created by teddy on 15/6/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ProjectObject.h"
#import <AFNetworking.h>
#import "UntilObject.h"

static    AFHTTPRequestOperation *operation = nil;
static NSString *_url = nil;
@implementation ProjectObject

+ (BOOL)fetch:(NSString *)type withProject:(NSString *)project
{
    BOOL ret;
    _url = [UntilObject getWebURL];
    //http://115.236.169.28/webserca/Data.ashx?t=GetProjects&results=sk&returntype=json
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"t":type,@"results":project,@"returntype":@"json"};
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
