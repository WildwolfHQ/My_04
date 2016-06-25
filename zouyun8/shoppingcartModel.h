//
//  shoppingcartModel.h
//  zouyun8
//
//  Created by 郑浩 on 16/4/15.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shoppingcartModel : JSONModel

@property(nonatomic,copy)NSString * goods_id;
@property(nonatomic,copy)NSString * user_id;
@property(nonatomic,copy)NSString * times;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * total_num;
@property(nonatomic,copy)NSString * buy_num;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * thumb;
@property(nonatomic,copy)NSString * lucky_id;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * lucky_type;

@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * bid_id;
@property(nonatomic,copy)NSString * buy_user_num;
@property(nonatomic,copy)NSString * start_time;
@property(nonatomic,copy)NSString * end_time;
@property(nonatomic,copy)NSString * price_level;

@end
