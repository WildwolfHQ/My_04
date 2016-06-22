//
//  HGDetaliView2.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/6.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "HGDetaliView2.h"

@implementation HGDetaliView2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setProperty:(HG_XiangGing *)model{
    self.name.text=model.name;
    self.renci.text=[NSString stringWithFormat:@"总需：%@人次",model.total_num];;
    
    self.price.text=[NSString stringWithFormat:@"价格：%@元",model.price];
    
   
    
    
    
    
    
}


@end
