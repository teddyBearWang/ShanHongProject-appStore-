//
//  CustomRainHeaderView.m
//  ShanHongProject
//
//  Created by teddy on 15/6/30.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CustomRainHeaderView.h"

@implementation CustomRainHeaderView

- (id)initWithFirstLabel:(NSString *)first withSecond:(NSString *)second withThree:(NSString *)three withForth:(NSString *)four
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"RainHeaderView" owner:self options:nil] lastObject];
    if (self) {
        self.firstLabel.text = first;
        self.secondLabel.text = second;
        self.thirdLabel.text = three;
        self.forthLabel.text = four;
        self.backgroundColor = BG_COLOR;
    }
    
    return self;
}

@end
