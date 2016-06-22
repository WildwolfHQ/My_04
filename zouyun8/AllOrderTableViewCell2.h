//
//  AllOrderTableViewCell2.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/16.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill_View.h"
@interface AllOrderTableViewCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *iphone;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
-(void) setProperty:(Bill_View *)model;
@end
