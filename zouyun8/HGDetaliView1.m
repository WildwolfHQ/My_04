//
//  HGDetaliView1.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/2.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "HGDetaliView1.h"

@implementation HGDetaliView1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setProperty:(HG_XiangGing *)model{
    self.name.text=model.name;
    self.renci.text=[NSString stringWithFormat:@"总需：%@人次",model.total_num];;
    self.surplusPersonTime.text=model.left_num;
    self.price.text=[NSString stringWithFormat:@"价格：%@元",model.price];
    
    self.stateAndTime.text=[self timeIntervalStr:model.start_time];
    self.qishu.text=[NSString stringWithFormat:@"第%@期",model.times];
    NSString *str;
    if (model.num.integerValue==0) {
        str=@"你尚未参与本期合购";
        
    }else{
    
        str=[NSString stringWithFormat:@"你已购买了%@份",model.num];
    }
      self.isCanjiabenqiHG.text=str;
    
    
    
    

}

//
- (NSString *)timeIntervalStr:(NSString *)timeIntervalStr
{
    
    
    
     NSDate *theDate=[NSDate dateWithTimeIntervalSince1970:timeIntervalStr.doubleValue];
     NSString *timeString=[NSString stringWithFormat:@"本期于%@开始",[self dateToString:theDate]];

    
    
    return timeString;
}



// 世界标准时间UTC /GMT  转为  当前系统时区对应的时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

//NSDate 2 NSString
- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

@end
