//
//  ContactCell.h
//  ShanHongProject
//
//  Created by teddy on 15/7/10.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@property (nonatomic, strong) IBOutlet UILabel *name; //姓名

@property (nonatomic, strong) IBOutlet UILabel *phoneNumber; //电话

@property (nonatomic, strong) IBOutlet UILabel *position; //职位

@property (nonatomic, strong) IBOutlet UILabel *town;//乡镇

- (void)updateCell:(NSDictionary *)dic;

@end
