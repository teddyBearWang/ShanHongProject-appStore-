//
//  WarnTownController.m
//  ShanHongProject
//  **********预警乡镇***********
//  Created by teddy on 15/8/21.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WarnTownController.h"
#import "ContactObject.h"
#import "SVProgressHUD.h"
#import "PeopleDetailController.h"
#import "ConfirmViewController.h"
#import "SecondTownController.h"

@interface WarnTownController ()<UITableViewDataSource,UITableViewDelegate>
{
    //UITableView *_tableView;//乡镇列表
    
    __weak IBOutlet UITableView *_tableView;
    NSArray *_list;
}

@end

@implementation WarnTownController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBar];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self getWebData];
}

- (void)initBar
{
    self.title = @"自定义分组";

    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(comfirmSelectedPeopleAction:)];
    self.navigationItem.rightBarButtonItem = confirm;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)comfirmSelectedPeopleAction:(id)sender
{
    ConfirmViewController *confirm = [[ConfirmViewController alloc] init];
    [self.navigationController pushViewController:confirm animated:YES];
}

//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ContactObject fetchWithType:@"GetMyWarnPerson" result:@""]) {
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
        if (_list.count != 0) {
            [_tableView reloadData];
        }
    });
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
