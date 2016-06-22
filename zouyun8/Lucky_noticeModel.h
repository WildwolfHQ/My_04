//
//  Lucky_noticeModel.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"

@interface Lucky_noticeModel : JSONModel
@property(nonatomic,copy)NSString * hg_id;//id	int	必须	合购ID
@property(nonatomic,copy)NSString * lucky_code; //lucky_code	string	必须	中奖码
@property(nonatomic,copy)NSString * lucky_ip;//lucky_ip	string	必须	中奖IP
@property(nonatomic,copy)NSString * times;//times	int	必须	合购期数
@property(nonatomic,copy)NSString * type;//type	int	必须	合购类型
@property(nonatomic,copy)NSString * goods_id;//goods_id	int	必须	商品ID
@property(nonatomic,copy)NSString * price;//price	int	必须	单价
@property(nonatomic,copy)NSString * lucky_time;//lucky_time	string	必须	开奖时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * run_time;//run_time	string	必须
@property(nonatomic,copy)NSString * lucky_userid;//lucky_userid	long	必须	中奖用户ID
@property(nonatomic,copy)NSString * lucky_username;//lucky_username	string	必须	中奖用户名称
@property(nonatomic,copy)NSString * name;//name	string	必须	商品名称
@property(nonatomic,copy)NSString * thumb;//thumb	string	必须	商品缩略图
@property(nonatomic,copy)NSString * money;//money	int	必须	商品原价
@property(nonatomic,copy)NSString * create_time;//create_time	string	必须	创建时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * lucky_num; //num	int	必须	该商品合购数量，
@property(nonatomic,copy)NSString * lucky_buynum; //num	int	必须	该商品合购数量，
@property(nonatomic,weak)NSTimer * timer; //
@end
