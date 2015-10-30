//
//  Pm25View.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pm25Model;

@interface Pm25View : UIView

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) Pm25Model *pm25Model;

@end
