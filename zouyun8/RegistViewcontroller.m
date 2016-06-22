#import "RegistViewcontroller.h"
@interface RegistViewcontroller ()<CustomIOS7AlertViewDelegate>

@property(nonatomic,strong)UIButton * codeButton;
@property(nonatomic,strong)UITextField * codeText;
@property(nonatomic,strong)CustomIOS7AlertView *alertView;
@end
@implementation RegistViewcontroller

- (IBAction)注册:(id)sender {
    
     //普通注册
     if(self.isBangding==nil){
    
        [self sendRegist];
     }
    
     //注册和绑定
     if(self.isBangding.integerValue==0&&self.isBangding!=nil){
        
        [self sendRegist];
        
        
     }

    //立即绑定
    if(self.isBangding.integerValue==1){
     
        [self login:self.PhoneNumberText.text :self.passWord.text];
    
    
    }
    
    
   
}

- (IBAction)获取验证码:(id)sender {

    //弹出图形验证码框
    // Here we need to pass a full frame
    self.alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [self.alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    [self.alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确认", nil]];
    [self.alertView setDelegate:self];
    // You may use a Block, rather than a delegate.
    [self.alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
       // NSLog(@"Block: Button at position %d is clicked on alertView %ld.", buttonIndex, (long)[self.alertView tag]);
//        [alertView close];
    }];
    
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [self.alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
//    if (self.codeText.text.length != 4)
//    {
//        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
//        [alertView close];
//    }
//    
//    else
//    {
//        //获取短信验证码
//        [self getMessageCode];
//        
//        [alertView close];
//    }
    if (self.passWord.text.length == 0 || self.PhoneNumberText.text.length == 0 || self.codeText.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"信息不全"];
        [alertView close];
    }
    else if (self.PhoneNumberText.text.length != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"手机格式不正确"];
        [alertView close];
    }
    else if (self.passWord.text.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码至少为6位"];
        [alertView close];
    }
    else if(self.codeText.text.length != 4)
    {
        [SVProgressHUD showErrorWithStatus:@"图形验证码不正确"];
        [alertView close];
    }
    else
    {
        //获取短信验证码
        [self getMessageCode];
        [alertView close];
    }
    
   
    
    
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 50)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 30)];
//    [imageView setImage:[UIImage imageNamed:@"demo"]];
    imageView.userInteractionEnabled = YES;
    self.codeText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    self.codeText.borderStyle = UITextBorderStyleRoundedRect;
    
    //创建按钮并设置验证码为按钮背景
    self.codeButton = [[UIButton alloc]initWithFrame:CGRectMake(170, 0, 100, 30)];
    self.codeButton.backgroundColor = [UIColor blueColor];
    [self getPicture];
    //button增加事件，点击后重新获取验证码背景
    [self.codeButton addTarget:self action:@selector(getPicture) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:self.codeText];
    [imageView addSubview:self.codeButton];
    
    [demoView addSubview:imageView];
    return demoView;
}

#pragma mark - 获取短信验证码
-(void)getMessageCode
{
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.PhoneNumberText.text;
    params[@"code"] = self.codeText.text;
    NSLog(@"%@",self.PhoneNumberText.text);
    NSLog(@"%@",self.codeText.text);

    [HttpRequest postWithURLString:@"https://zy8.jf-q.com/api/sendcode" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
         NSNumber * errcode = dict[@"errcode"];
        NSLog(@"%@",errcode);
        
        
        
        if (errcode.integerValue==0) {
            //按钮倒计时
            [self.verificationCodeBtn startWithTime:60 title:@"重新获取" countDownTitle:@"S" mainColor:[UIColor blackColor] countColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1.0f]];
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
        }else{
            
            if (errcode.integerValue==10001) {
                [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确"];
            }

            
            if (errcode.integerValue==10002) {
                   [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
            }
            
            if (errcode.integerValue==10003) {
                [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
            }
            
            if (errcode.integerValue==10004) {
                [SVProgressHUD showErrorWithStatus:@"此手机号已经被注册"];
            }
         
            if (errcode.integerValue==10011) {
                [SVProgressHUD showErrorWithStatus:@"图形验证码验证失败"];
            }
        
        }
        
        
        

        //NSLog(@"--------------------%@",dict);
    } failure:^(NSError *error) {
        //NSLog(@"--------------------请求失败");
    }];
}

#pragma mark -发送注册请求
-(void)sendRegist
{
        //post请求
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = self.PhoneNumberText.text;
        params[@"code"] = self.messageCode.text;
        params[@"password"] = self.passWord.text;
                                                               
        [HttpRequest postWithURLString:@"https://zy8.jf-q.com/api/register" parameters:params success:^(id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
           NSNumber * errcode = dict[@"errcode"];
            
            
            if (errcode.integerValue==0) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功,正在登录..."];
                
                //保存用户token等用户信息,并同步
                [ToolClass saveUserInfo:dict];
                
                [self login:self.PhoneNumberText.text :self.passWord.text];
                
            }else{
                
                if (errcode.integerValue==10006) {
                    [SVProgressHUD showErrorWithStatus:@"验证码验证失败"];
                }
                
                
                if (errcode.integerValue==10007) {
                    [SVProgressHUD showErrorWithStatus:@"密码长度必须为6-16位"];
                }
                
                if (errcode.integerValue==10008) {
                    [SVProgressHUD showErrorWithStatus:@"注册失败，未知错误"];
                }
                
                if (errcode.integerValue==10004) {
                    [SVProgressHUD showErrorWithStatus:@"此手机号已经被注册"];
                }
                
                
            }
            
            
            
           
            
        } failure:^(NSError *error) {
            //NSLog(@"--------------------请求失败");
        }];
}



