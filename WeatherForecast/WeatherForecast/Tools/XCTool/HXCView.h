//
//  XCView.h
//  糗事百科
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCView : UIView

/**
 *  显示加载的控件
 *
 *  @param text 加载显示的文字
 *  @param view 控件需要添加的父视图
 */
+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view;

/**
 *  隐藏加载的控件
 *
 *  @param view 控件所在的父视图
 */
+ (void)hideHUDFromView:(UIView *)view;

+ (void)hideAllHUDFromView:(UIView *)view;

#pragma mark - 创建UIImageView

/**
 *  创建带圆角的UIImageView
 *
 *  @param frame        位置，大小
 *  @param cornerRadius 圆角度数
 *
 *  @return 返回UIImageView
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;

/**
 *  创建带圆角的UIImageView
 *
 *  @param frame        位置，大小
 *  @param cornerRadius 圆角度数
 *  @param image        图片
 *
 *  @return 返回UIImageView
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius image:(UIImage *)image;

#pragma mark 调用SDWebImage第三方中的方法加载图片
/**
 *  根据图片的url设置UIImageView
 *
 *  @param frame    位置，大小
 *  @param imageUrl 图片的路径
 *
 *  @return 返回UIImageView
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl;

/**
 *  根据图片的url设置UIImageView
 *
 *  @param frame    位置大小
 *  @param imageUrl 图片路径
 *  @param image    默认图片
 *
 *  @return 返回UIImageView
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)image;

#pragma mark - 创建UILabel
/**
 *  创建UILabel
 *
 *  @param frame 尺寸
 *  @param text  文字
 *  @param font  字体
 *
 *  @return 返回UILabel
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font;
/**
 *  创建UILabel
 *
 *  @param frame 尺寸
 *  @param text  文字
 *  @param font  字体
 *  @param color 字体颜色
 *
 *  @return 返回UILabel
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;

/**
 *  创建UIButton
 *
 *  @param frame  位置大小
 *  @param title  标题
 *  @param target 事件执行的对象
 *  @param action 事件
 *  @param color  背景颜色
 *
 *  @return 按钮实例
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action backgroundColor:(UIColor *)color;

+ (void)showAlertViewWithMessage:(NSString *)message target:(id)target;
@end
