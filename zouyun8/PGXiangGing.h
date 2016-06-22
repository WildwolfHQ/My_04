//
//  PGXiangGing.h
//  zouyun8
//
//  Created by 端正赵 on 16/5/30.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONAPI.h"

@interface PGXiangGing : JSONModel



@property(nonatomic,copy)NSString * goods_id; //goods_id int	必须	商品ID
@property(nonatomic,copy)NSArray  * rule; //rule	json	必须	价格阶梯 key值为人数，val为价格
@property(nonatomic,copy)NSString * bid_id; //bid_id	int	必须	拼购ID
@property(nonatomic,copy)NSString * images;//images	string	必须	商品图片，可能为多张图片 用,号分割
@property(nonatomic,copy)NSString * money;//money	int	必须	商品总价格
@property(nonatomic,copy)NSString * name;//name	string	必须	商品名称
@property(nonatomic,copy)NSString * content;//content	string	必须	商品图文详情的html格式字符串

@property(nonatomic,copy)NSString * price;//price	int	必须	商品当前价格
@property(nonatomic,copy)NSString * times;//times	int	必须	期数
@property(nonatomic,copy)NSString * start_time;//start_time	int	必须	开始时间 时间戳
@property(nonatomic,copy)NSString * end_time;//end_time	int	必须	结束时间 时间戳
@property(nonatomic,copy)NSString * buy_num;//buy_num	int	必须	购买份数
@property(nonatomic,copy)NSString * buy_user_num;//buy_user_num	int	必须	购买人数

@property(nonatomic,copy)NSString * name_description;//buy_user_num	int	必须	购买人数


@property(nonatomic,copy)NSString * price_level; //bid_id	int	必须	拼购ID
@property(nonatomic,copy)NSString * lucky_id; //bid_id	int	必须	拼购ID
@property (nonatomic, copy) NSString *type;
@property(nonatomic,copy)NSString * total_num;
@property(nonatomic,copy)NSString * thumb;        //thumb	string	必须	缩略图
@property(nonatomic,copy)NSString * user_id;      //user_id	long	必须	好友合购时为发起人的uid，网友合购此参数为0
@property(nonatomic,copy)NSString * rule_level; //bid_id	int	必须	拼购ID
@property(nonatomic,copy)NSString * select_price;
@end
