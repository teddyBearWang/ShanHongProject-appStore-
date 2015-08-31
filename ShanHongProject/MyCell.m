//
//  MyCell.m
//  ScrollTableViewDemo
//
//  Created by teddy on 15/7/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "MyCell.h"
#import "HeaderView.h"

@implementation MyCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        for(int i=0;i<8;i++){
            //添加headerVIew到contentView
            HeaderView *headView=[[HeaderView alloc]initWithFrame:CGRectMake(i*kWidth, 0, kWidth-kWidthMargin, kHeight+kHeightMargin)];
            headView.backgroundColor=[UIColor whiteColor];
            [self.contentView addSubview:headView];
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//覆写赋值方法
- (void)setValues:(NSMutableArray *)values
{
    _values = values;
    for (int i=0; i<self.contentView.subviews.count; i++) {
        HeaderView *headView = self.contentView.subviews[i];
        headView.num = values[0];
    }
}

@end
