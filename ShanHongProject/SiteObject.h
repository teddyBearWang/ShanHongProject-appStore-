//
//  SiteObject.h
//  ShanHongProject
// **************地区选择********************
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteObject : NSObject

+ (BOOL)fetchSite;

+ (NSArray *)requestDatas;

+ (void)cancelRequest;

@end
