//
//  Pm25View.m
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "Pm25View.h"

#import "Pm25Model.h"

@interface Pm25View ()

// 城市名称
@property (nonatomic, strong) UILabel *cityNameLabel;

// 空气质量
@property (nonatomic, strong) UILabel *airIndexesLabel;

// 质量
@property (nonatomic, strong) UILabel *qualityLabel;

// pm2.5的数值
@property (nonatomic, strong) UILabel *pm25IndexesLabel;

// pm10的数值
@property (nonatomic, strong) UILabel *pm10IndexesLabel;

// 超过城市百分比
@property (nonatomic ,strong) UILabel *cityRankLabel;

// 空气质量百分比
@property (nonatomic, assign) CGFloat qualityProportion;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIColor *viewColor;

@end

@implementation Pm25View

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addSubviews];
        _viewColor = [UIColor cyanColor];
    }
    return self;
}

#pragma mark 添加控件
- (void)addSubviews
{
    // 城市名
    _cityNameLabel = [XCView createLabelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 25) text:@"未知" font:FONT(22) textColor:COLOR_BLACKCOLOR];
    _cityNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_cityNameLabel];
    
    // 空气质量指数
    UILabel *indexesLabel = [XCView createLabelWithFrame:CGRectMake(0, _cityNameLabel.maxY + 5, SCREEN_WIDTH, 15) text:@"空气质量指数" font:FONT(12) textColor:COLOR_LIGHTGRAYCOLOR];
    indexesLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:indexesLabel];
    
    // 空气
    _airIndexesLabel = [XCView createLabelWithFrame:CGRectMake(0, 0, 200, 80) text:@"" font:FONT(80) textColor:_viewColor];
    _airIndexesLabel.textAlignment = NSTextAlignmentCenter;
    _airIndexesLabel.center = CGPointMake(SCREEN_WIDTH / 2, indexesLabel.maxY + 100);
    [self addSubview:_airIndexesLabel];
    
    // 质量
    _qualityLabel = [XCView createLabelWithFrame:CGRectMake(0, 0, 50, 25) text:@"N/A" font:FONT(25) textColor:COLOR_BLACKCOLOR];
    _qualityLabel.textAlignment = NSTextAlignmentCenter;
    _qualityLabel.adjustsFontSizeToFitWidth = YES;
    _qualityLabel.center = CGPointMake(SCREEN_WIDTH / 2, _airIndexesLabel.maxY + 10);
    [self addSubview:_qualityLabel];
    
    // 质量两边的线
    CGFloat lineWidth = 50;
    UIView *lineViewLeft = [[UIView alloc] initWithFrame:CGRectMake(_qualityLabel.x - lineWidth - 5, _qualityLabel.maxY, lineWidth, 0.5)];
    lineViewLeft.backgroundColor = COLOR_LIGHTGRAYCOLOR;
    [self addSubview:lineViewLeft];
    
    UIView *lineViewRight = [[UIView alloc] initWithFrame:CGRectMake(_qualityLabel.maxX + 5, _qualityLabel.maxY, lineWidth, 0.5)];
    lineViewRight.backgroundColor = COLOR_LIGHTGRAYCOLOR;
    [self addSubview:lineViewRight];
    
    // pm2.5 title
    CGFloat pmLabelWidth = 40;
    UILabel *pm25Label = [XCView createLabelWithFrame:CGRectMake(_qualityLabel.x - pmLabelWidth, _qualityLabel.maxY + 10, pmLabelWidth, 15) text:@"pm2.5" font:FONT(12) textColor:COLOR_LIGHTGRAYCOLOR];
    pm25Label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:pm25Label];
    
    // pm2.5的数值
    _pm25IndexesLabel = [XCView createLabelWithFrame:CGRectMake(pm25Label.x , pm25Label.maxY , pmLabelWidth, 15) text:@"N/A" font:FONT(12) textColor:COLOR_LIGHTGRAYCOLOR];
    _pm25IndexesLabel.textAlignment = NSTextAlignmentCenter;
    _pm25IndexesLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_pm25IndexesLabel];
    
    // pm10 title
    UILabel *pm10Label = [XCView createLabelWithFrame:CGRectMake(_qualityLabel.maxX , _qualityLabel.maxY + 10, pmLabelWidth, 15) text:@"pm10" font:FONT(12) textColor:COLOR_LIGHTGRAYCOLOR];
    pm10Label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:pm10Label];
    
    // pm10的数值
    _pm10IndexesLabel = [XCView createLabelWithFrame:CGRectMake(pm10Label.x , pm10Label.maxY , pmLabelWidth, 15) text:@"N/A" font:FONT(12) textColor:COLOR_LIGHTGRAYCOLOR];
    _pm10IndexesLabel.textAlignment = NSTextAlignmentCenter;
    _pm10IndexesLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_pm10IndexesLabel];
    
    // 空气级别
    _cityRankLabel = [XCView createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20) text:@"" font:FONT(18) textColor:COLOR_LIGHTGRAYCOLOR];
    _cityRankLabel.center = CGPointMake(SCREEN_WIDTH / 2, _qualityLabel.maxY + 120);
    _cityRankLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_cityRankLabel];
    
