//
//  Mylucky.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"

@interface Mylucky : JSONModel
@property(nonatomic,copy)NSString * ID;//id	int	必须	合购ID
@property(nonatomic,copy)NSString * user_id;//user_id	long	必须	发起合购的用户ID
@property(nonatomic,copy)NSString * goods_id;//goods_id	int	必须	商品ID
@property(nonatomic,copy)NSString * bid_id;//bid_id	int	必须	拼购ID
@property(nonatomic,copy)NSString * lucky_id;//lucky_id	int	必须	合购ID
@property(nonatomic,copy)NSString * money;//money	int	必须	总价
@property(nonatomic,copy)NSString * create_time;//create_time	string	必须	获得时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * name;//name	string	必须	商品名称
@property(nonatomic,copy)NSString * thumb;//thumb	string	必须	商品缩略图
@property(nonatomic,copy)NSString * status;//status
@end
