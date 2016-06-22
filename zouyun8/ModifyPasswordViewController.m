//
//  ModifyPasswordViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/17.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"修改密码";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)verificationCodeBt:(UIButton *)sender {
    //请求短信验证码
    [self getMessageCode];
}

- (IBAction)complete:(UIButton *)sender {
    //post忘记密码接口
    [self replacePassWord];
}



-(void)replacePassWord
{
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.iphone.text;
    params[@"code"] = self.verificationCode.text;
    params[@"password"] = self.passWord.text;
    [HttpRequest postWithURLString:@"http://zy8.jf-q.com/api/reset_password" parameters:params success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSNumber * errcode = dict[@"errcode"];
         NSLog(@"%@",errcode);
         
         if ([errcode integerValue]==0) {
            
             [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {   //登录成功,返回并加载个人信息
             
              [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - 获取短信验证码
-(void)getMessageCode
{
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.iphone.text;
    params[@"type"] = @"1";
    [HttpRequest postWithURLString:@"http://zy8.jf-q.com/api/sendcode" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSNumber * errcode = dict[@"errcode"];
        NSLog(@"%@",errcode);
        
        if ([errcode integerValue]==0) {
            //按钮倒计时
            [self.verificationCodeBt startWithTime:60 title:@"重新获取" countDownTitle:@"S" mainColor:[UIColor blackColor] countColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1.0f]];
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];

           
        }
        else
        {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
            
        }
        
        NSLog(@"--------------------%@",dict);
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];
}

#pragma mark - 取消textfield第一响应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField * text in self.view.subviews) {
        [text resignFirstResponder];
    }
}
@end
