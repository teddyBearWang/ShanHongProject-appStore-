//
//  CustomAnnotationView.h
//  ShanHongProject
//  *******自定义标注视图*******
//  Created by teddy on 15/7/20.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong, readonly) CustomCalloutView *calloutView;

@property (nonatomic, copy) NSString *station; //测站

@property (nonatomic, copy) NSString *value; //数值

@end
