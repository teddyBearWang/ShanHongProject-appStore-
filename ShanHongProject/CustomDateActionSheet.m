//
//  CustomDateActionSheet.m
//  TouchProject
//
//  Created by teddy on 14-9-3.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import "CustomDateActionSheet.h"

#define KDuration 0.3

@implementation CustomDateActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomDateActionSheet" owner:self options:nil] objectAtIndex:0];
    if (self) {
       // self.selectedTime = [[TimeObject alloc] init];
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor whiteColor];
        
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.tag = 200;
        self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*10];
        self.datePicker.maximumDate = [NSDate date];
       // self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = KDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
}

- (IBAction)cancelAction:(id)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = KDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:KDuration];
    if(self.delegate) {
        self.Index = 0;
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)comfirmSelectedAction:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:200];
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   // self.selectedTime.time = [dateFormatter stringFromDate:date];
    self.selectedTime = [dateFormatter stringFromDate:date]; //选择的时间
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = KDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:KDuration];
    if(self.delegate) {
        self.Index = 1;
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }

}
@end
