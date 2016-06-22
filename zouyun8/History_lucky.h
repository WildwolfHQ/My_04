//
//  History_lucky.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/7.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"

@interface History_lucky : JSONModel

@property(nonatomic,copy)NSString * lucky_id;//lucky_id	int	必须	合购ID
@property(nonatomic,copy)NSString * lucky_code;//lucky_code	string	必须	中奖码
@property(nonatomic,copy)NSString * lucky_ip;//lucky_ip	string	必须	中奖IP
@property(nonatomic,copy)NSString * goods_id;//goods_id	int	必须	商品ID
@property(nonatomic,copy)NSString * lucky_time;//lucky_time	string	必须	开奖时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * lucky_userid;//lucky_userid	long	必须	中奖用户ID
@property(nonatomic,copy)NSString * lucky_username;//lucky_username	string	必须	中奖用户名称
@property(nonatomic,copy)NSString * name;//name	string	必须	商品名称
@property(nonatomic,copy)NSString * thumb;//thumb	string	必须	商品缩略图
@property(nonatomic,copy)NSString * money;//money	int	必须	商品原价
@property(nonatomic,copy)NSString * create_time;//create_time	string	必须	创建时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * username;//username	string	必须	发起人用户名
@property(nonatomic,copy)NSString * user_id;//user_id	long	必须	发起人用户ID
@property(nonatomic,copy)NSString * lucky_buynum;//user_id	long	必须	发起人用户ID

@end
