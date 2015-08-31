//
//  SettingViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SettingViewController.h"
#import "SingleInstanceObject.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_listData;
    SingleInstanceObject *_segton;//单例
}
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)changeAccountAction:(id)sender;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _listData = @[@"消息提醒",@"清除缓存",@"当前版本",@"关于"];
    //_listData = @[@"消息提醒",@"清除缓存",@"关于"];
    _segton = [SingleInstanceObject defaultInstance];
    self.view.backgroundColor = BG_COLOR;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.setBtn.layer.cornerRadius = 5.0;
    self.setBtn.layer.borderWidth = 0.5;
    self.setBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
        UILabel *version = [[UILabel alloc] initWithFrame:(CGRect){200,7,100,30}];
        version.tag = 101;
        version.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:version];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 3) {
        UILabel *version = (UILabel *)[self.view viewWithTag:101];
        if ([self compareWithAppVersion]) {
            version.text = [NSString stringWithFormat:@"最新版本: %@",_segton.serverVersions];
        }else{
            version.text = @"当前已是最新版本";
        }
    }
    cell.textLabel.text = _listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"设置成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"缓存已经清除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 2:
        {
            
            if ([self compareWithAppVersion]) {
                //跳转到appStore
               // NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/shan-hong-fang-zhi/id1020614336?mt=8"];
                NSString *str = [NSString stringWithFormat:@"http://115.236.2.245:38019/sh2.html"];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
             
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"杭州定川信息技术有限公司版权所有" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
       }
            
            break;
            
        case 3:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"杭州定川信息技术有限公司版权所有" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//版本比较，有新版本返回YES，无新版本返回NO
- (BOOL)compareWithAppVersion
{
    if (![_segton.serverVersions isEqualToString:@""]) {
        //先获取当前软件版本号
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if (![_segton.serverVersions isEqualToString:currentVersion]) {
            //有新版本
            return YES;
        }else{
            //没有新版本
            return NO;
        }
    }else{
        //版本号为空，不更新
        return NO;
    }
}

- (IBAction)changeAccountAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
