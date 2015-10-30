//
//  IndexesCollectionViewCell.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *level;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) void(^cellBlock)(NSIndexPath *indexPath);

+ (NSString *)identifier;

@end
