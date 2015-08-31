//
//  WaterViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WaterViewController.h"
#import "SVProgressHUD.h"
#import "WaterCell.h"
#import "RainObject.h"
#import "CustomRainHeaderView.h"
#import "RainChartController.h"
#import "MyTimeView.h"
#import "HeaderView.h"
#import "UIView+RootView.h"
#import "FilterViewController.h"
#import "FilterObject.h"

#define SelectBtn_height 40

@interface WaterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;//数据源
    UITableView *_myTableView;
    NSArray *_headers;// 列表头部视图的字段
    NSMutableArray *_stations;//站点tableVIew的数据源
    
    __weak IBOutlet UIButton *wuSong_btn; //吴淞高程
    __weak IBOutlet UIButton *eightFive_btn; //85高程
    NSUInteger _kCount;
}

@property (strong, nonatomic)  UIView *myTableViewHeaderView;

@property (nonatomic, strong) MyTimeView *myTimeView;

//不同的高程选择
- (IBAction)gaoChengSelectAction:(id)sender;

@end

@implementation WaterViewController

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

- (void)viewWillLayoutSubviews
{
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }

#endif
}

- (void)initDatas
{
    _headers = @[@"实时水位(m)",@"警戒/汛限(m)",@"超警/超限(m)",@"最新时间",@"当日最大(m)",@"最大时间",@"库容"];
    _kCount = _headers.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
    
    [self initBar];
    [self initDatas];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){0,0,_kCount * (kWidth + 5), kHeight}];
    tableHeaderView.backgroundColor = BG_COLOR;
    self.myTableViewHeaderView = tableHeaderView;
    
    for (int i=0; i<_kCount; i++) {
        HeaderView *header = [[HeaderView alloc] initWithFrame:CGRectMake(i*(kWidth + 5), 0, (kWidth + 5), kHeight)];
        header.num = _headers[i];
        [tableHeaderView addSubview:header];
    }
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.myTableViewHeaderView.frame.size.width, kScreen_height - SelectBtn_height-NavigationBarHeight) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.bounces = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth, 0, kScreen_Width - kWidth, kScreen_height - SelectBtn_height - NavigationBarHeight)];
    [scrollView addSubview:_myTableView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.myTableViewHeaderView.frame.size.width, 0);
    [self.view addSubview:scrollView];
    
    self.myTimeView = [[MyTimeView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kScreen_height - SelectBtn_height - NavigationBarHeight)];
    self.myTimeView.listData = _stations;
    self.myTimeView.headTitle = @"站点名称";
    [self.view addSubview:self.myTimeView];
    
    
    UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(filterAction:)];
    self.navigationItem.rightBarButtonItem = select;
    
    //数据加载结束之前，先禁止交互
    eightFive_btn.userInteractionEnabled = NO;
    wuSong_btn.userInteractionEnabled = NO;

    
    [self refresh:@"GetSqInfo" withREsults:@""];
    
    
}

- (void)initBar
{
    NSArray *items = @[@"全部",@"河道",@"水库"];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:items];
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    seg.selectedSegmentIndex = 0;
    seg.momentary = NO; //设置成NO，则保持被选中的状态
    seg.apportionsSegmentWidthsByContent = YES;
    [seg addTarget:self action:@selector(selectSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //用户点击返回,取消用户请求
        [RainObject cancelRequest];
    }
}

#pragma mark - Private Method
- (void)selectSegmentAction:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            [self refresh:@"GetSqInfo" withREsults:@""];
        }
            
            break;
        case 1:
        {
            [self refresh:@"GetSqInfo" withREsults:@"28"];
        }
            
            break;
        case 2:
        {
            [self refresh:@"GetSqInfo" withREsults:@"27"];
        }
            
            break;
        default:
            break;
    }
}

- (void)filterAction:(id)sender
{
    [SVProgressHUD show];
    __block NSArray *filterDatas = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([FilterObject fetchFilterDataWithType:@"GetSqInfoSearch"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithSuccess:nil];
                filterDatas = [FilterObject requestData];
                FilterViewController *filter = [[FilterViewController alloc] init];
                filter.data = filterDatas;//传递数据
                filter.filterType =  WaterStationFilter;
                filter.title_name = @"水情站点搜索";
                [self.navigationController pushViewController:filter animated:YES];
            });
        }else{
            filterDatas = [NSArray array];
        }
    });
}

