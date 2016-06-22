#import "JSONModel.h"

@interface AllOrderModel : JSONModel

@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSMutableArray * remark;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * pay_time;
@property(nonatomic,copy)NSString * pay_time_ms;
@property(nonatomic,copy)NSString * user_id;
@property(nonatomic,copy)NSString * username;

@end
