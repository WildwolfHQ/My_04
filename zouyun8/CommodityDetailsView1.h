//
//  CommodityDetailsView1.h
//  zouyun8
//
//  Created by 端正赵 on 16/5/27.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityDetailsPageViewController.h"
@interface CommodityDetailsView1 : UIView
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *yuanjia;
-(void) setProperty:(PGXiangGing *)model and:(CommodityDetailsPageViewController*)VC;
@property (weak, nonatomic) IBOutlet UILabel *fuBiaoTi;
- (IBAction)tuwenxiangqingButton:(UIButton *)sender;
-(void)kk:(CommodityDetailsPageViewController *)commodityDetailsPageViewController;
@property (strong ,nonatomic) CommodityDetailsPageViewController *commodityDetailsPageViewController;
@property (strong ,nonatomic) PGXiangGing *pgXiangGing_model;
@end
