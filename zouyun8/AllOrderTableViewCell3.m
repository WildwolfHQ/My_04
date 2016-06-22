//
//  AllOrderTableViewCell3.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/16.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AllOrderTableViewCell3.h"

@implementation AllOrderTableViewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setProperty:(NSDictionary *)model{

    
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model[@"thumb"]]];
    self.name.text=model[@"name"];
    self.price.text=[NSString stringWithFormat:@"¥%@",model[@"money"]];
    self.number.text=[NSString stringWithFormat:@"x%@",model[@"num"]];
}
@end
