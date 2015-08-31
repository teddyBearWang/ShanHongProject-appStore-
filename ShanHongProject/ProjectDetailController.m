
//
//  ProjectDetailController.m
//  ShanHongProject
//  ************工情详细******************
//  Created by teddy on 15/6/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ProjectDetailController.h"
#import "ProjectObject.h"
#import "QualityCell.h"

@interface ProjectDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *listData;
    UITableView *_table;
}

@end

@implementation ProjectDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [ProjectObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_COLOR;
    _table = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width,self.view.frame.size.height - 44} style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    self.title = [self.Object_dic objectForKey:@"RSNM"];
    
    [self fetch];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetch
{
    [SVProgressHUD show];
    NSString *results = [NSString stringWithFormat:@"%@$%@",[self.Object_dic objectForKey:@"MyType"],[self.Object_dic objectForKey:@"RSCD"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ProjectObject fetch:self.requestType withProject:results]) {
            [self updateUI];
        }else{
          dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"加载失败"];
          });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        listData = (NSMutableArray *)[ProjectObject requestData];
        [_table reloadData];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    QualityCell *cell = (QualityCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QualityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = listData[indexPath.row];
    [cell setKeyLabelText:[dic objectForKey:@"type"]];
    [cell setValueLabelText:[[dic objectForKey:@"value"] isEqual:@""] ? @"--" : [dic objectForKey:@"value"]];
    return cell;
}

//设置row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QualityCell *cell  = (QualityCell *)[self tableView:_table cellForRowAtIndexPath:indexPath];
    if (cell.frame.size.height <= 44) {
        return 44;
    }else{
        return cell.frame.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
