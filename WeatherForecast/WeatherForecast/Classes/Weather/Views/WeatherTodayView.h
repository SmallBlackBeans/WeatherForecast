//
//  WeatherTodayView.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherDetailsInfoModel,RealTimeModel,OneDayModel;

@interface WeatherTodayView : UIView

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) WeatherDetailsInfoModel *weatherDetailsInfoModel;

@property (nonatomic, strong) RealTimeModel *realTimeModel;

@property (nonatomic, strong) OneDayModel *oneDayModel;

- (void)viewWithRealTimeModel:(RealTimeModel *)realTimeModel andWeatherDetailsInfoModel:(WeatherDetailsInfoModel *)weatherDetailsInfoModel;

@end
