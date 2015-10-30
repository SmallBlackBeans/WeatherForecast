//
//  CityModel.m
//  天气
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

+ (instancetype)modelWithName:(NSString *)name parentname:(NSString *)parentname code:(NSString *)code
{
    CityModel *model = [[CityModel alloc] init];
    model.name = name;
    model.parentname = parentname;
    model.code = code;
    
    return model;
}

- (NSString *)description
{
    return [NSString  stringWithFormat:@"\nname:%@,parentname:%@,code:%@",_name,_parentname,_code];
}

@end
