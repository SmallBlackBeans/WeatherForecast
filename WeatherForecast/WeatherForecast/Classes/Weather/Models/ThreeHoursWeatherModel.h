//
//  threeHoursWeatherModel.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeHoursWeatherModel : NSObject

/**
 *  对应天气图片
 */
@property (nonatomic, strong) NSString *img;
/**
 *  天气
 */
@property (nonatomic, strong) NSString *weather;
/**
 *  最低温度
 */
@property (nonatomic, strong) NSString *lowerestTemperature;
/**
 *  最高温度
 */
@property (nonatomic, strong) NSString *highestTemperature;
/**
 *  开始时间
 */
@property (nonatomic, strong) NSString *startTime;
/**
 *  结束时间
 */
@property (nonatomic, strong) NSString *endTime;

@end

/*
 "endTime": "2015-10-10 14:00:00",
 "highestTemperature": "17",
 "img": "0",
 "isRainFall": "无降水",
 "lowerestTemperature": "15",
 "precipitation": "0",
 "startTime": "2015-10-10 11:00:00",
 "wd": "北风",
 "weather": "晴",
 "ws": "2级"
 */