//
//  LoginViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/8.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"
#import "StationSelectController.h"
#import "SingleInstanceObject.h"
#import "LoginToken.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()<selectDelegate>
{
    UIButton *statusBtn;//站点
    SingleInstanceObject *_single;
    NSArray *data;//得到的数据
}
@property (weak, nonatomic) IBOutlet UINavigationBar *bar; //导航栏
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *psw;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *user_image;

@property (weak, nonatomic) IBOutlet UIImageView *psw_image;
@property (weak, nonatomic) IBOutlet UIView *user_bg_view;
@property (weak, nonatomic) IBOutlet UIView *psw_bg_view;

//登陆
- (IBAction)loginAction:(id)sender;
//单机背景取消键盘
- (IBAction)tapBackground:(id)sender;

@end

@implementation LoginViewController

- (void)initNavBar
{
    self.bar.translucent = NO;
    [self.bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.bar.barTintColor = [UIColor colorWithRed:4/255.0 green:17/255.0 blue:49/255.0 alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建单例
    _single = [SingleInstanceObject defaultInstance];
    self.view.backgroundColor = BG_COLOR;
    [self initNavBar];
    
    statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.frame = (CGRect){0,0,50,30};
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [statusBtn addTarget:self action:@selector(stationSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:statusBtn];
    
    UINavigationItem *nabigationItem = [[UINavigationItem alloc] init];
    [nabigationItem setHidesBackButton:YES];//隐藏返回按钮=
    nabigationItem.title = @"登陆";
    nabigationItem.rightBarButtonItem = item;
    [self.bar pushNavigationItem:nabigationItem animated:YES];
    
    self.user_bg_view.layer.cornerRadius = 5.0;
    self.user_bg_view.layer.masksToBounds = YES;
    self.user_image.image = [UIImage imageNamed:@"user"];
    
    self.psw_bg_view.layer.cornerRadius = 5.0;
    self.psw_bg_view.layer.masksToBounds = YES;
    self.psw.secureTextEntry = YES;
    self.psw_image.image = [UIImage imageNamed:@"password"];
    
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.backgroundColor = [UIColor colorWithRed:56/255.0 green:131/255.0 blue:238/255.0 alpha:1.0];
    
    //获取本地的数值
    [self getInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender
{
    if ([statusBtn.currentTitle isEqualToString:@"站点"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请选择站点" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.userName.text.length == 0 || self.psw.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([LoginToken fetchWithUserName:self.userName.text Psw:self.psw.text Version:@"1.0.1" CityName:statusBtn.currentTitle]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                data = [LoginToken requestDatas];
                if (data.count != 0) {
                    [SVProgressHUD dismissWithSuccess:@"登陆成功"];
                    NSDictionary *dic = [data objectAtIndex:0];
                    _single.serverVersions = [dic objectForKey:@"version"];
                    [self saveInfo];
                    [self pushView:[data lastObject]];

                }else{
                    [SVProgressHUD dismissWithError:@"登陆失败"];
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:@"登陆失败"];
            });
        }
    });
}

//本地储存
- (void)saveInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName.text forKey:USERNAME];
    [defaults setObject:self.psw.text forKey:PASSWORD];
    [defaults setObject:statusBtn.currentTitle forKey:SITE];
    [defaults synchronize];
}

- (void)getInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userName.text = [defaults objectForKey:USERNAME];
    self.psw.text = [defaults objectForKey:PASSWORD];
    if ([defaults objectForKey:SITE] == nil) {
        //没有值
        [statusBtn setTitle:@"站点" forState:UIControlStateNormal];
    }else{
        [statusBtn setTitle:[defaults objectForKey:SITE] forState:UIControlStateNormal];
    }
}


//push到下一个界面
- (void)pushView:(NSDictionary *)dic
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MenuViewController *menu = (MenuViewController *)[story instantiateViewControllerWithIdentifier:@"menu"];
    menu.loginDic = dic;//完成数值的传递
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:4/255.0 green:17/255.0 blue:49/255.0 alpha:1];
    nav.navigationBar.tintColor = [UIColor whiteColor];//修改返回按钮的颜色
    // nav.interactivePopGestureRecognizer.enabled = NO; 禁止左滑返回手势
    //设置标题颜色
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBar.translucent = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.view cache:YES];
    [self presentViewController:nav animated:YES completion:NULL];
    
    [UIView commitAnimations];
}

//站点选择
- (void)stationSelectAction:(UIButton *)btn
{
    StationSelectController *station = [[StationSelectController alloc] init];
    station.delegate = self;
    [self presentViewController:station animated:YES completion:NULL];
}

- (IBAction)tapBackground:(id)sender
{
    [self.userName resignFirstResponder];
    [self.psw resignFirstResponder];
}

#pragma mark - SelectStationDelegate
- (void)selectStationAction:(NSString *)area
{
    [statusBtn setTitle:area forState:UIControlStateNormal];
}
@end
