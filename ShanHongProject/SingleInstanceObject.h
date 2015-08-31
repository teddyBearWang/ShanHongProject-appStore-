//
//  SingleInstanceObject.h
//  ShanHongProject
//
//  Created by teddy on 15/6/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleInstanceObject : NSObject

@property (nonatomic, assign) NSString *serverVersions;//服务器版本
@property (nonatomic, strong) NSString *Scityid;//站点
@property (nonatomic, strong) NSString *ScityName;//名称
@property (nonatomic, strong) NSString *SproxyUrl;//服务地址
@property (nonatomic, strong) NSString *ScenterLng;//地图默认定位精度
@property (nonatomic, strong) NSString *ScenterLat;//地图默认定位纬度
@property (nonatomic, strong) NSString *ScenterZoom;//地图默认方法级别

@property (nonatomic, strong) NSMutableArray *warnPeopleList;//选中的要发送预警的人员

@property (nonatomic, strong) NSMutableArray *selectArray;//GIS中站点的显示的站点类别
+ (SingleInstanceObject *)defaultInstance;

@end
