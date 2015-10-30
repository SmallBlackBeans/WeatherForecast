//
//  IndexesViewController.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pm25Model,CityModel,RealTimeModel;

@interface IndexesViewController : UIViewController

@property (nonatomic, strong) Pm25Model *pmModel;

@property (nonatomic, strong) NSArray *indexesArray;

@property (nonatomic, strong) CityModel *cityModel;

@property (nonatomic, strong) RealTimeModel *realTimeModel;

@end
