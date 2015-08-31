//
//  SelectViewController.h
//  ShanHongProject
//  *************测站选择*****************
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol SelectStationDelegate <NSObject>
//
//- (void)selectStation:(NSArray *)array;
//
//@end

typedef void(^ReturnSelectBlock)(NSArray *selects);

@interface SelectViewController : UIViewController

@property (nonatomic, strong) ReturnSelectBlock returnSelectBlock;

- (void)returnSelects:(ReturnSelectBlock)block;

@end
