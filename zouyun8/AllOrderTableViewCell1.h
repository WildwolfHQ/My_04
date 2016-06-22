//
//  AllOrderTableViewCell1.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/16.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill_View.h"
@interface AllOrderTableViewCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dingdanhao;
@property (weak, nonatomic) IBOutlet UILabel *stata;
-(void) setProperty:(Bill_View *)model;
@end
