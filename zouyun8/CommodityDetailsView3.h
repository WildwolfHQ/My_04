//
//  CommodityDetailsView3.h
//  zouyun8
//
//  Created by 端正赵 on 16/5/27.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityDetailsView3 : UIView{
    NSString *nowPrice;

}

- (IBAction)add:(id)sender;
- (IBAction)jian:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lable;
- (IBAction)nowBuyPrice:(UIButton *)sender;
- (IBAction)yuYueBuyPrice:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *nowBuyPrice;
@property (weak, nonatomic) IBOutlet UIButton *yuYueBuyPrice;
@property (weak, nonatomic) IBOutlet UITextField *peiSongDiZhi;


-(void) setProperty:(PGXiangGing *)model;


@property (weak, nonatomic) IBOutlet UILabel *price;
@end
