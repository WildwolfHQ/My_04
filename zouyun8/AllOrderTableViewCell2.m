//
//  AllOrderTableViewCell2.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/16.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AllOrderTableViewCell2.h"

@implementation AllOrderTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setProperty:(Bill_View *)model{

    self.name.text=model.address_info[@"name"];
    self.iphone.text=model.address_info[@"phone"];
    self.dizhi.text=[NSString stringWithFormat:@"%@%@%@",model.address_info[@"province"],model.address_info[@"town"],model.address_info[@"detail"]];
}
@end
