//
//  Pm25Model.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 数据样式
    
 pm25 = {
	color = ,
	no2 = 0,
	co = 0.0,
	timestamp = 0,
	pm25 = 21,
	aqi = 51,
	so2 = 0,
	advice = ,
	level = 0,
	o3 = 0,
	cityrank = 45,
	pm10 = 53,
	quality = 良,
	citycount = 1735,
	upDateTime = 2015-10-10 18:04:33
 },

 */

@interface Pm25Model : NSObject

/**
 *  pm2.5的值
 */
@property (nonatomic, strong) NSString *pm25;
/**
 *  pm10的值
 */
@property (nonatomic, strong) NSString *pm10;
/**
 *  空气质量
 */
@property (nonatomic, strong) NSString *quality;
/**
 *  空气质量值
 */
@property (nonatomic, strong) NSString *aqi;

// 超过了?%的地区
@property (nonatomic, strong) NSString *cityrank;

@end
