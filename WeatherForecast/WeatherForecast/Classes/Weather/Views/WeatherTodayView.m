//
//  WeatherTodayView.m
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "WeatherDetailsInfoModel.h"
#import "ThreeHoursWeatherModel.h"
#import "WeatherTodayView.h"
#import "RealTimeModel.h"
#import "OneDayModel.h"


@interface WeatherTodayView ()
/**
 *  城市名
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 *  温度
 */
@property (nonatomic, strong) UILabel *tempLabel;

/**
 *  天气
 */
@property (nonatomic, strong) UILabel *weatherLabel;

/**
 *
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  天气图标
 */
@property (nonatomic, strong) UIImageView *weatherIcon;

// 发布时间
@property (nonatomic, strong) UILabel *publishTimeLabel;

@property (nonatomic, assign) BOOL        isNight;

@end

@implementation WeatherTodayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _nameLabel = [XCView createLabelWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40) text:@"未知" font:FONT(20) textColor:COLOR_WHITECOLOR];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        _tempLabel = [XCView createLabelWithFrame:CGRectMake(0, _nameLabel.maxY + 10, SCREEN_WIDTH, 80) text:@"N/A" font:FONT(80) textColor:COLOR_WHITECOLOR];
        _tempLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tempLabel];
        
        _weatherIcon = [[UIImageView alloc]initWithFrame:CGRectMake( SCREEN_WIDTH / 2 - 60, _tempLabel.maxY + 10, 50, 50)];
        _weatherIcon.image = [UIImage imageNamed:@"undefined"];
        [self addSubview:_weatherIcon];
        
        _weatherLabel = [XCView createLabelWithFrame:CGRectMake(_weatherIcon.maxX + 10 , _weatherIcon.center.y, SCREEN_WIDTH / 2 - 20, 20) text:@"没有网络数据" font:FONT(15) textColor:COLOR_WHITECOLOR];
        _weatherLabel.center  = CGPointMake(_weatherLabel.center.x, _weatherIcon.center.y);
        [self addSubview:_weatherLabel];
        
        // 发布时间
        _publishTimeLabel = [UILabel labelWithFrame:CGRectMake(20, 20, 200, 15) text:@"" font:FONT(13) textColor:COLOR_WHITECOLOR];
        _publishTimeLabel.center = CGPointMake(_tempLabel.centerX, _weatherIcon.maxY + 10);
        _publishTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_publishTimeLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark oneDayModel的setting方法
- (void)setOneDayModel:(OneDayModel *)oneDayModel
{
    _oneDayModel = oneDayModel;
    
    if (oneDayModel) {
        _weatherLabel.text = [NSString stringWithFormat:@"%@ %@°~%@°",oneDayModel.weather,oneDayModel.temp_night_c,oneDayModel.temp_day_c];
    }else
    {
        _weatherLabel.text = @"没有网络数据";
    }
}
#pragma mark 确定白天还是晚上
- (void)viewWithRealTimeModel:(RealTimeModel *)realTimeModel andWeatherDetailsInfoModel:(WeatherDetailsInfoModel *)weatherDetailsInfoModel
{
    _realTimeModel = realTimeModel;
    _weatherDetailsInfoModel = weatherDetailsInfoModel;
    
    if (realTimeModel) {
        
        // 确定白天还是晚上
        NSString *nowDateStr = [self subTimeWithDate:realTimeModel.time];
        CGFloat nowTime = [self dateStringToDateFloat:nowDateStr];
        CGFloat sunRiseTime = [self dateStringToDateFloat:_oneDayModel.sun_rise_time];
        CGFloat sunDownTime = [self dateStringToDateFloat:_oneDayModel.sun_down_time];
        if (nowTime >= sunRiseTime && nowTime < sunDownTime) {
            _isNight = NO;
        }else
        {
            _isNight = YES;
        }
        
        _publishTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",weatherDetailsInfoModel.publishTime];
        
        _tempLabel.text = [NSString stringWithFormat:@"%@°",realTimeModel.sendibleTemp];
        
        _weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:_isNight ? @"night_%02d" : @"day_%02d",[_oneDayModel.img intValue]]];
    }
    else
    {
        _publishTimeLabel.text = @"";
        _tempLabel.text = @"N/A";
        _weatherIcon.image = [UIImage imageNamed:@"undefined"];
    }
    
  
    [self setNeedsDisplay];
    
}

#pragma mark 重写cityName的setting方法
- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    _nameLabel.text =cityName;
}
#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    // 温度坐标线的y值
    CGFloat tempY = _weatherLabel.maxY + 130;
    
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 直线宽
    CGContextSetLineWidth(context, 1.0f);
    
    // 直线颜色
    [COLOR_WHITECOLOR set];
    
    // 直线两端样式
    CGContextSetLineCap(context, kCGLineCapButt);
    
    // 直线连接点样式
