//
//  RainCell.h
//  ZDWater2
//
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oneHour;//1小时
@property (weak, nonatomic) IBOutlet UILabel *threeHour;//3小时
@property (weak, nonatomic) IBOutlet UILabel *today;//今日
@property (weak, nonatomic) IBOutlet UILabel *sixHour; //6小时
@property (weak, nonatomic) IBOutlet UILabel *twelveyHour; //12小时
@property (weak, nonatomic) IBOutlet UILabel *twentyFourHour; //24小时
@property (weak, nonatomic) IBOutlet UILabel *fortyFiverHour; //24小时
@property (weak, nonatomic) IBOutlet UILabel *seventyTwoHour; //24小时


@end
