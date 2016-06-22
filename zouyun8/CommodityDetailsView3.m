//
//  CommodityDetailsView3.m
//  zouyun8
//
//  Created by 端正赵 on 16/5/27.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "CommodityDetailsView3.h"

@implementation CommodityDetailsView3

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)add:(id)sender {
    int m=[self.lable.text intValue];
     m++;
    if (m>=999) {
        m=999;
    }

    self.lable.text=[NSString stringWithFormat:@"%@",@(m)];
    
}

- (IBAction)jian:(id)sender {
    
    int m=[self.lable.text intValue];
     m--;
    
    if (m<=0) {
        m=0;
    }
    self.lable.text=[NSString stringWithFormat:@"%@",@(m)];

}



- (IBAction)nowBuyPrice:(UIButton *)sender {
    
    self.price.text=nowPrice;
    self.price.userInteractionEnabled=NO;
    
    [sender setImage:[UIImage imageNamed:@"btn_xuanze_sure"] forState:UIControlStateNormal];
    [self.yuYueBuyPrice setImage:[UIImage imageNamed:@"btn_xuanze"] forState:UIControlStateNormal];
    
}

- (IBAction)yuYueBuyPrice:(UIButton *)sender {
    self.price.text=@"请选择价格";
    self.price.userInteractionEnabled=YES;
    [sender setImage:[UIImage imageNamed:@"btn_xuanze_sure"] forState:UIControlStateNormal];
    [self.nowBuyPrice setImage:[UIImage imageNamed:@"btn_xuanze"] forState:UIControlStateNormal];
}


-(void) setProperty:(PGXiangGing *)model{

    nowPrice=model.price;
    self.price.text=nowPrice;
    self.price.userInteractionEnabled=NO;

         //self.peiSongDiZhi.placeholder=@"请输入地址";
    

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.price isExclusiveTouch]) {
        [self.price resignFirstResponder];
    }
    
    if (![self.peiSongDiZhi isExclusiveTouch]) {
        [self.peiSongDiZhi resignFirstResponder];
    }
}
@end
