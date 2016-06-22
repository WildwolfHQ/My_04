//
//  AnnounceTableViewCell4.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AnnounceTableViewCell4.h"

@implementation AnnounceTableViewCell4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setProperty:(Lucky_noticeModel *)model{
    
    self.name.text=model.name;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    
    
    
}

@end
