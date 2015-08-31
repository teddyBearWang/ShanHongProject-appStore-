//
//  QiXiangViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QiXiangViewController.h"
#import "QxDetailController.h"
#import "WeatherDetailController.h"

@interface QiXiangViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;
    NSArray *images;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation QiXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    
    listData = @[@"天气预报",@"一小时降水预报",@"三小时降水预报",@"卫星云图",@"气象雷达"];
    images = @[@"wh",@"rainYb",@"rainYb",@"wxyt",@"qxld"];
}

- (void)viewWillLayoutSubviews
{
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }

#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = listData[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            WeatherDetailController *weather = [[WeatherDetailController alloc] initWithNibName:@"WeatherDetailController" bundle:nil];
            [self.navigationController pushViewController:weather animated:YES];
        }
            break;
        case 1:
        {
            //一小时强降水
            QxDetailController *qx = [[QxDetailController alloc] init];
            qx.type = @"rain1h$";
           [self.navigationController pushViewController:qx animated:YES];
        }
            break;
        case 2:
        {
            //三小时强降水
            QxDetailController *qx = [[QxDetailController alloc] init];
            qx.type = @"rain3h$";
            [self.navigationController pushViewController:qx animated:YES];
        }
            break;
        case 3:
        {
            //卫星云图
            QxDetailController *qx = [[QxDetailController alloc] init];
            qx.type = @"wxyt$";
            [self.navigationController pushViewController:qx animated:YES];
        }
            break;
        case 4:
        {
            //气象雷达
            QxDetailController *qx = [[QxDetailController alloc] init];
            qx.type = @"qxld$";
            [self.navigationController pushViewController:qx animated:YES];
        }
            break;
//        case 5:
//        {
//            //地址灾害
//            QxDetailController *qx = [[QxDetailController alloc] init];
//            qx.type = @"qxld$";
//            [self.navigationController pushViewController:qx animated:YES];
//        }
            break;
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
#endif
}



@end
