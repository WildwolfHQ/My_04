//
//  SortModel.m
//  zouyun8
//
//  Created by 郑浩 on 16/5/30.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "SortModel.h"

@implementation SortModel

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
