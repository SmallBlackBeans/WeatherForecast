//
//  WeatherDetailsInfoModel.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDetailsInfoModel : NSObject

@property (nonatomic, strong) NSString *publishTime;

@property (nonatomic, strong) NSMutableArray *weather3HoursDetailsInfos;

- (NSInteger)currentTimeIndex;

@end
