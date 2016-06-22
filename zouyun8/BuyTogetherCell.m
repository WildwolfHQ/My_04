//
//  BuyTogetherCell.m
//  zouyun8
//
//  Created by 郑浩 on 16/6/8.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "BuyTogetherCell.h"

@implementation BuyTogetherCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setCellWithModel:(BuyTogetherModel *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.title.text = model.name;
    self.name.text = model.username;
    self.price.text = model.price;
    self.buy.text = model.buy_num;
    self.last.text = model.left_num;
}
- (IBAction)立即购买:(id)sender {
    NSDictionary * dic;
    dic= @{@"id":self.model.ID,@"type":@"1",@"num":@"1"};
    
    if([self.delegate respondsToSelector:@selector(directToPay:)])
    {
        [self.delegate directToPay:dic];
    }
}

@end
