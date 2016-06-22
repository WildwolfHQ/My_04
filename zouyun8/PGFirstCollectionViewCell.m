//
//  PGFirstCollectionViewCell.m
//  zouyun8
//
//  Created by 端正赵 on 16/5/26.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "PGFirstCollectionViewCell.h"

@implementation PGFirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellWithModel
{
     self.productName.text = self.model.name;
    
     [self.imgeView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/160/h/121/q/85",self.model.thumb]] placeholderImage:nil];
    self.nowPrice.text = self.model.price;
    self.originalPrice.text= [NSString stringWithFormat:@"¥ %@",self.model.price];
    self.NumberOfParticipants.text=self.model.buy_user_num;

        

    
    
    NSString *  m= [self intervalSinceNow:self.model.end_time andStarTimes:self.model.start_time];
    self.ActivityTime.text=m;
    if ([m isEqualToString:@"已结束"]) {
        [self.imageView2 setImage:[UIImage imageNamed:@"btn_pingou"]];
      
        self.ActivityTime.textColor=[UIColor lightTextColor];
        
    }else{
        [self.imageView2 setImage:[UIImage imageNamed:@"btn_pingou_sure"]];
         self.ActivityTime.textColor=[UIColor redColor];
    
    }
    
    NSLog(@"%@",m);
//    self.buyLabel.text = self.model.buy_num;
}
//某一时间距离现在的距离
- (NSString *)intervalSinceNow: (NSString *) endTimes andStarTimes:(NSString *)starTimes
{
    
    
    

    //NSDateFormatter *date=[[NSDateFormatter alloc] init];
    //[date setDateFormat:@"yyyy MM dd HH:mm:ss"];
    //NSDate *d=[date dateFromString:theDate];
    
    //NSDate *d = [NSDate dateWithTimeIntervalSince1970:theDate.intValue];
    
    NSTimeInterval endTimes1=endTimes.doubleValue;
    NSTimeInterval starTimes1=starTimes.doubleValue;
    
    
    NSDate* dat = [NSDate date];
    
    dat=[self getNowDateFromatAnDate:dat];
    
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    
    NSString *timeString=@"";
    
    NSTimeInterval cha=endTimes1-now;
    NSTimeInterval cha1=starTimes1-now;
    
    long lTime1 = (long)cha1;
    long lTime = (long)cha;
    
    
    
    
     if (lTime1>0) {
         timeString=@"还未开始";
         //long iSeconds = lTime % 60;
         long iMinutes = (lTime1 / 60) % 60;
         long iHours = (lTime1/3600)%24;
         long iDays = lTime1/60/60/24;
         //long iMonth = lTime/60/60/24/12;
         //long iYears = lTime/60/60/24/384;
         
         // NSLog(@"相差%ld年%ld月%ld日%ld时%ld分%ld秒 ", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
         if (iDays!=0) {
             timeString=[NSString stringWithFormat:@"%ld日%ld时%ld分后开始", iDays,iHours,iMinutes];
         }else if(iHours!=0){
             
             timeString=[NSString stringWithFormat:@"%ld时%ld分后开始",iHours,iMinutes];
         }else if(iMinutes!=0){
             
             timeString=[NSString stringWithFormat:@"%ld分后开始",iMinutes];
         }

     }else{
        //@"正在进行";
        
         if (lTime<=0) {
           timeString=@"已结束";
         }else{
    
         //long iSeconds = lTime % 60;
         long iMinutes = (lTime / 60) % 60;
         long iHours = (lTime/3600)%24;
         long iDays = lTime/60/60/24;
         //long iMonth = lTime/60/60/24/12;
         //long iYears = lTime/60/60/24/384;
    
         // NSLog(@"相差%ld年%ld月%ld日%ld时%ld分%ld秒 ", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
          if (iDays!=0) {
              timeString=[NSString stringWithFormat:@"%ld日%ld时%ld分后结束", iDays,iHours,iMinutes];
          }else if(iHours!=0){
        
              timeString=[NSString stringWithFormat:@"%ld时%ld分后结束",iHours,iMinutes];
          }else if(iMinutes!=0){
            
              timeString=[NSString stringWithFormat:@"%ld分后结束",iMinutes];
          }
        
       
        }
        
     }
    

  
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


//几个转换函数
//NSString 2 NSDate
- (NSDate *)stringToDate:(NSString *)strdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *retdate = [dateFormatter dateFromString:strdate];
  
    return retdate;
}

//NSDate 2 NSString
- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];

    return strDate;
}




//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
-(NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
  
    return dateString;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
-(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
 
    return dateString;
}

@end
