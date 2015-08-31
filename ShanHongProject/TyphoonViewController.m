//
//  TyphoonViewController.m
//  ShanHongProject
//  ***********台风***********
//  Created by teddy on 15/7/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "TyphoonViewController.h"
#import "SVProgressHUD.h"

@interface TyphoonViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *typhoonView;

@end

@implementation TyphoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadWebView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismissWithSuccess:nil];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadWebView
{
    //http://typhoon.zjwater.gov.cn/default.aspx
    NSString *str = @"http://typhoon.zjwater.gov.cn/wap.htm";
    NSURL *url = [NSURL URLWithString:str];
    [self.typhoonView loadRequest:[NSURLRequest requestWithURL:url]];
}
@end
