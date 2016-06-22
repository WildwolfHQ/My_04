//
//  AllOrderTableViewCell5.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/17.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill_View.h"
@interface AllOrderTableViewCell5 : UITableViewCell
-(void) setProperty:(Bill_View *)model;
@property (weak, nonatomic) IBOutlet UILabel *kuaidi;
@property (weak, nonatomic) IBOutlet UIButton *chakanwuliuBt;
@property (weak, nonatomic) IBOutlet UILabel *kuaididanhao;
@end
