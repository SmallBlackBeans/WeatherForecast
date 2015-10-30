//
//  WeatherOneDayCell.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OneDayModel;

@interface WeatherOneDayCell : UITableViewCell

@property (nonatomic, strong) OneDayModel *model;

+ (NSString *)identifier;

@end
