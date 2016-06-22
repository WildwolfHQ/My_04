//
//  Bill_View.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/17.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"

@interface Bill_View : JSONModel

@property(nonatomic,copy)NSString * address_id;// "address_id" = 1342978481;
@property(nonatomic,copy)NSDictionary * address_info;/*"address_info" =         {
    city = "\U5317\U4eac\U5e02";
    "create_time" = "2016-06-13 15:11:19";
default = 0;
    detail = hasdbahd;
    id = 1342978481;
    name = dfsf;
    phone = 15322016395;
    province = "\U5317\U4eac";
    town = "\U4e1c\U57ce\U533a";
    "user_id" = 8049385212644378868;
};*/
                                                  
@property(nonatomic,copy)NSString * cost_score;//"cost_score" = 0;
@property(nonatomic,copy)NSString * create_time;//"create_time" = "2016-06-16 09:48:00";
@property(nonatomic,copy)NSArray * goods_info;/*"goods_info" =         (
                        {
                            "goods_id" = 4187093105;
                            id = 1007425915;
                            "is_lucky" = 1;
                            "lucky_num" = 39;
                            money = 1658;
                            name = "\U5468\U751f\U751f \U9ec4\U91d1\U8db3\U91d1 \U751c\U5fc3\U8f6c\U8fd0\U73e0";
                            num = 1;
                            price = 100;
                            thumb = "http://7xspvh.com2.z0.glb.clouddn.com/upload/2016/06/ac64ebf434.jpg";
                            type = 1;
                        }
                        );*/

@property(nonatomic,copy)NSString * ID;//id = 201606160044687208;
@property(nonatomic,copy)NSString * ip;//ip = "59.42.141.76";
@property(nonatomic,copy)NSString * money;//money = 1658;
@property(nonatomic,copy)NSString * msg;//msg = "";
@property(nonatomic,copy)NSString * pay_time;//"pay_time" = "2016-06-16 09:48:00";
@property(nonatomic,copy)NSString * pay_time_ms;//"pay_time_ms" = 555;
@property(nonatomic,copy)NSString * pay_type;//"pay_type" = 1;
@property(nonatomic,copy)NSDictionary * remark;/*remark =         {
    1 =             {
        1007425915 =                 {
            num = 1;
            price = 1658;
        };
    };
    "total_money" = 1658;
};*/
                                            
@property(nonatomic,copy)NSString * serial_num;//"serial_num" = "";
@property(nonatomic,copy)NSString * status;//status = "\U5df2\U786e\U8ba4";
@property(nonatomic,copy)NSDictionary * track_info;//"track_info" =         ();
@property(nonatomic,copy)NSString * update_time;//"update_time" = "2016-06-16 09:48:00";
@property(nonatomic,copy)NSString * user_id;//"user_id" = 8049385212644378868;
@property(nonatomic,copy)NSString * username;//username = 15322016395;

@end
