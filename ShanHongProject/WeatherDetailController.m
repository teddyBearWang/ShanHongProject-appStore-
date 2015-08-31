//
//  WeatherDetailController.m
//  ShanHongProject
//
//  Created by teddy on 15/8/10.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WeatherDetailController.h"
#import "SVProgressHUD.h"
#import "WeatherObject.h"

@interface WeatherDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *currentTemputer;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property (weak, nonatomic) IBOutlet UILabel *currentWindy;
@property (weak, nonatomic) IBOutlet UILabel *currentStation;

@property (weak, nonatomic) IBOutlet UILabel *torromDate;
@property (weak, nonatomic) IBOutlet UIImageView *torromImage;
@property (weak, nonatomic) IBOutlet UILabel *torromSataion;
@property (weak, nonatomic) IBOutlet UILabel *torromWindy;

@property (weak, nonatomic) IBOutlet UILabel *secondDate;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UILabel *secondStation;
@property (weak, nonatomic) IBOutlet UILabel *secondWindy;

@end

@implementation WeatherDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [WeatherObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [user objectForKey:STATION];
    
    self.title = [NSString stringWithFormat:@"天气预报(%@)",[dic objectForKey:@"ScityName"]];
    [self getWeatherData:[dic objectForKey:@"ScityName"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWeatherData:(NSString *)area
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([WeatherObject fetch:area]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

//更新UI
- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [WeatherObject requestData];
        NSDictionary *dic = [arr objectAtIndex:0];
        
        self.currentTemputer.text = [dic objectForKey:@"tempreal"];
        self.currentTime.text = [dic objectForKey:@"time"];
        self.currentImage.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        self.currentStation.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"weather"],[dic objectForKey:@"temp"]];
        self.currentWindy.text = [dic objectForKey:@"wind"];
        
        self.torromDate.text = [dic objectForKey:@"date1"];
        self.torromImage.image = [UIImage imageNamed:[dic objectForKey:@"image1"]];
        self.torromSataion.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"weather1"],[dic objectForKey:@"temp1"]];
        self.torromWindy.text = [dic objectForKey:@"wind1"];
        
        self.secondDate.text = [dic objectForKey:@"date2"];
        self.secondImage.image = [UIImage imageNamed:[dic objectForKey:@"image2"]];
        self.secondStation.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"weather2"],[dic objectForKey:@"temp2"]];
        self.secondWindy.text = [dic objectForKey:@"wind2"];
    });
}


@end
