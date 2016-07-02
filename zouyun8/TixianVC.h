//
//  TixianVC.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/28.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TixianVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *moneng;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *yinhangName;
@property (weak, nonatomic) IBOutlet UITextField *zhihnagName;
@property (weak, nonatomic) IBOutlet UITextField *yinhangkahao;
- (IBAction)queding:(UIButton *)sender;

@property (strong, nonatomic)  NSString *yongjing;
@end
