//
//  HG_XiangGing.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/2.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"

@interface HG_XiangGing : JSONModel



@property(nonatomic,copy)NSString * goods_id; //	int	必须	商品ID
@property(nonatomic,copy)NSString * lucky_id; // lucky_id	int	必须	合购id
@property(nonatomic,copy)NSString * user_id; // user_id	long	必须	用户ID
@property(nonatomic,copy)NSString * images; //images	string	必须	商品图片，可能为多张图片 用,号分割
@property(nonatomic,copy)NSString * money; // money	int	必须	商品总价格
@property(nonatomic,copy)NSString * name; // name	string	必须	商品名称
@property(nonatomic,copy)NSString * content; // content	string	必须	商品图文详情的html格式字符串
@property(nonatomic,copy)NSString * price; // price	int	必须	商品单价
@property(nonatomic,copy)NSString * times; //times	int	必须	期数
@property(nonatomic,copy)NSString * total_num; // total_num	int	必须	总份数
@property(nonatomic,copy)NSString * buy_num; // buy_num	int	必须	已购买份数
@property(nonatomic,copy)NSString * left_num; // left_num	int	必须	剩余份数
@property(nonatomic,copy)NSString * start_time; // start_time	string	必须	创建时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * lucky_time; // lucky_time	string	必须	开奖时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * lucky_userid; // lucky_userid	long	必须	中奖用户ID
@property(nonatomic,copy)NSString * lucky_username; // lucky_username	string	必须	中奖用户名称
@property(nonatomic,copy)NSString * lucky_code; // lucky_code	string	必须	中奖码
@property(nonatomic,copy)NSString * lucky_buynum; // lucky_buynum	int	必须	中奖人购买份数
@property(nonatomic,copy)NSString * num; //num	int	必须	该用户合购数量，未购买返回0
@property(nonatomic,copy)NSArray *codes; //codes	json	必须	购买的合购码
@property(nonatomic,copy)NSString * lucky_num; //num	int	必须	该商品合购数量，
@property(nonatomic,copy)NSString * type; //判断是合购列表的详情页还是揭晓列表的详情页
@property(nonatomic,copy)NSArray * buy_info; //购买记录数组
@property(nonatomic,copy)NSString * thumb;        //thumb	string	必须	缩略图
@property(nonatomic,copy)NSString * need_buy_num;        //用户需要购买的份数

@end
