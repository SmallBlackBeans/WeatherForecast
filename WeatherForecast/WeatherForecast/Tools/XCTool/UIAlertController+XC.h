//
//  UIAlertController+XC.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertControlerBlock)(void);

@interface UIAlertController (XC)

/**
 *  显示提示信息
 *
 *  @param message 需要显示的信息
 *  @param target  目标
 */
+ (void)showAlertViewWithMessage:(NSString *)message target:(id)target;

/**
 *  提示
 *
 *  @param message 提示信息
 *  @param target  目标
 *  @param handler 点击确定后的事件
 */
+ (void)showAlertViewWithMessage:(NSString *)message target:(id)target handler:(AlertControlerBlock)handler;

@end
