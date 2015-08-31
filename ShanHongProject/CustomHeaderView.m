//
//  CustomHeaderView.m
//  ZDWater
//
//  Created by teddy on 15/5/25.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CustomHeaderView.h"

@implementation CustomHeaderView


-(id)initWithFirstLabel:(NSString *)first withSecond:(NSString *)second withThree:(NSString *)three
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomHeaderView" owner:self options:nil] lastObject];
    if (self) {
        self.firstLabel.text = first;
        self.secondLabel.text = second;
        self.thirdLabel.text = three;
        self.backgroundColor = BG_COLOR;
    }
    
    return self;
}

@end
