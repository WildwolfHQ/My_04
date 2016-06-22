//
//  AddrDataModel.h
//  ZKAddrList
//
//  Created by 陈婷 on 16/4/13.
//  Copyright © 2016年 zk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddrDataModel : JSONModel
@property (nonatomic,copy) NSString* ID;
@property (nonatomic,copy) NSString* user_id;
@property (nonatomic,copy) NSString* province;
@property (nonatomic,copy) NSString* city;
@property (nonatomic,copy) NSString* town;
@property (nonatomic,copy) NSString* detail;
@property (nonatomic,copy) NSString* phone;
@property (nonatomic,copy) NSString* name;

@end
