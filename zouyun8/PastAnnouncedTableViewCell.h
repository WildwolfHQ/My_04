//
//  PastAnnouncedTableViewCell.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/6.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "History_lucky.h"
@interface PastAnnouncedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *faqiyonghuName;

@property (weak, nonatomic) IBOutlet UILabel *xinyunxing;
@property (weak, nonatomic) IBOutlet UILabel *xinyunhao;
@property (weak, nonatomic) IBOutlet UILabel *canyurenci;
-(void)setProperty:(History_lucky *)model;
@end
