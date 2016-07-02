//
//  TixianVC.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/28.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "TixianVC.h"

@interface TixianVC ()

@end

@implementation TixianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现";
    self.moneng.placeholder=[NSString stringWithFormat:@"请输入金额，可提现%@",self.yongjing];
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

- (IBAction)queding:(UIButton *)sender {
    if (self.moneng.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额"];
        return;
    }
    
    if (self.username.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡用户名"];
        return;
    }
    
    if (self.yinhangName.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行名称"];
        return;
    }
    
    if (self.zhihnagName.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入支行名称"];
        return;
    }
    if (self.yinhangkahao.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }
    
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
     dic[@"comm"]=self.moneng.text;
     dic[@"name"]=self.username.text;
     dic[@"bank_name"]=self.yinhangName.text;
     dic[@"bank_area"]=self.zhihnagName.text;
     dic[@"card_num"]=self.yinhangkahao.text;

    [self postWith:dic];
}


#pragma mark - 取消textfield第一响应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField * text in self.view.subviews) {
        [text resignFirstResponder];
    }
}



-(void)postWith:(NSDictionary *)dic{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = UID;
    params[@"token"] = TOKEN;
    params[@"comm"] = dic[@"comm"];
    params[@"name"] = dic[@"name"];
    params[@"bank_name"] = dic[@"bank_name"];
    params[@"bank_area"] = dic[@"bank_area"];
    params[@"card_num"] = dic[@"card_num"];
    
    
    
    [HttpRequest postWithURLString:@"https://m.zouyun8.com/api/comm_cash" parameters:params success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSNumber * errcode = dict[@"errcode"];
         NSString * errmsg = dict[@"errmsg"];
         //NSLog(@"%@",errcode);
         
         if ([errcode integerValue]==0) {
             [SVProgressHUD showSuccessWithStatus:@"发起申请提现完成"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"rusah_y" object:nil];
             [self.navigationController popViewControllerAnimated:YES];
             
         }
         else
         {
          
             [SVProgressHUD showErrorWithStatus:errmsg];
         }
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];


}
@end
