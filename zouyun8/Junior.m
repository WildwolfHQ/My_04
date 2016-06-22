//
//  Junior.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "Junior.h"

@implementation Junior
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
