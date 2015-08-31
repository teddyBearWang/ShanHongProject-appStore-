//
//  CustomAnnotationView.m
//  ShanHongProject
//
//  Created by teddy on 15/7/20.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "CustomAnnotationView.h"

@interface CustomAnnotationView()

@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;

@end

@implementation CustomAnnotationView

//重写setSelect方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        if (self.calloutView == nil) {
            self.calloutView = (CustomCalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:nil options:nil] lastObject];
        }
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.f + self.calloutOffset.x, CGRectGetHeight(self.calloutView.bounds)/2.f + self.calloutOffset.y);
        self.calloutView.stationName = self.station;
        self.calloutView.valueName = self.value;
        [self addSubview:self.calloutView];
    }
    
    [super setSelected:selected animated:YES];
}

//- (void)setStation:(NSString *)station
//{
//    self.station = station;
//}
//
//- (void)setValue:(NSString *)value
//{
//    self.value = value;
//}

@end
