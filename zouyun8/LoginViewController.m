#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置letView
    self.userNameText.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p_21"]];
    self.userNameText.leftViewMode = UITextFieldViewModeAlways;
    self.passWordText.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"p_21"]];
    self.passWordText.leftViewMode = UITextFieldViewModeAlways;
    
    //设置导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToTabbar)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
}

-(void)backToTabbar
{
    NSLog(@"点击了");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:nil];
//    [UIApplication sharedApplication].keyWindow.rootViewController =
//    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeRootViewController" object:nil];
//    [self.navigationController removeFromParentViewController];
}

- (IBAction)登录:(id)sender {
    [SVProgressHUD showWithStatus:@"正在登录"];
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = self.userNameText.text;
    params[@"password"] = self.passWordText.text;
    [HttpRequest postWithURLString:@"https://m.zouyun8.com/api/login" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString * errcode = dict[@"errcode"];
        NSLog(@"%@",errcode);
        
        
        if ([errcode integerValue]) {
            [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            //保存用户token等用户信息,并同步
            [ToolClass saveUserInfo:dict];
            //登录成功后将购物车清空
            ///[ToolClass removeAllCart];
            //退回到个人中心，并刷新个人信息界面
            [self.navigationController popViewControllerAnimated:YES];
            //
            //
        }
        NSLog(@"--------------------%@---------------",dict[@"data"]);
        
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];
}

- (IBAction)忘记密码:(id)sender {
    forgetPassword * forget = [[forgetPassword alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}
- (IBAction)新用户注册:(id)sender {
    RegistViewcontroller * regist = [[RegistViewcontroller alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark - 取消textfield第一响应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField * text in self.view.subviews) {
        [text resignFirstResponder];
    }
}

- (IBAction)QQ登录:(id)sender {
    
    
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         
         
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self thirdLogin:user.uid andType:@"2" andNick:user.nickname andImgurl:user.icon];
             
             [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
         }
         else
         {
             NSLog(@"%@",error);
         }
     }];
}

- (IBAction)微信登录:(id)sender {
    
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             
             [self thirdLogin:user.uid andType:@"1" andNick:user.nickname andImgurl:user.icon];
             
             [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
         }
         else
         {
             NSLog(@"%@",error);
         }
     }];}
- (IBAction)新浪登录:(id)sender {
    
    if([WeiboSDK isWeiboAppInstalled]){
    
    
    }
    
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self thirdLogin:user.uid andType:@"3" andNick:user.nickname andImgurl:user.icon];
             
             [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
         }
         else
         {
             NSLog(@"%@",error);
         }
     }];
}

#pragma mark - 获取第三方登录信息后判断改信息是否绑定过手机号
-(void)thirdLogin:(NSString *)uid andType:(NSString *)type andNick:(NSString *)nick andImgurl:(NSString *)imgurl
{
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"openid"] = uid;
    params[@"type"] = type;
    [HttpRequest postWithURLString:@"https://m.zouyun8.com/api/openid_login" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString * errcode = dict[@"errcode"]; //10018
          NSDictionary * data = dict[@"data"]; //10018
        if ([errcode integerValue]) {
            if ([dict[@"errmsg"] isEqualToString:@"用户未绑定"]) {
                //[SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证手机" message:@"建议绑定手机号，以便便下次快捷登录" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                
                UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"快速注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                    //跳转到绑定界面
                    RegistViewcontroller * bound = [[RegistViewcontroller alloc]init];
                    bound.openid = uid;
                    bound.type = type;
                    bound.nick = nick;
                    bound.imgurl = imgurl;
                    bound.isBangding=@"0";
                    [self.navigationController pushViewController:bound animated:YES];
                    
                    
                }];

                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即关联" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                    //跳转到绑定界面
                    RegistViewcontroller * bound = [[RegistViewcontroller alloc]init];
                    bound.openid = uid;
                    bound.type = type;
                    bound.nick = nick;
                    bound.imgurl = imgurl;
                    bound.isBangding=@"1";
                    [self.navigationController pushViewController:bound animated:YES];
                    
                    
                }];
                
                
                
                
                [alertController addAction:okAction1];
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                
                //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
                if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
                    
                {
                    
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
                    
                    
                }
                
                
                
            }
        }
        else
        {
            
            //直接登录
            
            [self token_login:data[@"token"] andUid:data[@"uid"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];

}



-(void)token_login:(NSString *)token andUid:(NSString *)uid{
    
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    params[@"uid"] = uid;
    [HttpRequest postWithURLString:@"https://m.zouyun8.com/api/token_login" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSNumber * errcode = dict[@"errcode"]; //10018
        if ([errcode integerValue]==0) {
            [ToolClass saveUserInfo:dict];
            //登录成功后将购物车清空
            //[ToolClass removeAllCart];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
           
            

        }else{
            if (errcode.integerValue==10009) {
                [SVProgressHUD showErrorWithStatus:@"暂无此用户,用户未注册"];
            }
            
            
            if (errcode.integerValue==10010) {
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
            }

        
        }
    
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];
    
    
}

@end
