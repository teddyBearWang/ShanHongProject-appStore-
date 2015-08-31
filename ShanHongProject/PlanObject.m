//
//  PlanObject.m
//  ShanHongProject
//
//  Created by teddy on 15/7/14.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PlanObject.h"
#import <AFNetworking.h>
#import "UntilObject.h"

static AFHTTPRequestOperation *operation = nil;
static NSString *_url = nil;
@implementation PlanObject


+ (BOOL)fetchWithSicd:(NSString *)sicd
{
    BOOL ret = NO;
    //http://115.236.169.28/webserca/data.ashx?&t=GetFxPlanTree&results=name$0$$false&returntype=json  废弃
    //http://115.236.169.28/webserca/Data.ashx?t=GetNamePlan2&results=330127102218100
    _url = [UntilObject getWebURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
   // NSString *str = [NSString stringWithFormat:@"name$%@$%@$false",level,sicd];
    NSDictionary *parameters = @{@"t":@"GetNamePlan2",
                                 @"results":sicd,
                                 @"returntype":@"json"};
    operation = [manager POST:_url parameters:parameters success:nil failure:nil];
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

+ (void) cancelRequest
{
    if (operation != nil) {
        [operation cancel];
    }
}

@end
