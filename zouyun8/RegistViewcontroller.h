//
//  LoginViewcontroller.h
//  zouyun8
//
//  Created by 郑浩 on 16/4/11.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewcontroller : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *messageCode;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *zucebutton;
@property(nonatomic,copy)NSString * openid;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * isBangding;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,copy)NSString * imgurl;
@end
