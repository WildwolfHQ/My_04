//
//  GetGoodsViewCell.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "GetGoodsViewCell.h"

@implementation GetGoodsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setProperty:(Mylucky *)model{
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    self.name.text=model.name;
    self.price.text=[NSString stringWithFormat:@"价格:%@",model.money];
    self.times.text=[NSString stringWithFormat:@"获得的时间:%@",model.create_time];
    self.statas.text=[NSString stringWithFormat:@"状态:%@",model.status];
    

}
@end
