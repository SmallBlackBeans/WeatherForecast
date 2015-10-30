//
//  WeatherCell.m
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "WeatherCell.h"
#import "AllWeatherModel.h"
#import "WeatherOneDayCell.h"
#import "CityModel.h"
#import "OneDayModel.h"
#import "WeatherTodayView.h"
#import "WeatherDetailsInfoModel.h"


static NSString * weatherCellId = @"weatherCell";

@interface WeatherCell ()<UITableViewDataSource,UITableViewDelegate>

// cell的背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *weatherArray;

@property (nonatomic, strong) WeatherTodayView *todayView;

@end

@implementation WeatherCell

+ (NSString *)identifier
{
    return weatherCellId;
}

- (void)awakeFromNib {
    
    [_tableView registerNib:[UINib nibWithNibName:@"WeatherOneDayCell" bundle:nil] forCellReuseIdentifier:[WeatherOneDayCell identifier]];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView addHeaderWithCallback:^{
        if ([_delegate respondsToSelector:@selector(weatherCell:loadDataWithCityModel:)]) {
            [_delegate weatherCell:self loadDataWithCityModel:_cityModel];
        }
    }];
    
    _todayView = [[WeatherTodayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
    _tableView.tableHeaderView = _todayView;
}

#pragma mark - 重写model的setting方法
- (void)setModel:(AllWeatherModel *)model
{
    _model = model;
    
    _weatherArray = [NSMutableArray arrayWithCapacity:0];
    
    if (model.weathers.count > 0) {
        OneDayModel *oneDayModel = [model.weathers lastObject];
        oneDayModel.name = @"昨天";
        [_weatherArray addObject:oneDayModel];
        
        for (int i = 1; i < 6; i++) {
            oneDayModel = [model.weathers objectAtIndex:i];
            if (i == 1) {
                oneDayModel.name = @"明天";
            }
            else
            {
                oneDayModel.name = oneDayModel.week;
            }
            [_weatherArray addObject:oneDayModel];
        }
    }
    
    _todayView.oneDayModel = [model.weathers firstObject];
    [_todayView viewWithRealTimeModel:model.realtime andWeatherDetailsInfoModel:model.weatherDetailsInfoModel];
   
    _todayView.cityName = _cityModel.name;
    
    
    [_tableView reloadData];
    
}
#pragma mark cityName的setting方法
- (void)setCityModel:(CityModel *)cityModel
{
    _cityModel = cityModel;
    _todayView.cityName = cityModel.name;
}
#pragma mark 设置背景图片
- (void)setBackgroundImageViewWithImage:(UIImage *)image
{
    _backgroundImageView.image = image;
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
#pragma mark 项数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
#pragma mark TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherOneDayCell * cell = [tableView dequeueReusableCellWithIdentifier:[WeatherOneDayCell identifier] forIndexPath:indexPath];
    
    if (_weatherArray.count > 0) {
        cell.model = _weatherArray[indexPath.row];
    }else
    {
        cell.model = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 停止下拉刷新视图
- (void)endHeaderView{
    [_tableView headerEndRefreshing];
}
@end
