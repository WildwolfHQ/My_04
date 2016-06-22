//
//  SortModel.h
//  zouyun8
//
//  Created by 郑浩 on 16/5/30.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JSONModel.h"

@interface SortModel : JSONModel

@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * parentid;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * icon;
@end
