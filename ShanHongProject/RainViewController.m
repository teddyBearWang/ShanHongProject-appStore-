//
//  RainViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RainViewController.h"
#import "RainCell.h"
#import "RainObject.h"
#import "UIView+RootView.h"
#import "SVProgressHUD.h"
#import "CustomHeaderView.h"
#import "ChartViewController.h"
#import "FilterViewController.h"
#import "CustomRainHeaderView.h"
#import "HeaderView.h"
#import "MyTimeView.h"
#import "FilterObject.h"

@interface RainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *listData;//侧滑tableVIew的数据源
    NSMutableArray *sourceDatas;//所有数据
    NSArray *_headers;// 列表头部视图的字段
    NSMutableArray *_stations;//站点tableVIew的数据源
    
    NSUInteger _kCount;
}

@property (nonatomic, strong) UIView *myHeaderView;

@property (nonatomic, strong) MyTimeView *myTimeView;

@end

@implementation RainViewController

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

- (void)initData
{
    _headers = @[@"1h雨量(mm)",@"3h雨量(mm)",@"今日雨量(mm)",@"6h雨量(mm)",@"12h雨量(mm)",@"24h雨量(mm)",@"48h雨量(mm)",@"72h雨量(mm)"];
    _kCount = _headers.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"雨情信息";
    self.view.backgroundColor = BG_COLOR;
    
    [self initData];
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:(CGRect){0,0,_kCount * kWidth, kHeight}];
    tableViewHeader.backgroundColor = BG_COLOR;
    self.myHeaderView = tableViewHeader;
    
    for (int i=0; i<_kCount; i++) {
        HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(i*kWidth, 0, kWidth, kHeight)];
        headerView.num = _headers[i];
        [tableViewHeader addSubview:headerView];
    }
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.myHeaderView.frame.size.width,kScreen_height} style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth, 0,kScreen_Width - kWidth , kScreen_height)];
    [scrollView addSubview:_tableView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.myHeaderView.frame.size.width, 0);
    [self.view addSubview:scrollView];
    
    self.myTimeView = [[MyTimeView alloc] initWithFrame:(CGRect){0,0,kWidth,kScreen_height}];
    self.myTimeView.listData = _stations;
    self.myTimeView.headTitle = @"站点名称";
    [self.view addSubview:self.myTimeView];
    
    UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(filterAction:)];
    
    self.navigationItem.rightBarButtonItem = select;
    
    [self refresh];
}

- (void)viewWillLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //取消网络请求
        [RainObject cancelRequest];
    }
}

#pragma mark - private
- (void)refresh
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RainObject fetch:@"GetYqInfo" withReaults:@""]) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [SVProgressHUD dismissWithSuccess:@"加载成功"];
               listData = [RainObject requestData];
               sourceDatas = [NSMutableArray arrayWithArray:listData];
               _stations = [NSMutableArray arrayWithCapacity:listData.count];
               for (NSDictionary *dic in listData) {
                   [_stations addObject:[dic objectForKey:@"stnm"]];
               }
               [self.myTimeView refrushTableView:_stations];
               [_tableView reloadData];
           });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)filterAction:(UIButton *)btn
{
    [SVProgressHUD show];
    __block NSArray *filterDatas = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([FilterObject fetchFilterDataWithType:@"GetYqInfoSearch"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithSuccess:nil];
                filterDatas = [FilterObject requestData];
                FilterViewController *filter = [[FilterViewController alloc] init];
                filter.data = filterDatas;//传递数据
                filter.filterType =  RainStationFilter;
                filter.title_name = @"雨情站点搜索";
                [self.navigationController pushViewController:filter animated:YES];
            });
        }else{
            filterDatas = [NSArray array];
        }
    });
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    RainCell *cell = (RainCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (RainCell *)[[[NSBundle mainBundle] loadNibNamed:@"Rain" owner:nil options:nil] lastObject];
    }
    NSDictionary *dic = listData[indexPath.row];
    cell.oneHour.text = [[dic objectForKey:@"rain1h"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"rain1h"];
    cell.threeHour.text = [[dic objectForKey:@"rain3h"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"rain3h"];
    cell.today.text = [[dic objectForKey:@"raintoday"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"raintoday"];
    cell.sixHour.text = [[dic objectForKey:@"rain6h"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"rain6h"];
    cell.twelveyHour.text = [[dic objectForKey:@"rain12h"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"rain12h"];
    cell.twentyFourHour.text = [[dic objectForKey:@"rain24h"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"rain24h"];
    cell.fortyFiverHour.text = [[dic objectForKey:@"rain48h"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"rain48h"];
    cell.seventyTwoHour.text = [[dic objectForKey:@"rain72h"] isEqualToString:@""] ? @"--" : [dic objectForKey:@"rain72h"];

    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return kHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return self.myHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = listData[indexPath.row];
    ChartViewController *chart = [[ChartViewController alloc] init];
    chart.title_name = dic[@"stnm"];
    chart.stcd = dic[@"stcd"];
    chart.requestType = @"GetStDayLjYl";
    chart.chartType = 2; //表示柱状图
    [self.navigationController pushViewController:chart animated:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetY = _tableView.contentOffset.y;//tableVIew的Y方向的偏移
    CGPoint timeOffSet = self.myTimeView.myTableView.contentOffset;
    
    timeOffSet.y = offSetY;
    
    self.myTimeView.myTableView.contentOffset = timeOffSet;
    if (offSetY == 0) {
        self.myTimeView.myTableView.contentOffset = CGPointZero;
    }
}

@end
