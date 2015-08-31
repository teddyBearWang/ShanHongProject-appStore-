//
//  PlanDetailController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/14.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "PlanDetailController.h"
#import "PlanObject.h"
#import "DownloadFile.h"
#import "SVProgressHUD.h"
#import "PdfReaderViewController.h"

@interface PlanDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_listData;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PlanDetailController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [PlanObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.dic objectForKey:@"Sname"];
    
    self.tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height} style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //注册两个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileDownloadComplete:) name:FILESDOWNLOADCOMPLETE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileDownloadFail:) name:FILEDOWNLOADFAIL object:nil];
    
    [self requestHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Method
- (void)requestHttp
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([PlanObject fetchWithSicd:[self.dic objectForKey:@"PersonCD"]]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //加载失败
                [SVProgressHUD dismissWithError:@"加载失败"];
            });
        }
    });
}

- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:@"加载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _listData = [PlanObject requestDatas];
        [self.tableView reloadData];
    });
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = _listData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [dic objectForKey:@"PersonNM"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _listData[indexPath.row];
    if ([[dic objectForKey:@"PlanUrl"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无效的地址" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self downPDFFile:[dic objectForKey:@"PlanUrl"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 下载PDF

- (void)downPDFFile:(NSString *)url
{
    DownloadFile *downloadFile = [DownloadFile shareTheme];
    [SVProgressHUD showWithStatus:@"下载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加载
        [downloadFile DownloadFilesUrl:url];
    });
}

//下载成功
- (void)FileDownloadComplete:(NSNotification *)notification
{
    [SVProgressHUD dismissWithSuccess:@"下载成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新UI
        NSString *filePath = notification.object;
        //push到下个界面
        PdfReaderViewController *reader = [[PdfReaderViewController alloc] init];
        reader.pdfName = filePath;
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"返回";
        self.navigationItem.backBarButtonItem = back;
        [self.navigationController pushViewController:reader animated:YES];
    });
}

- (void)FileDownloadFail:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithError:@"下载失败"];
    });
}

@end
