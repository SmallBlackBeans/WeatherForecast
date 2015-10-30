//
//  CityManageViewController.h
//  天气
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityManageViewControllerDelegate <NSObject>

- (void)cityManagerVCPopToLocationCity;

- (void)changeCurrentChooseCity:(NSInteger)cityIndex;

@end

@interface CityManageViewController : UIViewController

@property (nonatomic, weak) id<CityManageViewControllerDelegate> delegate;

@end
