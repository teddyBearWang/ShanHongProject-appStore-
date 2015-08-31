//
//  QualityCell.h
//  ZDWater
//
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QualityCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

//设置key的值并且实现自动换行
- (void)setKeyLabelText:(NSString *)key;

//设置Value的值并且实现自动换行
- (void)setValueLabelText:(NSString *)value;

@end
