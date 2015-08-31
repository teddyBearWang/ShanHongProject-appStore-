//
//  QxDetailController.m
//  ShanHongProject
//
//  Created by teddy on 15/6/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QxDetailController.h"
#import "SVProgressHUD.h"
#import "QiXiangObject.h"
#import "UIImageView+WebCache.h"

@interface QxDetailController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIImageView *image_view;
    NSArray *datas;//数据源
    UIButton *actionBtn;//开始停止按钮
    NSTimer *timers ;
    BOOL _ispaly;
}


@end

@implementation QxDetailController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [SVProgressHUD dismissWithError:nil];
        [QiXiangObject cancelRequest];
        //将定时器停掉
        [timers invalidate];
        
        //清除图片缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[SDImageCache sharedImageCache] clearMemory];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.title_name;
    
    actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = (CGRect){0,0,60,30};
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [actionBtn setTitle:@"开始播放" forState:UIControlStateNormal];
    _ispaly = NO;
    [actionBtn addTarget:self action:@selector(startPlayImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:actionBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    image_view = [[UIImageView alloc] init];
    
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //设置scrollVIew四周增加额外的滚动区域
    CGFloat distance = 5.0f;
    scrollView.contentInset = UIEdgeInsetsMake(distance, distance, distance, distance);
    //设置缩放时候的最大最小倍数
    scrollView.minimumZoomScale = 0.2f;
    scrollView.maximumZoomScale = 3.0f;
    scrollView.bounces = YES;//弹簧效果
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    [scrollView addSubview:image_view];
    [self.view addSubview:scrollView];
    
    [self getWebData];
    
}

- (void)getWebData
{
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([QiXiangObject fetchWithType:self.type]) {
            //更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程
                [SVProgressHUD dismiss];
                datas = [QiXiangObject requestDatas];
                if (datas.count != 0) {
                    NSDictionary *dic = [datas objectAtIndex:(datas.count - 1)];
                    [self updateUI:[dic objectForKey:@"img"]];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"得到的数据为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }

            });
        }else{
            [SVProgressHUD dismissWithError:@"加载失败"];
        }
    });
}


- (void)updateUI:(NSString *)img_url
{

    [self downloadImage:img_url];

}

- (void)downloadImage:(NSString *)img_url
{
    [SVProgressHUD show];
    NSURL *url = [NSURL URLWithString:[img_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //用block 可以在图片加载完成之后做些事情
    [image_view sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [SVProgressHUD dismiss];
        CGFloat imageH = image.size.height;
        CGFloat imageW = image.size.width;
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        
        image_view.frame = (CGRect){imageX,imageY,imageW,imageH};
        scrollView.contentSize = CGSizeMake(imageW, imageH);
    }];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int count = 0;
- (void)updateImageViewAction:(NSTimer *)timer
{
    if (count != datas.count) {
        NSString *image_url = [[datas objectAtIndex:count] objectForKey:@"img"];
        [self updateUI:image_url];
        self.title = [[datas objectAtIndex:count] objectForKey:@"time"];
        count++;
    }else{
        [actionBtn setTitle:@"开始" forState:UIControlStateNormal];
        count = 0;
        //停止计时器
        [timer invalidate];
    }
    
}

//开始播放
- (void)startPlayImage:(UIButton *)btn
{
    if (_ispaly == NO) {
        _ispaly = YES;
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        //启动定时器
        timers = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateImageViewAction:) userInfo:nil repeats:YES];
        if (count == datas.count) {
            count = 0;//若是全部播放结束了，那就从新开始
        }
    }else{
        [btn setTitle:@"继续播放" forState:UIControlStateNormal];
        _ispaly = NO;
        [timers invalidate];
    }
}

#pragma mark 缩放
/**
 *  缩放结束时调用
 *
 *  @param scrollView <#scrollView description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return image_view;
}


/**
 *  缩放过程中调用
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    return;
}



/**
 *  缩放结束时调用
 *
 *  @param scrollView <#scrollView description#>
 *  @param view       <#view description#>
 *  @param scale      <#scale description#>
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    return;
}


@end
