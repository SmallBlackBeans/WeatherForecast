//
//  OneDayModel.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneDayModel : NSObject

// 别称
@property (nonatomic, strong) NSString *name;

// 白天温度（摄氏度）
@property (nonatomic, strong) NSString *temp_day_c;

// 夜间温度（摄氏度）
@property (nonatomic, strong) NSString *temp_night_c;

// 白天温度（华氏度）
@property (nonatomic, strong) NSString *temp_day_f;

// 夜间温度（华氏度）
@property (nonatomic, strong) NSString *temp_night_f;

// 图片名
@property (nonatomic, strong) NSString *img;

// 天气
@property (nonatomic, strong) NSString *weather;

// 太阳出来的时间
@property (nonatomic, strong) NSString *sun_rise_time;

// 太阳下山的时间
@property (nonatomic, strong) NSString *sun_down_time;

// 星期
@property (nonatomic, strong) NSString *week;

// 风向
@property (nonatomic, strong) NSString *wd;

// 风级
@property (nonatomic, strong) NSString *ws;

// 时间
@property (nonatomic, strong) NSString *date;

@end
