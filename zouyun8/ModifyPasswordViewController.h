//
//  ModifyPasswordViewController.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/17.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *iphone;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
- (IBAction)verificationCodeBt:(UIButton *)sender;
- (IBAction)complete:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBt;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBt1;

@end
