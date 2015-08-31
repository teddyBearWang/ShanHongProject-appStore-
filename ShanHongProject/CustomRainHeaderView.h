//
//  CustomRainHeaderView.h
//  ShanHongProject
//
//  Created by teddy on 15/6/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomRainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *forthLabel;


- (id)initWithFirstLabel:(NSString *)first withSecond:(NSString *)second withThree:(NSString *)three withForth:(NSString *)four;

@end