- (void)refresh:(NSString *)requestType withREsults:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([RainObject fetch:requestType withReaults:type]) {
            //更新UI
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败~"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        listData = [RainObject requestData];
        _stations = [NSMutableArray arrayWithCapacity:listData.count];
        for (NSDictionary *dic in listData) {
            [_stations addObject:[dic objectForKey:@"stnm"]];
        }
        [_myTableView reloadData];
        [self.myTimeView refrushTableView:_stations];
        //85高程按钮默认被选中
        eightFive_btn.userInteractionEnabled = YES;
        wuSong_btn.userInteractionEnabled = YES;
        //默认就是选中85高程的，每次请求网络之后改变
        eightFive_btn.selected = YES;
        wuSong_btn.selected = NO;
    });
}
#pragma mark - UITableViewDataSOurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //有数据的时候
    WaterCell *cell = (WaterCell *)[tableView dequeueReusableCellWithIdentifier:@"RainCell"];
    if (cell == nil) {
        cell = ( WaterCell*)[[[NSBundle mainBundle] loadNibNamed:@"WaterCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dic = [listData objectAtIndex:indexPath.row];
    cell.lastestLevel.text = [[dic objectForKey:@"new"] isEqual:@""] ? @"--" : [dic objectForKey:@"new"];
    cell.lastestTime.text = [[dic objectForKey:@"newTime"] isEqual:@""] ? @"--" : [dic objectForKey:@"newTime"];
    cell.warnWater.text = [[dic objectForKey:@"STThreshold"] isEqual:@""] ? @"--" : [dic objectForKey:@"STThreshold"];
    cell.capacity.text = [[dic objectForKey:@"kr"] isEqual:@""] ? @"--" : [dic objectForKey:@"kr"];
    cell.maxLevel.text = [[dic objectForKey:@"max"] isEqual:@""] ? @"--" : [dic objectForKey:@"max"];
    cell.maxTime.text = [[dic objectForKey:@"maxTime"] isEqual:@""] ? @"--" : [dic objectForKey:@"maxTime"];
    if (![[dic objectForKey:@"jjsw"] isEqualToString:@""]) {
        if ([[dic objectForKey:@"jjsw"] floatValue] > 0) {
            cell.floodWarn.textColor = [UIColor redColor];
        }
        cell.floodWarn.text = [dic objectForKey:@"jjsw"];
    }else{
        cell.floodWarn.text = @"--";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.myTableViewHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = listData[indexPath.row];
    RainChartController *chart = [[RainChartController alloc] init];
    chart.title_name = dic[@"stnm"];
    chart.stcd = dic[@"stcd"];
    chart.requestType = @"GetStDaySW";
    chart.chartType = 1; //表示柱状图
    //[self.navigationController pushViewController:chart animated:YES];
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
    CGFloat offSetY = _myTableView.contentOffset.y;//_myTableView的Y向偏移量
    
    CGPoint timeViewOffSet = self.myTimeView.myTableView.contentOffset;
    timeViewOffSet.y = offSetY;
    self.myTimeView.myTableView.contentOffset = timeViewOffSet;
    if (offSetY == 0) {
        self.myTimeView.myTableView.contentOffset = timeViewOffSet;
    }
}

//不同的高程选择
- (IBAction)gaoChengSelectAction:(id)sender
{
    UIButton *select_btn = (UIButton *)sender;
    if(select_btn.selected == YES)
    {
        return;
    }
    
    float addNumber;
    if ([select_btn.currentTitle isEqualToString:@"85高程"]) {
        //选择了85高程
        eightFive_btn.selected = YES;
        wuSong_btn.selected = NO;
        addNumber = -1.84;
    }else{
        //选择了吴淞高程
        eightFive_btn.selected = NO;
        wuSong_btn.selected = YES;
        addNumber = 1.84;
    }
    NSMutableArray *deal_arr = [NSMutableArray arrayWithCapacity:listData.count];
    for (NSDictionary *dic in listData) {
        NSString *new = [dic objectForKey:@"new"];
        if ([new isEqualToString:@""]) {
            //不是数字，不处理
            [deal_arr addObject:dic];
        }else{
            //是数字
           float new_value = [new floatValue] + addNumber;
            [dic setValue:[NSString stringWithFormat:@"%.2lf",new_value] forKey:@"new"];
            [deal_arr addObject:dic];
        }
    }
    
    listData = (NSArray *)deal_arr;
    [_myTableView reloadData];
    
}

- (BOOL)isDigital:(NSString *)nunStr
{
    for (int i = 0; i<[nunStr length]; i++) {
        char c = [nunStr characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
@end