-(void)login:(NSString *)username :(NSString *)password{
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = username;
    params[@"password"] = password;
    [HttpRequest postWithURLString:@"https://zy8.jf-q.com/api/login" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSNumber * errcode = dict[@"errcode"];
        NSLog(@"%@",errcode);
        
        
        if (errcode.integerValue==0) {
            
            [ToolClass saveUserInfo:dict];
            //登录成功后将购物车清空
            [ToolClass removeAllCart];
            if (self.isBangding!=nil) {
                [self boundThirdAccount:nil];
                
            }else{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                //保存用户token等用户信息,并同步
                
                
                
            }

            
        }else{
            
            if (errcode.integerValue==10009) {
                [SVProgressHUD showErrorWithStatus:@"暂无此用户,用户未注册"];
            }
            
            
            if (errcode.integerValue==10010) {
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
            }
            
//            if (errcode.integerValue==10008) {
//                [SVProgressHUD showErrorWithStatus:@"注册失败，未知错误"];
//            }
//            
//            if (errcode.integerValue==10004) {
//                [SVProgressHUD showErrorWithStatus:@"此手机号已经被注册"];
//            }
            
            
        }
        

        
        
        
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];
    
    
}
#pragma mark - 更换图形验证码
-(void)getPicture
{
    [self.codeButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://zy8.jf-q.com/api/captcha?mobile=%@",self.PhoneNumberText.text]]]] forState:UIControlStateNormal];
}

#pragma mark - 取消textfield第一响应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITextField * text in self.view.subviews) {
        [text resignFirstResponder];
    }
}


#pragma mark - 绑定第三方账号
-(void)boundThirdAccount:(NSString *)confirm
{
    
    NSLog(@"开始绑定");
    NSLog(@"打印openid%@",self.openid);
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    params[@"openid"] = self.openid;
    params[@"type"] = self.type;
    params[@"nick"] = self.nick;
    params[@"imgurl"] = self.imgurl;
    if (confirm!=nil) {
        params[@"confirm"] = confirm;
    }
    
    [HttpRequest postWithURLString:@"https://zy8.jf-q.com/api/user_bind" parameters:params success:^(id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSNumber * errcode = dict[@"errcode"];
        NSLog(@"%@",errcode);
        
        
        if (errcode.integerValue==0) {
            
            //注册并绑定成功
            [SVProgressHUD showSuccessWithStatus:@"账号绑定成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            if (errcode.integerValue==10013) {
                [SVProgressHUD showErrorWithStatus:@"token验证失败，请检查uid与token是否有效"];
            }
            
            
            if (errcode.integerValue==10014) {
                [SVProgressHUD showErrorWithStatus:@"无此用户"];
            }
            
            if (errcode.integerValue==10015) {
                [SVProgressHUD showErrorWithStatus:@"请求参数错误"];
            }
            
            if (errcode.integerValue==10016) {
                [SVProgressHUD showErrorWithStatus:@"请求参数错误"];
            }
            
            if (errcode.integerValue==10017) {
                [SVProgressHUD showErrorWithStatus:@"请求参数错误"];
            }
            
            if (errcode.integerValue==10018) {
                [SVProgressHUD showErrorWithStatus:@"用户未绑定"];
            }
            
            if (errcode.integerValue==10019) {
                //[SVProgressHUD showErrorWithStatus:@"用户绑定失败,该手机号已绑定"];//confirm
                
                
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户绑定失败" message:@"该手机号已绑定,是否跟换绑定" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                
        
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self boundThirdAccount:@"1"];
            
                    
                    
                }];
                
                
                
                
               
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                
                //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
                if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
                    
                {
                    
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
                    
                    
                }
                
            }
            
            
            
        }
        

        
      
    } failure:^(NSError *error) {
        NSLog(@"--------------------请求失败");
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isBangding!=nil&&self.isBangding.integerValue==0) {
        
         self.title = @"快速注册";
        [self.zucebutton setTitle:@"注册并关联" forState:UIControlStateNormal];
    }
    
    if (self.isBangding!=nil&&self.isBangding.integerValue==1) {
        
        self.title = @"立即关联";
        [self.zucebutton setTitle:@"确定关联" forState:UIControlStateNormal];
        self.messageCode.hidden=YES;
        self.verificationCodeBtn.hidden=YES;
        
        
    }

    if (self.isBangding==nil) {
        self.title = @"用户注册";
        [self.zucebutton setTitle:@"注册" forState:UIControlStateNormal];
        
    }
    
}
@end
