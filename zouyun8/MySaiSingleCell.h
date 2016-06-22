//
//  MySaiSingleCell.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Evaluate_list.h"
@interface MySaiSingleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *saidanBt;




-(void) setProperty:(Evaluate_list *)model;

@end
