//
//  MySaiSingleCell.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "MySaiSingleCell.h"


@implementation MySaiSingleCell

- (void)awakeFromNib {
    [super awakeFromNib];
//self.saidanBt.layer.cornerRadius=4;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setProperty:(Evaluate_list *)model{

    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"star"]];
     self.date.text=model.create_time;
     self.name.text=model.name;
    
  
        self.saidanBt.hidden=model.issaidan;
  


    
    
    
    
    
    

}


@end
