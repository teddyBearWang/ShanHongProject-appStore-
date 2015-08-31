//
//  SelectViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SelectViewController.h"
#import "StationType.h"
#import "SingleInstanceObject.h"

@interface SelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table; //列表
    NSMutableArray *_list; //数据源
    SingleInstanceObject *_segton;//单例对象
}

@end

@implementation SelectViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.returnSelectBlock != nil) {
        //在界面即将消失的时候，将值传递出去
        self.returnSelectBlock(_segton.selectArray);
    }
    
}

- (void)viewWillLayoutSubviews
{
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
            [_table setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请选择要显示的类型";
    
    [self initData];
    //初始化单例
    _segton = [SingleInstanceObject defaultInstance];

    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
}

- (void)initData
{
    NSArray *names = @[@"水位站",@"雨量站",@"水库",@"水闸",@"堤防",@"水电站",@"山塘"];
    NSArray *images = @[@"l1",@"l2",@"l3",@"l4",@"l5",@"l6",@"l7"];
    NSArray *types = @[@"sw",@"yl",@"sk",@"sz",@"df",@"sdz",@"st"];
    _list = [NSMutableArray arrayWithCapacity:names.count];
    for (int i=0; i<names.count; i++) {
        StationType *station = [[StationType alloc] init];
        station.title = names[i];
        station.type = types[i];
        station.imageName = images[i];
        [_list addObject:station];
    }
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
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    StationType *station = _list[indexPath.row];
    for (int i=0; i<_segton.selectArray.count; i++) {
        StationType *selectStation = [_segton.selectArray objectAtIndex:i];
        if ([station.type isEqualToString:selectStation.type]) {
            //若是原本已经被选择了
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = station.title;
    cell.imageView.image = [UIImage imageNamed:station.imageName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    StationType *station = _list[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        for (StationType *station1 in _segton.selectArray) {
            //删除
            if ([station1.type isEqualToString:station.type]) {
                [_segton.selectArray removeObject:station1];
                break;
            }
        }
      //  [_segton.selectArray removeObject:station];
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //添加
        [_segton.selectArray addObject:station];
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

#pragma mark - block 回调传值
- (void)returnSelects:(ReturnSelectBlock)block
{
    self.returnSelectBlock = block;
}

@end
