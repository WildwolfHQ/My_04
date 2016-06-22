//
//  AnnounceTableViewCell3.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnounceTableViewCell3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *xinyun_nike;
@property (weak, nonatomic) IBOutlet UILabel *xiaoliang;
@property (weak, nonatomic) IBOutlet UILabel *xinyunID;
@property (weak, nonatomic) IBOutlet UILabel *jiexiaotime;
-(void) setProperty:(Lucky_noticeModel *)model;
@end
