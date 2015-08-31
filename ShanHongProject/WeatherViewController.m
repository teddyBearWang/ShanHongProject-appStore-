//
//  WeatherViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WeatherViewController.h"
#import "ProjectListController.h"


@interface WeatherViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_list;//数据源
    NSArray *_images;//图片数据源
}
@property (weak, nonatomic) IBOutlet UITableView *itemsTable;

@end

@implementation WeatherViewController

- (void)viewWillLayoutSubviews
{
    if ([self.itemsTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.itemsTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.itemsTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.itemsTable setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"防汛救灾";
    
    _itemsTable.dataSource = self;
    _itemsTable.delegate = self;
    
    _list = @[@"地质灾害点",@"历史山洪灾害",@"安置点",@"物资仓库"];
    _images = @[@"dzzh",@"shzh",@"azd",@"ck"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _list[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = @"";
    NSString *titleName = @"";
    NSArray *headers = [NSArray array];
    switch (indexPath.row) {
        case 0:
        {
            type = @"zhd";
            titleName = @"地质灾害点";
            headers = @[@"名称",@"类型",@"等级"];
        }
            break;
        case 1:
            type = @"lssh";
            titleName = @"历史山洪灾害";
            headers = @[@"灾害发生时间",@"经济损失(万元)",@"灾害发生地点"];
            break;
        case 2:
            type = @"azd";
            titleName = @"安置点信息";
            headers = @[@"场所名称",@"场所地址",@"场所面积"];
            break;
        case 3:
            type = @"wzck";
            titleName = @"物资仓库";
            headers = @[@"仓库名称",@"仓库级别",@"仓库地址"];
            break;
        default:
            break;
    }
    ProjectListController *listCtrl = [[ProjectListController alloc] init];
    listCtrl.projectType = type;
    listCtrl.title_name = titleName;
    listCtrl.requestType = @"GetFloodControl"; //请求工情
    listCtrl.labelArray = headers;
    listCtrl.type = 1;//请求类型
    [self.navigationController pushViewController:listCtrl animated:YES];
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
