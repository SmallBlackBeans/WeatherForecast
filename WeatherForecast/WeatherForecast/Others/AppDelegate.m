//
//  AppDelegate.m
//  天气
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "AppDelegate.h"
#import "WeatherViewController.h"
#import "CityModel.h"
#import "AllWeatherModel.h"

#define kKeyName @"name"
#define kKeyParentName @"parentname"
#define kKeyCode @"code"

@interface AppDelegate ()
{
    UIScrollView           *_introductionScrollView;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:SCREEN_BOUNDS];
    self.window.backgroundColor = COLOR_WHITECOLOR;
    [self.window makeKeyAndVisible];
    
//    self.window.rootViewController = [[UINavigationController alloc]  initWithRootViewController:[[WeatherViewController alloc] init]];
    
    UIViewController* vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = vc;
    
    // 获取应用的版本号 1,@"CFBundleVersion" 2,(NSString *)kCFBundleVersionKey
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
    NSString *saveVersion = [HXCTool objectForKey:@"saveVersion"];
    
    if ([saveVersion isEqualToString:currentVersion]) {
        [self gotoWeatherViewController];
    }
    else
    {
        [self gotoIntroductionScrollView];
        [HXCTool setObject:currentVersion forKey:@"saveVersion"];
    }
    
    return YES;
}

#pragma mark - 开始界面
#pragma mark 介绍界面
- (void)gotoIntroductionScrollView{
    
    _introductionScrollView = [[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS];
    _introductionScrollView.pagingEnabled = YES;
    
    NSInteger imageCount = 5;
    
    NSArray *imageNames = @[@"晴",@"云",@"雨",@"雪",@"大雪"];
    
    for (int i=0; i<imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        imageView.image = [UIImage sd_animatedGIFNamed:imageNames[i]];
        
        [_introductionScrollView addSubview:imageView];
        
        //最后一张图片的时候
        if (i == imageCount - 1) {
            imageView.userInteractionEnabled = YES;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(0, 0, 100, 44);
            btn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 50);
            [btn setTitle:@"进入程序" forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gotoWeatherViewController) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
        }
    }
    _introductionScrollView.contentSize = CGSizeMake(imageCount * SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.window addSubview:_introductionScrollView];
    
    NSArray *array = @[@"北京",@"北京市",@"101010100",@"上海",@"上海市",@"101020100",@"广州",@"广东省",@"101280101",@"深圳",@"广东省",@"101280601"];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.cityArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 12; i++) {
        CityModel *cityModel = [CityModel modelWithName:array[i] parentname:array[++i] code:array[++i]];
        [delegate.cityArray addObject:cityModel];
    }
    [AppDelegate saveData];
    
}

#pragma mark 进入主进程
- (void)gotoWeatherViewController{
    [UIView animateWithDuration:0.2 animations:^{
        _introductionScrollView.transform = CGAffineTransformMakeScale(2, 2);
        _introductionScrollView.alpha = 0.5;
    }completion:^(BOOL finished) {
        WeatherViewController *root = [[WeatherViewController alloc] init];
        [_introductionScrollView removeFromSuperview];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:root];
    }];
}

#pragma mark - 全局变量的增删改查方法
+ (void)parseData
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.cityArray = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *cityArray = [NSArray arrayWithContentsOfFile:kChosenCitysPath];
    for (NSDictionary *city in cityArray) {
        CityModel *model = [CityModel new];
        model.name = city[@"name"];
        model.parentname = city[@"parentname"];
        model.code = city[@"code"];
        
        [delegate.cityArray addObject:model];
    }
}

+ (void)saveData
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:0];
    for (CityModel *model in delegate.cityArray) {
        NSMutableDictionary *dict = [@{kKeyName : model.name,kKeyParentName : model.parentname, kKeyCode : model.code} mutableCopy];
        [cityArray addObject:dict];
    }
    BOOL ret = [cityArray writeToFile:kChosenCitysPath atomically:YES];
    NSLog(@"数据保存%@",ret ? @"成功":@"失败");
}

+ (AllWeatherModel *)findAllWeatherModelByCityId:(NSString *)cityID
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    for (AllWeatherModel *model in delegate.weatherArray) {
        if ([model.cityid isEqualToString:cityID]) {
            return model;
        }
    }
    return nil;
}

+ (BOOL)removeAllWeatherModelByCityId:(NSString *)cityID
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    for (AllWeatherModel *model in delegate.weatherArray) {
        if ([model.cityid isEqualToString:cityID]) {
            
            [delegate.weatherArray removeObject:model];
            
            return YES;
        }
    }
    return NO;
}


+ (BOOL)isExistsCityInCityArrayByCityModel:(CityModel *)model
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    for (CityModel *cityModel in delegate.cityArray) {
        if ([cityModel.code isEqualToString:model.code]) {
            return YES;
        }
    }
    return NO;
}
@end
