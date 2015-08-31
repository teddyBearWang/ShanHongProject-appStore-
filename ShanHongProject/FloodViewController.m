//
//  FloodViewController.m
//  ShanHongProject
//  #######当前汛情###
//  Created by teddy on 15/6/17.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "FloodViewController.h"
#import "FloodDetailController.h"
#import "FloodObject.h"
#import "SVProgressHUD.h"

@interface FloodViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listData;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation FloodViewController


-  (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [FloodObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    self.myTableView.allowsSelection = NO;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:(CGRect){20,0,self.view.frame.size.width,44}];
    textLabel.text = @"  汛情概要";
    self.myTableView.tableHeaderView = textLabel;
    
    [self getWebData];
    
}

- (void)viewDidLayoutSubviews
{
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset: UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWebData
{
    [SVProgressHUD show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([FloodObject fetch]) {
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
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        listData = [FloodObject requestData];
        self.myTableView.allowsSelection = YES;
        [self.myTableView reloadData];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = [listData lastObject];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
   
    switch (indexPath.row) {
        case 0:
            if ([[dic objectForKey:@"RainCount"] floatValue] > 0.0) {
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.text = [NSString stringWithFormat:@"雨量站超预警 %@个",[dic objectForKey:@"RainCount"]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"雨量站超预警 0个"];
            }
            cell.imageView.image = [UIImage imageNamed:@"yl"];
            break;
        case 1:
            if ([[dic objectForKey:@"WaterCount"] floatValue] > 0) {
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.text = [NSString stringWithFormat:@"水位超预警 %@个",[dic objectForKey:@"WaterCount"]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"水位超预警 0个"];
            }
            cell.imageView.image = [UIImage imageNamed:@"sw"];
            break;
        case 2:
            if ([[dic objectForKey:@"Maxr24hValue"] floatValue] > 0.0) {
                cell.textLabel.text = [NSString stringWithFormat:@"单站当日最大降雨量 %@mm",[dic objectForKey:@"Maxr24hValue"]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"单站当日最大降雨量 0 mm"];

            }
            cell.imageView.image = [UIImage imageNamed:@"yl"];
            break;
        case 3:
            if ([[dic objectForKey:@"Maxr1hValue"] floatValue] > 0.0) {
                cell.textLabel.text = [NSString stringWithFormat:@"单站当日1小时最大降雨量 %@mm",[dic objectForKey:@"Maxr1hValue"]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"单站当日1小时最大降雨量 0 mm"];
            }
            cell.imageView.image = [UIImage imageNamed:@"yl"];
            break;
        case 4:
            if ([[dic objectForKey:@"TfCount"] floatValue] > 0.0) {
                cell.textLabel.text = [NSString stringWithFormat:@"当前台风 %@个",[dic objectForKey:@"TfCount"]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"当前台风 0个"];
            }
            cell.imageView.image = [UIImage imageNamed:@"tf"];

            break;
        default:
            break;
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = @"";
    switch (indexPath.row) {
        case 0:
            type = @"yl";
            break;
        case 1:
            type = @"sw";
            break;
        case 2:
            type = @"sigleylmax";
            break;
        case 3:
            type = @"sigleyl1hmax";
            break;
        case 4:
            type = @"tf";
            break;
            
        default:
            break;
    }

    [self getFloodDetailWith:type];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 获取汛情详情

- (void)getFloodDetailWith:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加载
        if ([FloodObject fetchWithType:type]) {
            //updateUI
            [self pushViewAction];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

//push to next controllers
- (void)pushViewAction
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *data = [FloodObject requestData];
        FloodDetailController *detail = [[FloodDetailController alloc] init];
        detail.sections = [self dealWithSeactions:data];
        detail.listDatas = [self dealWithRows:data];
        [self.navigationController pushViewController:detail animated:YES];
    });
}

//得到seactions数组
- (NSMutableArray *)dealWithSeactions:(NSArray *)array
{
    NSMutableArray *seactions = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        [seactions addObject:[dic objectForKey:@"typename"]];
    }
    return seactions;
}


- (NSMutableArray *)dealWithRows:(NSArray *)array
{
    NSMutableArray *rows = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSArray *values = [dic objectForKey:@"values"];
        NSMutableArray *rowForSeaction = [NSMutableArray arrayWithCapacity:values.count];
        for (NSDictionary *dic in values) {
            [rowForSeaction addObject:dic];
        }
        [rows addObject:rowForSeaction];
    }
    return rows;
}

@end
