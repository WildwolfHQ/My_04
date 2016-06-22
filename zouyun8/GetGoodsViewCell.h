//
//  GetGoodsViewCell.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mylucky.h"
@interface GetGoodsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *statas;
@property (weak, nonatomic) IBOutlet UILabel *times;
-(void) setProperty:(Mylucky *)model;
@end
