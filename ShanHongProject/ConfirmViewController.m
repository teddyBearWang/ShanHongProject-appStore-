//
//  ConfirmViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/8/24.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ConfirmViewController.h"
#import "CustomIOS7AlertView.h"
#import "SVProgressHUD.h"
#import "SendMessageObject.h"
#import "SingleInstanceObject.h"

@interface ConfirmViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,CustomIOS7AlertViewDelegate>
{
    UITableView *_tableView;
    
    UITextView *_contextView;
    
    SingleInstanceObject *_instance;//单例对象
}

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBar];
    
   // self.view.backgroundColor = BG_COLOR;
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _instance = [SingleInstanceObject defaultInstance];
}

- (void)initBar
{
    self.title = @"人员确认";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(cofirmAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - private Method
//确定
- (void)cofirmAction:(id)sender
{
    if (_instance.warnPeopleList.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前没有要发送预警的人员信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    CustomIOS7AlertView *alertView1 = [[CustomIOS7AlertView alloc] init];
    UIView *sView = [[UIView alloc] initWithFrame:(CGRect){0,0,300,200}];
    _contextView = [[UITextView alloc] initWithFrame:(CGRect){10,10,280,180}];
    _contextView.delegate = self;
    _contextView.text = @"点击编辑您要发送的短信";
    
    [sView addSubview:_contextView];
    [alertView1 setContainerView:sView];
    [alertView1 setButtonTitles:[NSArray arrayWithObjects:@"取消",@"确定",nil]];
    alertView1.delegate = self;
    [alertView1 show];
    [self.view addSubview:alertView1];
}

//取消
- (void)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSOurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _instance.warnPeopleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSDictionary *dic = _instance.warnPeopleList[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [dic objectForKey:@"PersonNM"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_contextView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //开始编辑的时候把原本存在的内容清空
    if ([textView.text isEqualToString:@"点击编辑您要发送的短信"]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_contextView resignFirstResponder];
}

#pragma mark - CustomIOS7AlertViewDelegate
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        if (_contextView.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"当前无输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        //点击确定按钮
        //请求发送短信的服务
        NSString *num = nil;
        for (int i=0; i<_instance.warnPeopleList.count; i++) {
            NSDictionary *dic = _instance.warnPeopleList[i];
            //一个人的信息
            //[dic objectForKey:@"Mobile"]
            NSString *personInfo = [NSString stringWithFormat:@"%@@%@",[dic objectForKey:@"personNM"],[dic objectForKey:@"Mobile"]];
            if (i == 0) {
                num = [NSString stringWithFormat:@"%@",personInfo];
            }else{
                num = [NSString stringWithFormat:@"%@,%@",num,personInfo];
            }
        }
        
        NSString *result = [NSString stringWithFormat:@"%@$%@",num,_contextView.text];
        [self sendMessageAction:result];
    }
    [alertView close];
}

- (void)sendMessageAction:(NSString *)result
{
    [SVProgressHUD showWithStatus:@"发送中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
        //
        if ([SendMessageObject fetchWithType:@"SendMessages" result:result]) {
            //更新UI
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"发送失败"];
            });
        }
    });
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithSuccess:@"发送成功"];
        NSArray *list = [SendMessageObject requestData];
        if (list.count != 0) {
            NSDictionary *result_dic = list[0];
            if ([[result_dic objectForKey:@"success"] rangeOfString:@"true"].length > 0) {
                [SVProgressHUD dismissWithSuccess:[result_dic objectForKey:@"result"]];
            }else{
                [SVProgressHUD dismissWithError:[result_dic objectForKey:@"result"]];
            }
        }
        
    });
}

@end
