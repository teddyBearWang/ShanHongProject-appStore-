//
//  CustomDateActionSheet.h
//  TouchProject
//
//  Created by teddy on 14-9-3.
//  Copyright (c) 2014年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TimeObject.h"

@interface CustomDateActionSheet : UIActionSheet

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) NSInteger Index; //判断点击取消或者确定
@property (nonatomic, strong) NSString *selectedTime;


- (IBAction)cancelAction:(id)sender;
- (IBAction)comfirmSelectedAction:(id)sender;
- (id)initWithTitle:(NSString *)title delegate:(id)delegate;
- (void)showInView:(UIView *)view;

@end
