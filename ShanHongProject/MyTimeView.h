//
//  MyTimeView.h
//  ScrollTableViewDemo
//
//  Created by teddy on 15/7/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTimeView : UIView

@property (nonatomic, strong) NSArray *listData;//数据源

@property (nonatomic, strong) NSString *headTitle; //顶部视图

@property (nonatomic, strong) UITableView *myTableView;

- (void)refrushTableView:(NSArray *)datas;

@end
