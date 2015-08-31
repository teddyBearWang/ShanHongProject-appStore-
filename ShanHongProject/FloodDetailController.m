//
//  FloodDetailController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FloodDetailController.h"
#import "FloodCell.h"

@interface FloodDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSArray *listData;
}

@end

@implementation FloodDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详情";
    
    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

//每个section的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listDatas objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    FloodCell *cell = (FloodCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (FloodCell *)[[[NSBundle mainBundle] loadNibNamed:@"FloodCell" owner:nil options:nil] lastObject];
    }
    
    NSDictionary *dic = [[self.listDatas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.stationLabel.text = [dic objectForKey:@"key"];
    cell.valueLabel.text = [dic objectForKey:@"value"];
    cell.warnLabel.text = [dic objectForKey:@"value2"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
