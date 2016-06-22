//
//  AllOrderTableViewCell1.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/16.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AllOrderTableViewCell1.h"

@implementation AllOrderTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setProperty:(Bill_View *)model{
    
    self.dingdanhao.text=model.ID;
    self.stata.text=model.status;
    
    
   
    
}

@end
