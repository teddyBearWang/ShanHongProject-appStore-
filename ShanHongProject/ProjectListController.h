//
//  ProjectListController.h
//  ShanHongProject
//
//  Created by teddy on 15/6/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListController : UIViewController

@property (nonatomic, copy) NSString *projectType;//请求results
@property (nonatomic, copy) NSString *title_name;

@property (nonatomic, copy) NSString *requestType;//请求类型

@property (nonatomic, strong) NSArray *labelArray;//tableViewHeaderView上的标签数组

//type 表示显示的类型。0表示工情详细；2表示地质灾害点详情
@property (nonatomic, assign) int type;


@end
