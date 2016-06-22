#import "AllOrderModel.h"

@implementation AllOrderModel
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
