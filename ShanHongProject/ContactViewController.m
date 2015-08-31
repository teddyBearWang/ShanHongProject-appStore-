//
//  ContactViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "ContactViewController.h"
#import "SVProgressHUD.h"
#import "FilterObject.h"
#import "ContactCell.h"

@interface ContactViewController ()<UISearchBarDelegate>
{
    UISearchBar *searchBar;
}


@end

@implementation ContactViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [FilterObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    searchBar = [[UISearchBar alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width,44}];
    searchBar.placeholder = @"可以根据手机号码、职位、姓名搜索";
    searchBar.delegate = self;
    
    //添加searchBar到headerView上面
    self.tableView.tableHeaderView = searchBar;
    
    //用searchBar初始化SearchDisplayController
    //把searchDispalyController和当前的controller关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    //searchResultsDelegate就是UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    //searchResultsDataSource就是UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;

    
    [self getWebAction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWebAction
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([FilterObject fetchFilterDataWithType:@"GetAdressSearch"]) {
           
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
        //加载成功
        _data = [FilterObject requestData];
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return _data.count;
    }else{
        return filterData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = (ContactCell *)[[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:nil options:nil] lastObject];
    }
    
    NSDictionary *dic = nil;
    if (tableView == self.tableView) {
        dic = _data[indexPath.row];
    }else{
        dic = filterData[indexPath.row];
    }
    [cell updateCell:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = nil;
    if (tableView == self.tableView) {
       dic = _data[indexPath.row];
    }else{
      dic  = filterData[indexPath.row];
    }
    NSString *str = [dic objectForKey:@"Mobile"];
    [self takePhone:str];
    
}

- (void)takePhone:(NSString *)num
{
    if (num.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你选择的时空号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSString *str = [NSString stringWithFormat:@"tel://%@",num];
        NSURL *url = [NSURL URLWithString:str];
        UIWebView *webView  = [[UIWebView alloc] init];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:webView];
    }
    
}

#pragma mark -UISearchBarDelegate

//将cancel按钮修改"取消"（或者自定义）
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [searchBar setShowsCancelButton:YES];
    for (UIView *view in searchBar.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            //得到button
            [(UIButton *)view setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

// called when text ends editing，当searchBar释放第一响应者的时候开始搜索
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    return;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //谓词搜索
    /**< 模糊查找*/
    // NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", keyName, searchText];
  //  NSPredicate *predicate;
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"MySearchName",searchDisplayController.searchBar.text];
    
    
    filterData = [[NSArray alloc] initWithArray:[_data filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

@end
