//
//  UIImageView+XCCreate.m
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "UIImageView+XCCreate.h"

@implementation UIImageView (XCCreate)

#pragma mark - 创建UIImageView
#pragma mark 带圆角的ImageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = cornerRadius;
    imageView.layer.masksToBounds = YES;
    
    return imageView;
}

#pragma mark 创建ImageView并确定图片
+ (instancetype)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    
    return imageView;
}

#pragma mark 带圆角的ImageView并确定图片
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius image:(UIImage *)image
{
    UIImageView *imageView = [self createImageViewWithFrame:frame cornerRadius:cornerRadius];
    imageView.image = image;

    return imageView;
}

@end
