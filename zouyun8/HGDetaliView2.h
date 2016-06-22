//
//  HGDetaliView2.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/6.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGDetaliView2 : UIView
-(void)setProperty:(HG_XiangGing *)model;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *renci;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *tuwenxiangqing;
@property (weak, nonatomic) IBOutlet UIButton *wangqijiexiao;
@end
