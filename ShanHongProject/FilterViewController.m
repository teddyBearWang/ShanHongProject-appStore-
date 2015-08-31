//
//  FilterViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FilterViewController.h"
#import "ProjectDetailController.h"
#import "ChartViewController.h"
#import "RainChartController.h"


@interface FilterViewController ()<UISearchBarDelegate>
{
    UISearchBar *searchBar; //搜索bar
}

@end

@implementation FilterViewController
@synthesize data = _data;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //强制屏幕横屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.title_name;
    searchBar = [[UISearchBar alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width,44}];
    searchBar.placeholder = @"根据站名、编号搜索";
    searchBar.delegate = self;
    
    //添加searchBar到headerView上面
    self.tableView.tableHeaderView = searchBar;
    
    //用searchBar初始化SearchDisplayController
    //把searchDispalyController和当前的controller关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    //searchResultsDelegate就是UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    //searchResultsDataSource就是UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return _data.count;
    }else{
        return filterData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == self.tableView) {
        cell.textLabel.text = [_data[indexPath.row] objectForKey:@"RSNM"];
    }else{
        cell.textLabel.text = [filterData[indexPath.row] objectForKey:@"RSNM"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        //筛选前的数据，数据源为_data;
        
        //筛选后的数据，数据源为 filterData;
        switch (self.filterType) {
            case 0:
            {
                //表示工情筛选
                ProjectDetailController *detail = [[ProjectDetailController alloc] init];
                detail.Object_dic = [_data objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:detail animated:YES];
            }
                break;
            case 1:
            {
                //进入雨量柱状图
                NSDictionary *dic = _data[indexPath.row];
                ChartViewController *chart = [[ChartViewController alloc] init];
                chart.title_name = [NSString stringWithFormat:@"%@ 最近7日雨情",dic[@"stnm"]];
                chart.stcd = dic[@"stcd"];
                chart.requestType = @"GetStDayLjYl";
                chart.chartType = 2; //表示柱状图
                [self.navigationController pushViewController:chart animated:YES];
            }
                
                break;
            case 2:
            {
                NSDictionary *dic = _data[indexPath.row];
                RainChartController *chart = [[RainChartController alloc] init];
                chart.title_name = dic[@"stnm"];
                chart.stcd = dic[@"stcd"];
                chart.requestType = @"GetStDaySW";
                chart.chartType = 1; //表示柱状图
                [self.navigationController pushViewController:chart animated:YES];
            }
                break;
            case 3:
            {
                NSDictionary *dic = filterData[indexPath.row];
                if ([[dic objectForKey:@"X"] isEqualToString:@""] && [[dic objectForKey:@"X"] isEqualToString:@""])
                {
                    [self ShowAlert];
                    return;
                }else{
                    if ([[dic objectForKey:@"X"] floatValue] != 0 || [[dic objectForKey:@"Y"] floatValue] != 0)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KTapStationNotification object:dic];
                    }else{
                        [self ShowAlert];
                    }
                }
                //返回
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }

        
    }else{
       //筛选后的数据，数据源为 filterData;
        switch (self.filterType) {
            case 0:
            {
                //表示工情筛选
                ProjectDetailController *detail = [[ProjectDetailController alloc] init];
                detail.Object_dic = [filterData objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:detail animated:YES];
            }
                break;
            case 1:
            {
                //进入雨量柱状图
                NSDictionary *dic = filterData[indexPath.row];
                ChartViewController *chart = [[ChartViewController alloc] init];
                chart.title_name = [NSString stringWithFormat:@"%@ 最近7日雨情",dic[@"stnm"]];
                chart.stcd = dic[@"stcd"];
                chart.requestType = @"GetStDayLjYl";
                chart.chartType = 2; //表示柱状图
                [self.navigationController pushViewController:chart animated:YES];
            }
                
                break;
            case 2:
            {
                NSDictionary *dic = filterData[indexPath.row];
                RainChartController *chart = [[RainChartController alloc] init];
                chart.title_name = dic[@"stnm"];
                chart.stcd = dic[@"stcd"];
                chart.requestType = @"GetStDaySW";
                chart.chartType = 1; //表示柱状图
                [self.navigationController pushViewController:chart animated:YES];
            }
                break;
            case 3:
            {
                NSDictionary *dic = filterData[indexPath.row];
                
                if ([[dic objectForKey:@"X"] isEqualToString:@""] && [[dic objectForKey:@"X"] isEqualToString:@""])
                {
                    [self ShowAlert];
                    return;
                }else{
                    if ([[dic objectForKey:@"X"] floatValue] != 0 || [[dic objectForKey:@"Y"] floatValue] != 0)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KTapStationNotification object:dic];
                    }else{
                        [self ShowAlert];
                    }
                }
                //返回
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)ShowAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你选择的站点当前无经纬度信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -UISearchBarDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [searchBar setShowsCancelButton:YES];
    for (UIView *view in searchBar.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

// called when text ends editing，当searchBar释放第一响应者的时候开始搜索
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    return;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //谓词搜索
    /**< 模糊查找*/
   // NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", keyName, searchText];
    NSPredicate *predicate;
    if ([self isAllNumber:searchDisplayController.searchBar.text]) {
        //输入的是编号
        predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"RSCD",searchText];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"MySearchName",searchDisplayController.searchBar.text];
    }
   
    filterData = [[NSArray alloc] initWithArray:[_data filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

//判断是否为一个数字字符串
- (BOOL)isAllNumber:(NSString *)text
{
    unichar c;
    for (int i=0; i<text.length; i++) {
        c = [text characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

@end
