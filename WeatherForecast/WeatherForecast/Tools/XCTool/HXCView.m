//
//  XCView.m
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "XCView.h"

@implementation XCView

/**
 *  显示加载的控件
 *
 *  @param text 加载显示的文字
 *  @param view 控件需要添加的父视图
 */
+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
}

/**
 *  隐藏加载的控件
 *
 *  @param view 控件所在的父视图
 */
+ (void)hideHUDFromView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)hideAllHUDFromView:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

#pragma mark - 创建UIImageView

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = cornerRadius;
    imageView.layer.masksToBounds = YES;
    
    return imageView;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius image:(UIImage *)image
{
    UIImageView *imageView = [self createImageViewWithFrame:frame cornerRadius:cornerRadius];
    imageView.image = image;
    
    return imageView;
}

/**
 *  根据图片的url设置UIImageView
 *
 *  @param frame    位置，大小
 *  @param imageUrl 图片的路径
 *
 *  @return 返回UIImageView
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    return imageView;
}

/**
 *  根据图片的url设置UIImageView
 *
 *  @param frame    位置大小
 *  @param imageUrl 图片路径
 *  @param image    默认图片
 *
 *  @return 返回UIImageView
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl placeholderImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:image];
    
    return imageView;
}

#pragma mark - 创建UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    return label;
}
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [self createLabelWithFrame:frame text:text font:font];
    label.textColor = color;
    return label;
}

#pragma mark - 创建UIButton
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
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action backgroundColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = color;
    [btn setTitleColor:COLOR_BLACKCOLOR forState:UIControlStateNormal];
    
    return btn;
}

+ (void)showAlertViewWithMessage:(NSString *)message target:(id)target{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    [target presentViewController:alertController animated:YES completion:nil];
}
@end
