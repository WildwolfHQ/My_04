//
//  CommodityDetailsView1.m
//  zouyun8
//
//  Created by 端正赵 on 16/5/27.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "CommodityDetailsView1.h"

@implementation CommodityDetailsView1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setProperty:(PGXiangGing *)model and:(CommodityDetailsPageViewController*)VC{

    self.name.text=model.name;
    self.yuanjia.text=[NSString stringWithFormat:@"原价: %@ 元",model.money];
    self.fuBiaoTi.text=model.name_description;
    self.commodityDetailsPageViewController=VC;
    self.pgXiangGing_model=model;
    
    
    
}
- (IBAction)tuwenxiangqingButton:(UIButton *)sender {
    
    [self kk:self.commodityDetailsPageViewController];
}
-(void)kk:(CommodityDetailsPageViewController *)commodityDetailsPageViewController{
    
    
    GraphicDetailsViewController * detail = [[GraphicDetailsViewController alloc]init];

    [detail setValue:self.pgXiangGing_model forKey:@"pgXiangGingmodel"];
    [commodityDetailsPageViewController.navigationController pushViewController:detail animated:YES];

}

@end
