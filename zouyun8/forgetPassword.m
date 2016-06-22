//
//  forgetPassword.m
//  zouyun8
//
//  Created by 郑浩 on 16/4/11.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "forgetPassword.h"

@interface forgetPassword ()

@end

@implementation forgetPassword

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1],
                                                                NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    self.title = @"忘记密码";
}

#pragma mark - 取消textfield第一响应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField * text in self.view.subviews) {
        [text resignFirstResponder];
    }
}

- (IBAction)获取验证码:(id)sender {
    //请求短信验证码
    [self getMessageCode];
}

- (IBAction)确认:(id)sender {
    //post忘记密码接口
    [self replacePassWord];
}

-(void)replacePassWord
{
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.phoneNumberText.text;
    params[@"code"] = self.messageCode.text;
    params[@"password"] = self.passWord.text;
    [HttpRequest postWithURLString:@"http://zy8.jf-q.com/api/reset_password" parameters:params success:^(id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString * errcode = dict[@"errcode"];
        NSLog(@"%@",errcode);
        
        if ([errcode integerValue]) {
            [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
        }
        else
        {   //登录成功,返回并加载个人信息
            
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"登录成功");
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取短信验证码
-(void)getMessageCode
{
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.phoneNumberText.text;
    params[@"type"] = @"1";
    [HttpRequest postWithURLString:@"http://zy8.jf-q.com/api/sendcode" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString * errcode = dict[@"errcode"];
        NSLog(@"%@",errcode);
        
        if ([errcode integerValue]) {
            [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
        }
        else
        {
        //按钮倒计时
        [self.verificationCodeBtn startWithTime:60 title:@"重新获取" countDownTitle:@"S" mainColor:[UIColor blackColor] countColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1.0f]];
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
        }
        
        NSLog(@"--------------------%@",dict);
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];
}
@end
