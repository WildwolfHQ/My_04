//
//  forgetPassword.h
//  zouyun8
//
//  Created by 郑浩 on 16/4/11.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgetPassword : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *messageCode;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *qurenBt;


@end
