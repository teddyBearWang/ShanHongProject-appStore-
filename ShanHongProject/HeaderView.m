//
//  HeaderView.m
//  ScrollTableViewDemo
//
//  Created by teddy on 15/7/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView()
@property (nonatomic,strong) UILabel *numRoom;
@end

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.numRoom=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, self.frame.size.height - 10)];
        self.numRoom.textAlignment=NSTextAlignmentCenter;
        self.numRoom.font = [UIFont systemFontOfSize:14];
        self.numRoom.textColor = Font_BGCOLOR;
        [self addSubview:self.numRoom];
        
    }
    return self;
}

-(void)setNum:(NSString *)num
{
    _num=num;
    self.numRoom.text=num;
}

@end
