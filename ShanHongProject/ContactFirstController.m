//
//  ContactFirstController.m
//  ShanHongProject
//  *********通讯录第一级*****************
//  Created by teddy on 15/7/29.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ContactFirstController.h"
#import "ContactViewController.h"
#import "ContactSecondController.h"
#import "ContactObject.h"
#import "SVProgressHUD.h"

@interface ContactFirstController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listArray;//数据源
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ContactFirstController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [SVProgressHUD dismiss];
        [ContactObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"通讯录";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem = search;
    
    [self getWebData];
    
}

//获取网络数据
- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ContactObject fetchWithType:@"GetAdcdAdress2" result:@""]) {
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
        listArray = [ContactObject requestData];
        if (listArray.count != 0) {
            [self.myTableView reloadData];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Methods
- (void)searchAction:(UIButton *)btn
{
    ContactViewController *contact = [[ContactViewController alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    [self.navigationController pushViewController:contact animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"contact";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [listArray[indexPath.row] objectForKey:@"personNM"];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sid = [listArray[indexPath.row] objectForKey:@"PersonCD"];
    ContactSecondController *second = [[ContactSecondController alloc] init];
    second.Sid = sid;
    second.title_name = [listArray[indexPath.row] objectForKey:@"personNM"];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    [self.navigationController pushViewController:second animated:YES];
    
}
@end
