//
//  GotosaidanVC.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Evaluate_list.h"
@interface GotosaidanVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *xinqing;

@property (strong, nonatomic) Evaluate_list *model;
@property (weak, nonatomic) IBOutlet UIScrollView *scroview;
@end
