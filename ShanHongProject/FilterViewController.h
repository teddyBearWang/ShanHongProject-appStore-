//
//  FilterViewController.h
//  ShanHongProject
//
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KTapStationNotification @"tapStationNotificaton"

@interface FilterViewController : UITableViewController
{
    NSArray *_data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, strong)NSArray *data;

@property (nonatomic, strong) NSString *title_name;//标题

@property (nonatomic, assign) FILTERTYPE filterType;


@end
