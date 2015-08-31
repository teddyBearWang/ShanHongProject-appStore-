//
//  CustomAnnotation.h
//  ShanHongProject
//
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>


@interface CustomAnnotation : MAPointAnnotation

@property (nonatomic, strong) NSString *type; //测站类型

@property (nonatomic, strong) NSString *stationName;//测站名字

@property (nonatomic, strong) NSString *valueName; //数值

@end
