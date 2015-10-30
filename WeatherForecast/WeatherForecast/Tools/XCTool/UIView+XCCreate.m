//
//  UIView+XCCreate.m
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "UIView+XCCreate.h"

@implementation UIView (XCCreate)

/**
 *  创建UIView并添加颜色
 *
 *  @param frame 位置大小
 *  @param color 颜色
 *
 *  @return UIView的实例
 */
+ (instancetype)createViewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    return view;
}

/**
 *  创建一条宽度为1的横线
 *
 *  @param origin    位置
 *  @param lineLength 长度
 *  @param color     颜色
 *
 *  @return UIView
 */
+ (instancetype)createHorizontalLineWithOrigin:(CGPoint)origin lineLength:(CGFloat)lineLength lineColor:(UIColor *)color
{
    CGRect frame = CGRectMake(origin.x, origin.y, lineLength, 1);
    
    return [self createViewWithFrame:frame color:color];
    
}

/**
 *  创建一条宽度为1的横线并添加到他的父视图上
 *
 *  @param origin     位置
 *  @param lineLength 长度
 *  @param color      颜色
 *  @param superView  添加到的父视图
 */
+ (void)createHorizontalLineWithOrigin:(CGPoint)origin lineLength:(CGFloat)lineLength lineColor:(UIColor *)color toView:(UIView *)superView
{
    UIView *view = [self createHorizontalLineWithOrigin:origin lineLength:lineLength lineColor:color];
    
    [superView addSubview:view];
}

/**
 *  创建一条宽度为1的竖线
 *
 *  @param origin     位置
 *  @param lineLength 长度
 *  @param color      颜色
 *
 *  @return UIView
 */
+ (instancetype)createVerticalLineWithOrigin:(CGPoint)origin lineLength:(CGFloat)lineLength lineColor:(UIColor *)color 
{
    CGRect frame = CGRectMake(origin.x, origin.y, 1, lineLength);
    
    return [self createViewWithFrame:frame color:color];
}

/**
 *  创建一条宽度为1的横线并添加到他的父视图上
 *
 *  @param origin     位置
 *  @param lineLength 长度
 *  @param color      颜色
 *  @param superView  添加到的父视图
 */
+ (void)createVerticalLineWithOrigin:(CGPoint)origin lineLength:(CGFloat)lineLength lineColor:(UIColor *)color toView:(UIView *)superView
{
    UIView *view = [self createVerticalLineWithOrigin:origin lineLength:lineLength lineColor:color];
    
    [superView addSubview:view];
}
@end
