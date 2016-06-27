//
//  JointPurchaseCell1.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/18.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Myoriginate.h"
@interface JointPurchaseCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *zhongfenshu;
@property (weak, nonatomic) IBOutlet UILabel *zhongjiazhi;
@property (weak, nonatomic) IBOutlet UILabel *faqishijian;
@property (weak, nonatomic) IBOutlet UIButton *dianjigongkai;
@property (weak, nonatomic) IBOutlet UILabel *huojiangshijian;
@property (weak, nonatomic) IBOutlet UILabel *shenyushu;
@property (weak, nonatomic) IBOutlet UILabel *danjia;
@property (weak, nonatomic) IBOutlet UILabel *statas;
-(void) setProperty:(Myoriginate *)model;

@property (weak, nonatomic) IBOutlet UILabel *hegouID;

@end
