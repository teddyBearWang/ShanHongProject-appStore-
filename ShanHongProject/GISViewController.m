//
//  GISViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/16.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "GISViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "SingleInstanceObject.h"
#import "GISObject.h"
#import "SVProgressHUD.h"
#import "CustomAnnotation.h"
#import "FilterViewController.h"
#import "SelectViewController.h"
#import "StationType.h"
#import "FilterViewController.h"
#import "CustomAnnotationView.h"

//右边barItemView的宽度
#define RIGHTVIEWWIDTH 100
//右边barItemView的高度
#define RIGHTVIEWHEIHGT 45

//搜索按钮宽度
#define SelectBtnWidth 30
//搜索按钮高度
#define SelectBtnHeight 30
//间距
#define kMargin 5


@interface GISViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapVIew;
    NSArray *_sourceDatas; //元数据
    NSMutableArray *_filterDatas; //筛选数据(显示数据)
    SingleInstanceObject *_segton;//单例对象
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GISViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //取消
        [GISObject cancelRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"GIS应用";
    
    [self initNavigationBar];
    
    //初始化单例，并将默认显示的类型设置为"水位站"
    _segton = [SingleInstanceObject defaultInstance];
    //若是存在数据，先清空
    if (_segton.selectArray.count != 0) {
        [_segton.selectArray removeAllObjects];
    }
    StationType *station = [[StationType alloc] init];
    station.title = @"水位站";
    station.type = @"sw";
    station.imageName = @"1";
    _segton.selectArray = [NSMutableArray arrayWithObject:station];
    
    _filterDatas = [NSMutableArray array];
    
    //筛选返回触发通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowSingleStationAction:) name:KTapStationNotification object:nil];
    
    
    //开始加载网络数据
    [self getStationInfo];
}

- (void)initNavigationBar
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchStationAction)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - private Method
- (void)filterStationAction
{
    SelectViewController *select = [[SelectViewController alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    
    [select returnSelects:^(NSArray *selects) {
        //原本存在数值，则删除
        if (_filterDatas.count != 0) {
            [_filterDatas removeAllObjects];
        }
        //筛选数据
        [self filterSourceData];
        
        //现将原本地图上的移除
        [_mapVIew removeAnnotations:_mapVIew.annotations];
        
        //重新添加标注视图
        [self addAnnotationForMapView];
        
    }];
    [self.navigationController pushViewController:select animated:YES];
}

//进入到搜索界面
- (void)searchStationAction
{
    FilterViewController *filter = [[FilterViewController alloc] init];
    filter.data = _sourceDatas;//数据源
    filter.filterType = GISFilter;
    filter.title_name = @"站点搜索";
    [self.navigationController pushViewController:filter animated:YES];
}

//切换地图图层类型
- (void)ChangeMapViewType:(UIButton *)btn
{
    if (_mapVIew.mapType == MAMapTypeStandard) {
        [btn setBackgroundImage:[UIImage imageNamed:@"changed"] forState:UIControlStateNormal];
        _mapVIew.mapType = MAMapTypeSatellite;
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
        _mapVIew.mapType = MAMapTypeStandard;
    }
}

//创建地图
- (void)createMapView
{
    //取出本地文件
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [user objectForKey:STATION];
    
    _mapVIew = [[MAMapView alloc] initWithFrame:(CGRect){0,0,kScreen_Width,kScreen_height}];
    _mapVIew.mapType = MAMapTypeStandard;
    _mapVIew.delegate = self;
    _mapVIew.showsScale = NO;//不显示比例尺
    _mapVIew.showsCompass = NO;//不显示罗盘
    [self.view addSubview:_mapVIew];
    
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[userDic objectForKey:@"ScenterLat"] floatValue], [[userDic objectForKey:@"ScenterLng"] floatValue]);
    _mapVIew.centerCoordinate = coordinate;
    _mapVIew.zoomLevel = 10;//地图的显示等级
    
    [self addAnnotationForMapView];
    
    //创建功能按钮
    [self createFunctionView];
    
}

