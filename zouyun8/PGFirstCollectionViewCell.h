//
//  PGFirstCollectionViewCell.h
//  zouyun8
//
//  Created by 端正赵 on 16/5/26.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PGFirstCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgeView1;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfParticipants;

@property (weak, nonatomic) IBOutlet UILabel *ActivityTime;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (strong, nonatomic) PG_bid_list *model  ;


-(void)setCellWithModel;

@end
