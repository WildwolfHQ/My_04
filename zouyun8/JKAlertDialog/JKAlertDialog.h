//
//  JKAlertDialog.h
//  JKAlertDialog
//
//  Created by Jakey on 15/3/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>






@interface JKAlertDialog : UIView
{
    UIView *_coverView;
    UIView *_alertView;
 
    
  
    UIScrollView *_contentScrollView;
    
   
  
   

}

//将要显示在alert上的自定义view
@property(strong,nonatomic)UIView *contentView;
@property(assign,nonatomic)CGSize contentViewSize;


- (instancetype)init;


- (void)show;
- (void)dismiss;
@end




