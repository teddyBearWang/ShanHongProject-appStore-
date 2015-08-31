//
//  CustomCalloutView.m
//  ShanHongProject
//
//  Created by teddy on 15/7/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CustomCalloutView.h"

@interface CustomCalloutView()

@property (nonatomic, strong) IBOutlet UILabel *stationLabel; //站点

@property (nonatomic, strong) IBOutlet UILabel *valueLabel; //数值

@end

@implementation CustomCalloutView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 0.8;
        self.layer.cornerRadius = 5.0f;
    }
    return self;
    
}

//重写set方法
- (void)setStationName:(NSString *)stationName
{
    self.stationLabel.text = stationName;
}

- (void)setValueName:(NSString *)valueName
{
    self.valueLabel.text = valueName;
}
@end
