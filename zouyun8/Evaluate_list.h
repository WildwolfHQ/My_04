//
//  ERvaluate_list.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"

@interface Evaluate_list : JSONModel
@property(nonatomic,copy)NSString * ID;//id	int	必须	晒单ID
@property(nonatomic,copy)NSString * lucky_id;//lucky_id	int	必须	合购ID
@property(nonatomic,copy)NSString * bid_id;//bid_id	int	必须	拼购ID
@property(nonatomic,copy)NSString * user_id;//user_id	long	必须	用户ID
@property(nonatomic,copy)NSString * create_time;//create_time	string	必须	创建时间 yyy-mm-dd HH:ii:ss
@property(nonatomic,copy)NSString * money;//money	int	必须	商品总价格
@property(nonatomic,copy)NSString * name;//name	string	必须	商品名称
@property(nonatomic,copy)NSString * thumb;//thumb	string	必须	缩略图
@property(assign,atomic)BOOL issaidan;//

@end
