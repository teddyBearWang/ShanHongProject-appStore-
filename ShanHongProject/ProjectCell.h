//
//  ProjectCell.h
//  ShanHongProject
//
//  Created by teddy on 15/7/7.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //名称
@property (weak, nonatomic) IBOutlet UILabel *areaLabel; //所属流域
@property (weak, nonatomic) IBOutlet UILabel *townLabel; //所属乡镇

@end
