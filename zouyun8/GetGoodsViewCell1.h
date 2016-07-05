//
//  GetGoodsViewCell1.h
//  zouyun8
//
//  Created by 端正赵 on 16/7/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mylucky.h"
#import "GetGoodsViewController.h"
@interface GetGoodsViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *statas;
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (weak, nonatomic) IBOutlet UILabel *wuliuname;
@property (weak, nonatomic) IBOutlet UILabel *wuliudanhao;
-(void) setProperty:(Mylucky *)model and:(GetGoodsViewController *)getGoodsViewController ;
- (IBAction)querenshouhuoBt:(UIButton *)sender;
- (IBAction)chakanwuliuBt:(UIButton *)sender;
@property (strong,nonatomic) Mylucky *model;
@property (strong,nonatomic) GetGoodsViewController *getGoodsViewController;
@property (weak, nonatomic) IBOutlet UIButton *querenshouhuoBt;
@property (weak, nonatomic) IBOutlet UIButton *chakanwuliuBt;
@property (strong,nonatomic) NSArray *dataArray;
@property (strong,nonatomic) NSIndexPath *indexPath;
@end
