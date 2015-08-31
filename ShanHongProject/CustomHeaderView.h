//
//  CustomHeaderView.h
//  ZDWater
//  ************自定义的headerView*****************
//  Created by teddy on 15/5/25.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;


- (id)initWithFirstLabel:(NSString *)first withSecond:(NSString *)second withThree:(NSString *)three;

@end