//    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    const CGPoint points1[] = {CGPointMake(30, tempY), CGPointMake(SCREEN_WIDTH - 30, tempY)};
    
    CGContextStrokeLineSegments(context, points1, sizeof(points1) / sizeof(points1[0]));
    
    CGFloat lineWidth = SCREEN_WIDTH - 60;
    CGFloat margin = (lineWidth - 20) / 6.0;
    
    // 线的所有起点
    CGPoint startingPoints[] = {
        CGPointMake(40, tempY),CGPointMake(40 + margin, tempY ),CGPointMake(40 + margin * 2, tempY),CGPointMake(40 + margin * 3, tempY),CGPointMake(40 + margin * 4, tempY),CGPointMake(40 + margin * 5, tempY),CGPointMake(40 + margin * 6, tempY)
    };
    
    // 所有的平均温度
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:7];
    if (_weatherDetailsInfoModel.weather3HoursDetailsInfos.count == 0) {
        for (int i = 0; i < 7; i++) {
            [tempArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    else
    {
        for (int i = 0; i < 7; i++) {
            ThreeHoursWeatherModel *model = _weatherDetailsInfoModel.weather3HoursDetailsInfos[i];
            [tempArray addObject:[NSNumber numberWithInt:(int)[self averageThreeHoursTempByModel:model]]];
        }
    }
    
    // 显得所有终点
    CGPoint endingPoints[] = {
        CGPointMake(40 , tempY - [tempArray[0] intValue] * 2),
        CGPointMake(40 + margin, tempY - [tempArray[1] intValue] * 2),
        CGPointMake(40 + margin * 2, tempY - [tempArray[2] intValue] * 2),
        CGPointMake(40 + margin * 3, tempY - [tempArray[3] intValue] * 2 ),
        CGPointMake(40 + margin * 4, tempY - [tempArray[4] intValue] * 2),
        CGPointMake(40 + margin * 5, tempY - [tempArray[5] intValue] * 2),
        CGPointMake(40 + margin * 6, tempY - [tempArray[6] intValue] * 2)
    };
    const CGPoint points2[] = {
        startingPoints[0],endingPoints[0],
        startingPoints[1],endingPoints[1],
        startingPoints[2],endingPoints[2],
        startingPoints[3],endingPoints[3],
        startingPoints[4],endingPoints[4],
        startingPoints[5],endingPoints[5],
        startingPoints[6],endingPoints[6],
    };
    // 绘制温度点
    CGContextSetLineWidth(context, 1.5f);
    
    // 绘制温度和天气
    for(int i = 0 ;i < tempArray.count ; i++)
    {
        ThreeHoursWeatherModel *model = nil;
        if(_weatherDetailsInfoModel.weather3HoursDetailsInfos.count > 0)
        {
           model = _weatherDetailsInfoModel.weather3HoursDetailsInfos[i];
        }
        
        CGRect rect = CGRectMake(endingPoints[i].x - 2.5, endingPoints[i].y - 2.5, 5, 5);
        CGContextFillEllipseInRect(context, rect);
        
        NSString *temp = [NSString  stringWithFormat:@"%d",(int)(tempY / 2 - endingPoints[i].y / 2)];
        NSString *time = model == nil ? @"00:00" : [self subTimeWithDate:model.startTime];
        NSString *weather = model == nil ? @"N/A" : model.weather;
        
        // 计算文字的尺寸
        CGSize tempSize = [temp boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT(10)} context:nil].size;
        CGSize timeSize = [time boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT(10)} context:nil].size;
        CGSize weatherSize = [weather boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT(10)} context:nil].size;
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        if ([tempArray[i] intValue] >= 0) {
            [time drawAtPoint:CGPointMake(startingPoints[i].x - timeSize.width / 2, startingPoints[i].y + 5) withAttributes:
             @{ NSFontAttributeName : [UIFont systemFontOfSize:10],
                NSForegroundColorAttributeName : COLOR_WHITECOLOR
                }];
            
            [weather drawAtPoint:CGPointMake(startingPoints[i].x - weatherSize.width / 2, startingPoints[i].y + timeSize.height + 5) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
            
            [[NSString stringWithFormat:@"%@°",temp] drawAtPoint:CGPointMake(endingPoints[i].x - tempSize.width / 2, endingPoints[i].y - tempSize.height - 5) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
        }
        else
        {
            [time drawAtPoint:CGPointMake(startingPoints[i].x - timeSize.width / 2, startingPoints[i].y - timeSize.height - 5) withAttributes:
             @{ NSFontAttributeName : [UIFont systemFontOfSize:10],
                NSForegroundColorAttributeName : COLOR_WHITECOLOR
                }];
            
            [weather drawAtPoint:CGPointMake(startingPoints[i].x - weatherSize.width / 2, startingPoints[i].y - timeSize.height - 5 - weatherSize.height) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
            
            [[NSString stringWithFormat:@"%@°",temp] drawAtPoint:CGPointMake(endingPoints[i].x - tempSize.width / 2, endingPoints[i].y + 5) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
        }
        
        
    }
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = 2;
    // 设置起点
    [path moveToPoint:endingPoints[0]];
    
    // 设置路径点
    for (int i = 1; i < 7; i++) {
        [path addLineToPoint:endingPoints[i]];
    }
    [path stroke];
    
    // 绘制坐标轴到坐标的虚线条
    const CGFloat lengths[] = {2, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextStrokeLineSegments(context, points2, sizeof(points2) / sizeof(points2[0]));
}

#pragma mark 3小时内的平均温度
- (CGFloat)averageThreeHoursTempByModel:(ThreeHoursWeatherModel *)model
{
    if (model) {
        CGFloat temp = 0.5 * (model.lowerestTemperature.floatValue + model.highestTemperature.floatValue);
        return temp;
    }
    return 0.0;
}

#pragma mark 截取时间
- (NSString *)subTimeWithDate:(NSString *)date
{
    NSRange range = [date rangeOfString:@" "];
    return [date substringWithRange:NSMakeRange(range.location + 1, 5)];
}
#pragma mark 转换时间
- (CGFloat)dateStringToDateFloat:(NSString *)dateStr
{
    CGFloat hour = [[dateStr substringToIndex:2] floatValue];
    CGFloat min = [[dateStr substringFromIndex:3] floatValue];

    return hour * 60 + min;
}
@end