//    // 底部分割线
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.height - 1, SCREEN_WIDTH - 20, 1)];
//    bottomLine.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:bottomLine];
}

#pragma mark cityName的setting方法
- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    _cityNameLabel.text = cityName;
}

#pragma mark pm25Model的setting方法
- (void)setPm25Model:(Pm25Model *)pm25Model
{
    [self changeViewColorWithAqi:pm25Model.aqi];
    _airIndexesLabel.textColor = _viewColor;
    
    _pm25Model = pm25Model;
    
    _airIndexesLabel.text = @"0";
    _qualityLabel.text = pm25Model.quality;
    _pm25IndexesLabel.text = pm25Model.pm25;
    _pm10IndexesLabel.text = pm25Model.pm10;
    
    NSString *str = [NSString stringWithFormat:@"空气质量超过了全国 %@%% 的地区",pm25Model.cityrank];
    NSMutableAttributedString *cityRankString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:@"的"];
    [cityRankString addAttributes:@{NSFontAttributeName : FONT(20), NSForegroundColorAttributeName : _viewColor} range:NSMakeRange(9, range.location - 9)];
    _cityRankLabel.attributedText = cityRankString;
    
    [self airIndexesMoveUpwardAnimation:pm25Model.aqi.intValue];
    

}

#pragma mark - 空气质量动画
- (void)airIndexesMoveUpwardAnimation:(int)indexes
{
     //超过300相同处理，都属于重度污染
    if (indexes > 400) {
        indexes = 400;
    }
    _qualityProportion = (indexes / 400.0);
    
    // 画线
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.fillColor = [[UIColor clearColor]CGColor];
    layer.strokeColor = [_viewColor CGColor];
    layer.lineCap = @"round";
    layer.lineWidth = 5;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 2.f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:nil];
    [self.layer addSublayer:layer];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:_qualityLabel.center radius:120 startAngle:M_PI * 0.75 endAngle:M_PI * 0.75 + (M_PI + M_PI_2) * _qualityProportion clockwise:YES];
    
    layer.path = bezierPath.CGPath;
    
    
    // 数值变化
    _timer = [NSTimer scheduledTimerWithTimeInterval:animation.duration/(float)indexes target:self selector:@selector(addNumber) userInfo:nil repeats:YES];

}

#pragma mark - 数字增加
- (void)addNumber{
    
    int number = _airIndexesLabel.text.intValue;
    if (number <= _pm25Model.aqi.intValue) {
        number ++ ;
        _airIndexesLabel.text = [NSString stringWithFormat:@"%d",number];
        if (number == _pm25Model.aqi.intValue) {
            [_timer invalidate];
            _timer = nil;
        }
    }else
    {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    [COLOR_LIGHTGRAYCOLOR set];
    
    CGContextSetLineWidth(context, 5);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextAddArc(context, _qualityLabel.center.x, _qualityLabel.center.y, 120, M_PI / 4.0 * 3.0, M_PI_4, 0);
    
    CGContextStrokePath(context);

    
    NSString *str1 = @"健康";
    [str1 drawAtPoint:CGPointMake(_qualityLabel.center.x - 80, _qualityLabel.center.y + 95) withAttributes:@{NSFontAttributeName : FONT(12),NSForegroundColorAttributeName : COLOR_BLACKCOLOR}];
    
    NSString *str2 = @"污染";
    [str2 drawAtPoint:CGPointMake(_qualityLabel.center.x + 58, _qualityLabel.center.y + 95) withAttributes:@{NSFontAttributeName : FONT(12),NSForegroundColorAttributeName : COLOR_BLACKCOLOR}];
}

#pragma mark - 根据污染级别，改变主要颜色
- (void)changeViewColorWithAqi:(NSString *)aqi
{
    int aqiNumber = aqi.intValue;
    
    if (aqiNumber <= 50) {
        _viewColor = [UIColor cyanColor];
    }else if (aqiNumber <= 100){
        _viewColor = COLOR_RGB(20, 145, 253);
    }else if (aqiNumber <= 150){
        _viewColor = COLOR_RGB(72 , 177, 120);
    }else if(aqiNumber <= 200)
    {
        _viewColor = [UIColor purpleColor];
    }else if (aqiNumber <= 300){
        _viewColor = COLOR_RGB(255, 0, 0);
    }else
    {
        _viewColor = [UIColor blackColor];
    }
}

@end