- (void)createFunctionView
{
    //站点选择
    UIButton *select = [UIButton buttonWithType:UIButtonTypeCustom];
    select.layer.cornerRadius = 5.0;
    select.layer.masksToBounds = YES;
    select.frame = (CGRect){kScreen_Width - kMargin*2-SelectBtnHeight,kMargin*2, SelectBtnWidth,SelectBtnHeight};
    [select setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [select setBackgroundImage:[UIImage imageNamed:@"select_click"] forState:UIControlStateHighlighted];
    [select addTarget:self action:@selector(filterStationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:select];
    
    UIButton *change = [UIButton buttonWithType:UIButtonTypeCustom];
    change.layer.cornerRadius = 5.0;
    change.layer.masksToBounds = YES;
    change.frame = (CGRect){kScreen_Width - kMargin*2-SelectBtnHeight,kMargin*4+SelectBtnWidth,SelectBtnWidth,SelectBtnHeight};
    [change setBackgroundImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [change addTarget:self action:@selector(ChangeMapViewType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:change];
}
#pragma mark - loadMap Private Method
//生成标注点
- (NSMutableArray *)addAnnotation
{
    NSMutableArray *annotations = [NSMutableArray array];
    for (int i=0; i<_filterDatas.count; i++) {
        NSDictionary *dic = [_filterDatas objectAtIndex:i];
        //首先判断不为空
        if ([[dic objectForKey:@"X"] isEqualToString:@""] && [[dic objectForKey:@"X"] isEqualToString:@""]) {
            continue;
        }else{
            //再次判断不全为0
            if ([[dic objectForKey:@"X"] floatValue] != 0 || [[dic objectForKey:@"Y"] floatValue] != 0) {
                CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"Y"] floatValue], [[dic objectForKey:@"X"] floatValue]);
                annotation.type = [dic objectForKey:@"MyType"];
                annotation.stationName = [dic objectForKey:@"STNM"];
                annotation.valueName = [dic objectForKey:@"VALUE1"];
                [annotations addObject:annotation];
            }
            
        }
    }
    return annotations;
}

//添加标注视图到地图上
- (void)addAnnotationForMapView
{
    //添加标注到地图上
    NSArray *annotations = (NSArray *)[self addAnnotation];
    [_mapVIew addAnnotations:annotations];
}


#pragma mark - Private

- (void)getStationInfo
{
    [SVProgressHUD showWithStatus:@"加载中.."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([GISObject fetch]) {
            //updateUI
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
        _sourceDatas = [GISObject requestData];
        [self filterSourceData];
        
        [self createMapView];
        });
    
}

//筛选数据
- (void)filterSourceData
{
    NSArray *array = [NSArray array];
    for (int i=0; i<_segton.selectArray.count; i++) {
        StationType *station = _segton.selectArray[i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"MyType",station.type];
        //传递进来的谓词，筛选数据
        NSArray *filters = [_sourceDatas filteredArrayUsingPredicate:predicate];
       array = (NSMutableArray *)[array arrayByAddingObjectsFromArray:filters];
        
    }
    
    _filterDatas = [NSMutableArray arrayWithArray:array];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//显示单个站点
- (void)ShowSingleStationAction:(NSNotification *)notification
{
    //全部移除原来的
    [_mapVIew removeAnnotations:_mapVIew.annotations];
    NSDictionary *dic = (NSDictionary *)notification.object;
    //再次判断不全为0
    CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"Y"] floatValue], [[dic objectForKey:@"X"] floatValue]);
    annotation.type = [dic objectForKey:@"MyType"];
    annotation.stationName = [dic objectForKey:@"STNM"];
    annotation.valueName = [dic objectForKey:@"VALUE1"];
    [_mapVIew addAnnotation:annotation];
}


#pragma mark - MAMapViewDelegate
/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    CustomAnnotation *ann = (CustomAnnotation *)annotation;
    
    if ([ann isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *identifer = @"Annotation";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer];
        }
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapAnnotationVIewAction:)];
//        tap.numberOfTapsRequired = 1;
//        [annotationView addGestureRecognizer:tap];
        annotationView.calloutOffset = CGPointMake(95, -5);//向右偏移75个像素，向下偏移40个像素
        annotationView.canShowCallout = NO;
        annotationView.centerOffset = CGPointMake(0, -18);//标注的中心点坐标向上偏移18个像素
        if ([ann.type isEqualToString:@"sw"])
        {
            annotationView.image = [UIImage imageNamed:@"1"];
            annotationView.station = [NSString stringWithFormat:@"水位测站: %@",ann.stationName];
            annotationView.value = [NSString stringWithFormat:@"当前水位: %@ m",ann.valueName];
        }
        else if ([ann.type isEqualToString:@"yl"]){
            annotationView.image = [UIImage imageNamed:@"2"];
            annotationView.station = [NSString stringWithFormat:@"雨量测站: %@",ann.stationName];
            annotationView.value = [NSString stringWithFormat:@"1h雨量: %@ mm",ann.valueName];
        }
        else if ([ann.type isEqualToString:@"sk"])
        {
            annotationView.image = [UIImage imageNamed:@"3"];
            annotationView.station = [NSString stringWithFormat:@"水库名称: %@",ann.stationName];
            annotationView.value = [NSString stringWithFormat:@"所属乡镇: %@",ann.valueName];
        }
        else if ([ann.type isEqualToString:@"sz"])
        {
            annotationView.image = [UIImage imageNamed:@"4"];
            annotationView.station = [NSString stringWithFormat:@"水闸名称: %@",ann.stationName];
            annotationView.value = [NSString stringWithFormat:@"所属乡镇: %@",ann.valueName];
        }
        else if ([ann.type isEqualToString:@"df"])
        {
            annotationView.image = [UIImage imageNamed:@"5"];
            annotationView.station = [NSString stringWithFormat:@"堤防名称: %@",ann.stationName];
            annotationView.value = [NSString stringWithFormat:@"所属乡镇: %@",ann.valueName];
        }
        else if ([ann.type isEqualToString:@"sdz"])
        {
            annotationView.image = [UIImage imageNamed:@"6"];
            annotationView.station = [NSString stringWithFormat:@"水电站名称: %@",ann.stationName];
            annotationView.value = [NSString stringWithFormat:@"所属乡镇: %@",ann.valueName];
        }
        else
        {
            annotationView.image = [UIImage imageNamed:@"7"];
            annotationView.station = [NSString stringWithFormat:@"山塘名称: %@",ann.stationName];
            annotationView.value = [NSString stringWithFormat:@"所属乡镇: %@",ann.valueName];
            
        }
        if (mapView.zoomLevel > 12) {
            annotationView.selected = YES;//处于选中的状态
        }
        
        return annotationView;
    }
   
    return nil;
}

/*
 @brief 地图区域即将改变时会调用此接口
 @param mapview 地图View
 @param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //地图进行缩放的时候，先将地图上的标注点全部删除，然后重新添加标注点
    if (mapView.annotations.count > 0) {
        [mapView removeAnnotations:mapView.annotations];
    }
    [self addAnnotationForMapView];
}

//
//- (void)tapAnnotationVIewAction:(UIGestureRecognizer *)tap
//{
//    CustomAnnotationView *annotationView = (CustomAnnotationView *)tap.view;
//    CustomAnnotation *ann  = (CustomAnnotation *)annotationView.annotation;
//}

@end
