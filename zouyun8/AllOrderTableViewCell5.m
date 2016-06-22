//
//  AllOrderTableViewCell5.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/17.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AllOrderTableViewCell5.h"

@implementation AllOrderTableViewCell5

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setProperty:(Bill_View *)model{

    if (model.track_info!=nil) {
        
        self.kuaidi.text=model.track_info[@"name"];
        
        //model.track_info[@"url"];
        
        self.kuaididanhao.text=model.track_info[@"num"];
        
    }
    
    
}
@end
