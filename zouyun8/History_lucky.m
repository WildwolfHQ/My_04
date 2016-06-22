//
//  History_lucky.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/7.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "History_lucky.h"

@implementation History_lucky
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *key = @{@"id":@"lucky_id"};
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:key];
    return mapper;
}
@end
