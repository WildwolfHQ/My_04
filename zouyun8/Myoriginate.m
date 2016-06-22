//
//  Myoriginate.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/18.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "Myoriginate.h"

@implementation Myoriginate

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
