//
//  PeopleDetailController.m
//  ShanHongProject
//
//  Created by teddy on 15/8/21.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PeopleDetailController.h"
#import "SingleInstanceObject.h"
#import "SVProgressHUD.h"
#import "ContactObject.h"
#import "ContactCell.h"

@interface PeopleDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_listArray;//数据源
    
    SingleInstanceObject *_instance;//单例对象
}

@end

@implementation PeopleDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [ContactObject cancelRequest];
        //退回去
        [SVProgressHUD dismiss];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"人员详情";
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _instance = [SingleInstanceObject defaultInstance];
    if (_instance.warnPeopleList == nil) {
        _instance.warnPeopleList = [NSMutableArray array];
    }
    
    [self getWebData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
//判断当前选择选择的对象是否已经保存下来
- (BOOL)selectArrayIsContaintWithDictionary:(NSDictionary *)dic
{
//    for (NSDictionary *selectDic in _instance.warnPeopleList) {
//        //[[selectDic objectForKey:@"PersonCD"] isEqualToString:[dic objectForKey:@"PersonCD"]]
//        if ([[selectDic objectForKey:@"PersonCD"] isEqualToString:[dic objectForKey:@"PersonCD"]]) {
//            
//            return YES;
//            //continue;
//        }
//    }
//    return NO;
    if ([_instance.warnPeopleList indexOfObject:dic] == NSNotFound) {
        return NO;
    }else{
        return YES;
    }
}

- (void)getWebData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *result = [NSString stringWithFormat:@"%@",self.Sid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ContactObject fetchWithType:@"GetMyWarnPerson" result:result]) {
            //成功
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _listArray = [ContactObject requestData];
        if (_listArray.count != 0) {
            [_tableView reloadData];
        }
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (ContactCell *)[[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dic = _listArray[indexPath.row];
    if ([self selectArrayIsContaintWithDictionary:dic]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.imageView.image = [UIImage imageNamed:@"man"];
    cell.name.text = [dic objectForKey:@"PersonNM"];
    cell.phoneNumber.text = [dic objectForKey:@"Mobile"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = [_listArray objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        //选中
        [_instance.warnPeopleList addObject:dic];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        //取消选中
        cell.accessoryType = UITableViewCellAccessoryNone;
        //在已经选中的数组将该对象删除
        [_instance.warnPeopleList removeObject:dic];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
