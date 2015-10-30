//
//  WeatherCell.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllWeatherModel,WeatherCell,CityModel;

@protocol WeatherCellDelegate <NSObject>

- (void)weatherCell:(WeatherCell *)weatherCell loadDataWithCityModel:(CityModel *)cityModel;

@end

@interface WeatherCell : UICollectionViewCell

@property (nonatomic, weak) id<WeatherCellDelegate> delegate;

@property (nonatomic, strong) CityModel *cityModel;

@property (nonatomic, strong) AllWeatherModel *model;

- (void)endHeaderView;

+ (NSString *)identifier;

- (void)setBackgroundImageViewWithImage:(UIImage *)image;

@end
