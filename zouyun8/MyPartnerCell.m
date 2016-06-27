//
//  MyPartnerCell.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "MyPartnerCell.h"

@implementation MyPartnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setProperty:(Junior *)model{
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"star"]];
    self.name.text=model.username;
    self.time.text=model.reg_time;
    self.fanli.text=[NSString stringWithFormat:@"已返利%@元",model.cash];
    


}

@end
