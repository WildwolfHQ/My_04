//
//  AnnounceTableViewCell2.m
//  zouyun8
//
//  Created by 郑浩 on 16/4/10.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AnnounceTableViewCell2.h"
#import "MZTimerLabel.h"
@interface AnnounceTableViewCell2()<MZTimerLabelDelegate>
{
    UILabel *timer_show;//倒计时label
}
@end

@implementation AnnounceTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
