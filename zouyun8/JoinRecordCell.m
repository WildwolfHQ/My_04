//
//  JoinRecordCell.m
//  zouyun8
//
//  Created by 郑浩 on 16/5/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JoinRecordCell.h"

@implementation JoinRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setProperty:(NSDictionary *)dic{
   
    self.name.text=dic[@"username"];
    self.number.text=dic[@"num"];
    self.date.text=dic[@"create_time"];


}

@end
