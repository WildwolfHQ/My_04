//
//  view2.h
//  zouyun8
//
//  Created by 郑浩 on 16/4/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol view2Delegate <NSObject>

-(void)pushToType:(NSInteger)type;

@end

@interface view2 : UIView

@property(nonatomic,weak)id<view2Delegate> delegate;

@end
