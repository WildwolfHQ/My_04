//
//  AnnounceTableViewCell3.m
//  zouyun8


//
//  Created by 端正赵 on 16/6/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AnnounceTableViewCell3.h"

@implementation AnnounceTableViewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setProperty:(Lucky_noticeModel *)model{
    
    self.name.text=model.name;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.xinyun_nike.text=model.lucky_username;
    self.xinyunID.text=model.lucky_code;
    self.xiaoliang.text=model.lucky_buynum;
    self.jiexiaotime.text=model.lucky_time;
    
    
    UIFont *font;
    if (iPhone5) {
        
        if (self.jiexiaotime.text.length>5) {
           font= [UIFont systemFontOfSize:10];
        }else{
         
            font= [UIFont systemFontOfSize:12];
        }
       
       
    }
    else if (iPhone6) {
       
         font= [UIFont systemFontOfSize:12];
    }
    else if(iPhone6_plus)
    {
      
        
         font= [UIFont systemFontOfSize:12];
    }
    else if(iPhone4)
    {
     //4
        
        if (self.jiexiaotime.text.length>5) {
            font= [UIFont systemFontOfSize:10];
        }else{
            
            font= [UIFont systemFontOfSize:12];
        }

    }

    self.jiexiaotime.font=font;
    CGSize size = [self.jiexiaotime.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.jiexiaotime.font,NSFontAttributeName, nil]];
    // 名字的H
    CGFloat nameH = size.height;
    // 名字的W
    CGFloat nameW = size.width;
    
    
    self.jiexiaotime.frame =CGRectMake(self.jiexiaotime.frame.origin.x, self.jiexiaotime.frame.origin.y,nameW,nameH);

    
    
}
@end
