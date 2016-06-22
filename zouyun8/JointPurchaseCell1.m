//
//  JointPurchaseCell1.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/18.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JointPurchaseCell1.h"

@implementation JointPurchaseCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setProperty:(Myoriginate *)model{
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.name.text=model.name;
    self.zhongfenshu.text=[NSString stringWithFormat:@"总份数: %@",model.total_num];
    self.zhongjiazhi.text=[NSString stringWithFormat:@"总价值: %@",model.money];
    
    
    
    self.shenyushu.text=[NSString stringWithFormat:@"剩余: %@",model.left_num];
    self.danjia.text=[NSString stringWithFormat:@"单价: %@",model.price];
    if (model.buy_type.integerValue == 11) {
        self.statas.text=@"已失效";
        self.faqishijian.text=[NSString stringWithFormat:@"发起时间: %@",model.create_time];

    } else if (model.lucky_userid.integerValue!= 0) {
         self.statas.text=@"已结束";
        self.faqishijian.text=[NSString stringWithFormat:@"幸运星: %@",model.lucky_username];
        self.huojiangshijian.text=[NSString stringWithFormat:@"获奖时间: %@",model.lucky_time];
    } else if (model.lucky_userid.integerValue == 0
               && model.buy_type.integerValue != 11) {
         self.statas.text=@"进行中";
        self.faqishijian.text=[NSString stringWithFormat:@"发起时间: %@",model.create_time];
    }
}


@end
