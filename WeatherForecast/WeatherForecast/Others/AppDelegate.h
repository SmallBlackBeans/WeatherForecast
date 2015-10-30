//
//  AppDelegate.h
//  天气
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllWeatherModel,CityModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  需要显示的城市的数组
 */
@property (nonatomic, strong) NSMutableArray *cityArray;
/**
 *  城市天气信息数组
 */
@property (nonatomic, strong) NSMutableArray *weatherArray;

@property (nonatomic, strong) CityModel     *currentCityModel;

+ (void)parseData;

+ (void)saveData;

+ (AllWeatherModel *)findAllWeatherModelByCityId:(NSString *)cityID;

+ (BOOL)removeAllWeatherModelByCityId:(NSString *)cityID;

+ (BOOL)isExistsCityInCityArrayByCityModel:(CityModel *)model;
@end


