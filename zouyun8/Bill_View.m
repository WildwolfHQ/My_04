//
//  Bill_View.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/17.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "Bill_View.h"

@implementation Bill_View

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
