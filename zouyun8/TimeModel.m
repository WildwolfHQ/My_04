//
//  TimeModel.m
//  CountDownTimerForTableView
//
//  Created by FrankLiu on 15/9/10.
//  Copyright (c) 2015年 FrankLiu. All rights reserved.
//

#import "TimeModel.h"
#import "sys/utsname.h"
@implementation TimeModel

+ (instancetype)timeModelWithTime:(int)time {

    TimeModel *model = [self new];
    model.m_countNum = time;
    
    return model;
}

- (void)countDown {

    NSString *rtr=[self deviceString];
    if ([rtr hasPrefix:@"iPhone5"]||[rtr hasPrefix:@"iPhone4"]||[rtr hasPrefix:@"iPhone3"]||[rtr hasPrefix:@"iPhone2"]||[rtr hasPrefix:@"iPhone1"]) {
        _m_countNum -= 10;
        return;
    }
    if ([rtr hasPrefix:@"iPad5"]) {
         _m_countNum -= 2;
        return;
    }
    
        _m_countNum -= 1;
    
 
    
       
    
    
}

- (NSString*)currentTimeString {

    if (_m_countNum <= 0) {
      return @"00:00:00";
        
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)_m_countNum/1000/60,(long)_m_countNum/1000%60,(long)_m_countNum%1000/10];
    }
}
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
   
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    
//    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
//    
//    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    
//    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    
//    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
//    
//    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
//    
//    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
//    
//    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
//    
//    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
//    
//    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
//    
//    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
//    
//    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    
//    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    
//    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    
//    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    
//    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
//    
//    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    
//    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    
//    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    
//    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini";
//    
//    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
//    
//    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
//    if ([deviceString hasPrefix:@"iPhoneSE"])           return @"iPhone SE";
    return deviceString;
    
}

@end
