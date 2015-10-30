//
//  IndexesModel.h
//  WeatherForecast
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 数据样式
 
     "abbreviation": "zs", (缩写)
     "alias": "",
     "content": "温度不高，其他各项气象条件适宜，中暑机率极低。",  （内容）
     "level": "无",
     "name": "中暑指数"
 */

@interface IndexesModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *level;

@end
