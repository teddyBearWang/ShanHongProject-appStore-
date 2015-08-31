//
//  ContactViewController.h
//  ShanHongProject
//
//  Created by teddy on 15/7/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UITableViewController
{
    NSArray *_data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, strong)NSArray *data;

@end
