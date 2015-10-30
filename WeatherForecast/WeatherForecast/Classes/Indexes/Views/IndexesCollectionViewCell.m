//
//  IndexesCollectionViewCell.m
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "IndexesCollectionViewCell.h"

@implementation IndexesCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _title.adjustsFontSizeToFitWidth = YES;
    _level.titleLabel.numberOfLines = 0;
    _level.layer.borderWidth = 1;
    _level.layer.borderColor = COLOR_LIGHTGRAYCOLOR.CGColor;
}

+ (NSString *)identifier
{
    return @"indexesCell";
}
- (IBAction)cellClick:(UIButton *)sender {
    
    if (_cellBlock) {
        _cellBlock(_indexPath);
    }
    
}

@end
