//
//  BuyTogetherModel.m
//  zouyun8
//
//  Created by 郑浩 on 16/6/8.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "BuyTogetherModel.h"

@implementation BuyTogetherModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *key = @{@"id":@"ID"};
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:key];
    return mapper;
}

@end
