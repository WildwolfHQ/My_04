//
//  PG_bid_list.h
//  zouyun8
//
//  Created by 端正赵 on 16/5/28.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"
/**
 拼购首页列表数据
 
 */
@interface PG_bid_list : JSONModel

@property(nonatomic,copy)NSString * goods_id;     //id	int	必须	商品ID
@property(nonatomic,copy)NSString * bid_id;       //bid_id	int	必须	拼购ID
@property(nonatomic,copy)NSString * user_id;      //user_id	long	必须	好友合购时为发起人的uid，网友合购此参数为0
@property(nonatomic,copy)NSString * times;        //times	int	必须	期数
@property(nonatomic,copy)NSString * price;        //price	int	必须	单价
@property(nonatomic,copy)NSString * buy_user_num; //buy_user_num	int	必须	拼购人数
@property(nonatomic,copy)NSString * buy_num;      //buy_num	int	必须	合购总份数
@property(nonatomic,copy)NSString * start_time;   //start_time	int	必须	开始时间戳
@property(nonatomic,copy)NSString * end_time;     //end_time	int	必须	结束时间戳
@property(nonatomic,copy)NSString * money;        //money	int	必须	商品总价格
@property(nonatomic,copy)NSString * name;         //name	string	必须	商品名称
@property(nonatomic,copy)NSString * thumb;        //thumb	string	必须	缩略图
@property(nonatomic,copy)NSString * tishi;        //thumb	string	必须	缩略图


@end
