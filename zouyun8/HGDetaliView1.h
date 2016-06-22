//
//  HGDetaliView1.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/2.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HG_XiangGing.h"
@interface HGDetaliView1 : UIView
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *renci;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *surplusPersonTime;
@property (weak, nonatomic) IBOutlet UILabel *isCanjiabenqiHG;
@property (weak, nonatomic) IBOutlet UILabel *stateAndTime;

-(void)setProperty:(HG_XiangGing *)model;
@property (weak, nonatomic) IBOutlet UIButton *hegouma;

@property (weak, nonatomic) IBOutlet UILabel *qishu;
@property (weak, nonatomic) IBOutlet UIProgressView *jindutiao;
@property (weak, nonatomic) IBOutlet UIButton *tuwenxiangqing;
@property (weak, nonatomic) IBOutlet UIButton *wangqijiexiao;
@end
