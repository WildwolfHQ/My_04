//
//  Lucky_noticeModel.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "Lucky_noticeModel.h"

@implementation Lucky_noticeModel
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *key = @{@"id":@"hg_id"};
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:key];
    return mapper;
}
@end
