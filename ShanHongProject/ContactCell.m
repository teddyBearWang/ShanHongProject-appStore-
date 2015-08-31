//
//  ContactCell.m
//  ShanHongProject
//
//  Created by teddy on 15/7/10.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

- (void)updateCell:(NSDictionary *)dic
{
    self.name.text = [[dic objectForKey:@"personNM"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"personNM"];
    self.phoneNumber.text = [[dic objectForKey:@"Mobile"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"Mobile"];
    self.position.text = [[dic objectForKey:@"Position"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"Position"];
    self.town.text = [[dic objectForKey:@"ADNM"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"ADNM"];
    self.userImg.image = [UIImage imageNamed:@"man"];
}

@end
