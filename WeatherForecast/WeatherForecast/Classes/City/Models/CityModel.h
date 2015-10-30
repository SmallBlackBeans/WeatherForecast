//
//  CityModel.h
//  天气
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSString *parentname;

+ (instancetype)modelWithName:(NSString *)name parentname:(NSString *)parentname code:(NSString *)code;

@end
