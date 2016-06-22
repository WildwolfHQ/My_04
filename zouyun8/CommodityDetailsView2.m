//
//  CommodityDetailsView2.m
//  zouyun8
//
//  Created by 端正赵 on 16/5/27.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "CommodityDetailsView2.h"

@implementation CommodityDetailsView2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setProperty:(PGXiangGing *)model{
    
   // int nowprice=model.price.intValue;

    
    int n = 0;//降价需要的人数
    NSArray*array=model.rule;
    
    
    for (int i=0;i<array.count;i++) {
         NSString *str=array[i];
        
   
     
        
        if ([ [str componentsSeparatedByString:@"|"][1] isEqualToString:model.price ] ) {
            
             //NSString *number=[str componentsSeparatedByString:@"|"][0];
            @try {
                if (array[i+1]) {
                    NSString *str1=array[i+1];
                    NSString *number1=[str1 componentsSeparatedByString:@"|"][0];
                    n=number1.intValue;
                }

            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
            
            
            
            
        }
        
        
        
    }
    
    
    int k=n-model.buy_user_num.intValue;
    
    
    self.distanceNumber.text=[NSString stringWithFormat:@"%d",k];
    
    self.canyuNumber.text=[NSString stringWithFormat:@" 已参与%@人",model.buy_user_num];
    self.timesDistance.text=[self intervalSinceNow:model.end_time andStarTimes:model.start_time];

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

@end
