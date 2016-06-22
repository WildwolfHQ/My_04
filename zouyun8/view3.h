//
//  view3.h
//  zouyun8
//
//  Created by 郑浩 on 16/4/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollUpView.h"
#import "NoticeModel.h"
#import "UIColor+Expanded.h"
@interface view3 : UIView
@property (weak, nonatomic) IBOutlet ScrollUpView *scrollUpView;
@property (nonatomic,strong)NSMutableArray *_mutArr;

-(void)setData:(NSMutableArray *)names andPrizes:(NSMutableArray *)prizes;
-(void)creatView;
-(void)createNoticeView;
@end
