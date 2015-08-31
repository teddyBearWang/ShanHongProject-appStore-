//
//  WaterCell.h
//  ZDWater
//
//  Created by teddy on 15/5/18.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lastestTime; //最新时间

@property (nonatomic, strong) IBOutlet UILabel *lastestLevel; //最新水位
@property (nonatomic, strong) IBOutlet UILabel *warnWater; //预警水位
@property (nonatomic, strong) IBOutlet UILabel *capacity; //库容
@property (weak, nonatomic) IBOutlet UILabel *maxTime; //最大时间
@property (weak, nonatomic) IBOutlet UILabel *floodWarn; //汛戒
@property (weak, nonatomic) IBOutlet UILabel *maxLevel; //最大水位


@end
