//
//  headerView.h
//  zouyun8
//
//  Created by 郑浩 on 16/4/8.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol headerViewDelegate <NSObject>

-(void)pushToSort;

@end

@interface headerView : UIView

@property(nonatomic,weak)id<headerViewDelegate> delegate;

@end
