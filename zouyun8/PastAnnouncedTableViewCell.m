//
//  PastAnnouncedTableViewCell.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/6.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "PastAnnouncedTableViewCell.h"

@implementation PastAnnouncedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setProperty:(History_lucky *)model{
    
    self.time.text=model.lucky_time;
    self.faqiyonghuName.text=model.username;
    self.xinyunxing.text=model.lucky_username;
    self.xinyunhao.text=model.lucky_id;
    self.canyurenci.text=model.lucky_buynum;
    

}
@end
