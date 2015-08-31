//
//  QualityCell.m
//  ZDWater
//
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QualityCell.h"

@implementation QualityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.frame = CGRectMake(0, 11, self.frame.size.width/2-20, 22);
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    self.keyLabel.backgroundColor = [UIColor clearColor];
    self.keyLabel.font = [UIFont boldSystemFontOfSize:14];
    self.keyLabel.textColor = [UIColor colorWithRed:63/255.0 green:69/255.0 blue:81/255.0 alpha:1.0];
    [self.contentView addSubview:self.keyLabel];

    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.frame = CGRectMake(self.frame.size.width/2 + 10, 0, self.frame.size.width/2-20, 22);
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.font = [UIFont systemFontOfSize:14];
    self.valueLabel.textColor = [UIColor colorWithRed:63/255.0 green:69/255.0 blue:81/255.0 alpha:1.0];
    [self.contentView addSubview:self.valueLabel];
}


- (void)setKeyLabelText:(NSString *)key
{
    //获取当前cell的高度
    CGRect frame = [self frame];
    
    //给当前的label赋值
    self.keyLabel.text = key;
    
    self.keyLabel.numberOfLines = 0;//允许多行
    CGSize size = CGSizeMake(frame.size.width/2-20, 1000);
    CGSize labelsize = [self.keyLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    //算出自适应高度
    self.keyLabel.frame = (CGRect){self.keyLabel.frame.origin.x,self.keyLabel.frame.origin.y,self.keyLabel.frame.size.width,labelsize.height};
    frame.size.height = labelsize.height + 20;
    self.frame = frame;
    
}

/*
 *在调用的时候必须先调用setKeyLabelText:这个方法，否则会出现逻辑错误
 */
- (void)setValueLabelText:(NSString *)value
{
    //获取当前cell的高度
    CGRect frame = self.frame;
    
    self.valueLabel.text = value;
    self.valueLabel.numberOfLines = 0;//允许多行
    CGSize size = CGSizeMake(frame.size.width/2-20, 1000);
    CGSize labelSize = [self.valueLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    if (labelSize.height > frame.size.height) {
        //如果valueLabel的高度大于keyLabel的高度,则使用valueLabel的高度
        self.valueLabel.frame = (CGRect){self.valueLabel.frame.origin.x,self.valueLabel.frame.origin.y,self.valueLabel.frame.size.width,labelSize.height + 20};
    }else{
        //如果valueLabel的高度小于keyLabel的高度，则使用keyLabel的高度
        self.valueLabel.frame = (CGRect){self.valueLabel.frame.origin.x,self.valueLabel.frame.origin.y,self.valueLabel.frame.size.width,frame.size.height};
    }
    frame.size.height = self.valueLabel.frame.size.height;
    self.frame = frame;
}



@end
