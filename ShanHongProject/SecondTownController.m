//
//  SecondTownController.m
//  ShanHongProject
//
//  Created by teddy on 15/8/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SecondTownController.h"
#import "ContactObject.h"
#import "SVProgressHUD.h"
#import "PeopleDetailController.h"

@interface SecondTownController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_list;
}

@end

@implementation SecondTownController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    [self getWebData];
}

#pragma mark - 
//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *result = [NSString stringWithFormat:@"%@",self.sid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ContactObject fetchWithType:@"GetMyWarnPerson" result:result]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //请求失败
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _list = [ContactObject requestData];
        NSLog(@"%@",_list);
        if (_list.count != 0) {
            [_tableView reloadData];
        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableVIewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_list[indexPath.row] objectForKey:@"PersonNM"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    PeopleDetailController *detail = [[PeopleDetailController alloc] init];
//    detail.Sid = [_list[indexPath.row] objectForKey:@"PersonCD"];
//    [self.navigationController pushViewController:detail animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sid = [_list[indexPath.row] objectForKey:@"PersonCD"];
    if (![sid hasPrefix:@"s"]) {
        //下一级
        SecondTownController *second = [[SecondTownController alloc] init];
        second.title = [_list[indexPath.row] objectForKey:@"PersonNM"];
        second.sid = sid;
        [self.navigationController pushViewController:second animated:YES];
    }else{
        
        PeopleDetailController *detail = [[PeopleDetailController alloc] init];
        detail.Sid = sid;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
