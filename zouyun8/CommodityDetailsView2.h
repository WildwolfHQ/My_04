//
//  CommodityDetailsView2.h
//  zouyun8
//
//  Created by 端正赵 on 16/5/27.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityDetailsView2 : UIView

@property (weak, nonatomic) IBOutlet UILabel *distanceNumber;
@property (weak, nonatomic) IBOutlet UILabel *canyuNumber;
@property (weak, nonatomic) IBOutlet UILabel *timesDistance;

-(void) setProperty:(PGXiangGing *)model;
@end
