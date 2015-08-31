//
//  UIView+RootView.m
//  
//
//  Created by teddy on 15/5/18.
//
//

#import "UIView+RootView.h"

@implementation UIView (RootView)

- (void)setShadow {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.clipsToBounds = NO;
}

- (void)setCorners:(NSInteger)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}


@end
