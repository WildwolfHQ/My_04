#import "SettleAccountsViewController.h"
#import "UPPaymentControl.h"
@interface SettleAccountsViewController ()<UITableViewDelegate,UITableViewDataSource,SettleView4Delegate,SettleView5Delegate,SettleView6Delegate,UIAlertViewDelegate>{


    

}
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,assign)BOOL is_expaned;
@property(nonatomic,strong)SettleView1 * view1;
@property(nonatomic,strong)SettleView2 * view2;
@property(nonatomic,strong)SettleView3 * view3;
@property(nonatomic,strong)SettleView4 * view4;
@property(nonatomic,strong)SettleView5 * view5;
@property(nonatomic,strong)SettleView6 * view6;
@property(nonatomic,strong)NSDictionary * payInfo;

@property(nonatomic,copy)NSString * score;//奖金
@property(nonatomic,copy)NSString * discount;//折扣百分比
@property(nonatomic,copy)NSString * totalPrice;//商品总价
@property(nonatomic,copy)NSString * discountMoney;//要折扣的价格
@property(nonatomic,copy)NSString * defaultAddress;
@property(nonatomic,copy)NSString * defaultAddressID;
@property(nonatomic,copy)NSString * json;
@property(nonatomic,copy)NSString * is_discount;
@property(nonatomic,copy)NSString * rechargeNum;
@property(nonatomic,copy)NSString * orderID;//生成的订单号
@end

@implementation SettleAccountsViewController
-(void)submitOrder
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"走运币支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self zouyunPay];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self weixinPay];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"银联支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self unionPay];
    }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            NSLog(@"取消支付");
        }];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action4];
    [alert addAction:action3];
   
    [self presentViewController:alert animated:YES completion:nil];
}

//微信支付方法
-(NSString *)jumpToBizPay:(NSDictionary *)dict
{
    NSLog(@"进来了%@",dict);
    [SVProgressHUD showWithStatus:@"正在加载微信支付"];
    //判断当前设备是否安装了微信
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装微信");
        [SVProgressHUD showErrorWithStatus:@"没有安装微信"];
        return nil;
    }
    else if (![WXApi isWXAppSupportApi])
    {
        NSLog(@"不支持微信支付");
        return nil;
    }
    NSLog(@"安装了微信，且支持微信支付");
    
    if (dict != nil)
    {
        if(dict != nil)
        {
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            NSLog(@"微信支付啊%d",retcode.intValue);
            if (retcode.intValue == 0)
            {
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                [SVProgressHUD dismiss];
                return @"";
            }
            else
            {
                [SVProgressHUD dismiss];
                return [dict objectForKey:@"retmsg"];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            return @"服务器返回错误，未获取到json对象";
        }
    }
    else
    {
        [SVProgressHUD dismiss];
        return @"服务器返回错误";
    }
}

//走运币支付方式
-(void)zouyunPay
{
    //清空购物车角标
    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
    item.badgeValue = nil;
    
    //1.获取用户走运币数量
    [ToolClass getUserInfoSuccess:^(NSDictionary * dic) {
        NSLog(@"走运币数目为%@",dic[@"data"][@"money"]);
        //2.对比需要支付的走运币数量
        if ([self.totalPrice integerValue] > [dic[@"data"][@"money"] integerValue]) {
            [SVProgressHUD showErrorWithStatus:@"走运币不足，请充值"];
            
            //弹出提示框，是否充值走运币
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"走运币不足" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            __weak typeof(self) weakSelf = self;
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了充值");
                //弹出充值数目提示框
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"充值数目" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
                alertView.delegate = self;
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alertView show];
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消");
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            //创建直接用走运币支付订单,并清空购物车
            [self removeAllCart];
            
            //创建订单号
            [ToolClass create_bill:^(NSDictionary *dict)
             {
                 self.orderID = dict[@"data"][@"id"];
                 
                 //根据订单信息，获取到支付的参数
                 [ToolClass getPayParameter:^(NSDictionary *dic) {
                     NSNumber * errcode = dict[@"errcode"];
                     //获取支付参数后调用微信或银联支付（此处微信）
                     //跳转到购物车界面
                     //ShoppingcartViewController * cart = [[ShoppingcartViewController alloc]init];
                     
                     if (errcode.integerValue==0) {
                         
                         //[SVProgressHUD showSuccessWithStatus:@"支付成功"];
                         [self getData1];
                         
//                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否分享奖金红包" preferredStyle:UIAlertControllerStyleAlert];
//                         
//                         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                         
//                         [self.navigationController popViewControllerAnimated:YES];
//                         
//                         
//                         
//                         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                             
//                             
//                             
//                             
//                         }];
                         
                         
                         
                         
//                         
//                         [alertController addAction:okAction];
//                         [alertController addAction:cancelAction];
                         
//                         //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
//                         if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
//                             
//                         {
//                             
//                             
//                             [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
//                             
//                             
//                         }

                         
                     }else{
                       [SVProgressHUD showSuccessWithStatus:@"支付失败"];
                     
                     }
                     
                    
                     
                     
                     
                     
                     
                 } orderID:self.orderID payType:@"0"];
                 
             } order:self.json addressID:self.defaultAddressID is_discount:self.is_discount payID:@"1" payType:@"0" rechargeMoney:nil app:@"1"];
        }
    }];
}
//确定充值走运币后
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)//点击了确定
    {
        //得到充值的数目
        self.rechargeNum = [alertView textFieldAtIndex:0].text;
        
        //创建需要充值走运币的订单
        [ToolClass create_bill:^(NSDictionary *dict)
        {
            self.orderID = dict[@"data"][@"id"];

            //根据订单信息，获取到支付的参数
            [ToolClass getPayParameter:^(NSDictionary *dic) {
                NSLog(@"支付参数为%@",dic);
                //获取支付参数后调用微信或银联支付（此处微信）
                if (dic[@"prepayid"] == NULL)
                {
                    [SVProgressHUD showErrorWithStatus:@"获取订单失败，请重新提交"];
                    [NSThread sleepForTimeInterval:1];
                }
                else
                {
                    [SVProgressHUD showSuccessWithStatus:@"获取订单成功"];
                    //调用微信Sdk支付
                    [self jumpToBizPay:dic];
                }
            } orderID:self.orderID payType:@"1"];
            
        } order:self.json addressID:self.defaultAddressID is_discount:self.is_discount payID:@"2" payType:@"1" rechargeMoney:self.rechargeNum app:@"1"];
    }
    else
    {
        self.rechargeNum = @"0";
    }
}
//清空购物车
-(void)removeAllCart
{
//    //1.从数据库中删除所有购物车数据
//    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
//    // 打开数据库
//    [db open];
//    FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
//    while ([result next])
//    {
//        //判断：如果当前cell的商品标题在数据库中已存在 则删除该行字段
//        NSString *name = [result stringForColumn:@"name"];
//        if (name) {
//            NSString *deleteSql = [NSString stringWithFormat:
//                                   @"delete from t_contact where name = '%@'",
//                                   name];
//            [db executeUpdate:deleteSql];
//        }
//    }
//    //2.通知购物车界面tableView清空
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeAllCart" object:nil];
    [ToolClass removeAllCart];
}

//银联支付
-(void)unionPay
{
     [self removeAllCart];
    //[ToolClass removeAllCart];
    
    [ToolClass create_bill:^(NSDictionary *dict)
     {
         self.orderID = dict[@"data"][@"id"];
         //根据订单信息，获取到支付的参数
         [ToolClass getPayParameter:^(NSDictionary *dic) {
             NSLog(@"支付参数为%@",dic);
            
             
             if (dic[@"tn"] == NULL)
             {
                 [SVProgressHUD showErrorWithStatus:@"获取订单失败，请重新提交"];
                 [NSThread sleepForTimeInterval:1];
             }
             else
             {
                 [SVProgressHUD showSuccessWithStatus:@"获取订单成功"];
                 
                 
                 [self UnionPay:dic[@"tn"]];
                 //[self jumpToBizPay:dic];
             }
             

             
             
         } orderID:self.orderID payType:@"0"];        // payID 1走运币 2微信 3银联
         
     } order:self.json addressID:self.defaultAddressID is_discount:self.is_discount payID:@"3" payType:@"0" rechargeMoney:nil app:@"1"];

    
   
}

-(void)UnionPay:(NSString *)tn{
    
    if ([[UPPaymentControl defaultControl] isPaymentAppInstalled]) {
        
        if ([[UPPaymentControl defaultControl] startPay:tn fromScheme:@"zouyun8" mode:@"00" viewController:self])
        {
            
            //获取通知中心单例对象
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
            [center addObserver:self selector:@selector(unionPaySuccessNotice:) name:@"unionPaySuccess" object:nil];
            
        }else{
        
          [SVProgressHUD showSuccessWithStatus:@"调起银联支付控件失败"];
        
        }
        
    }else{
        [SVProgressHUD showSuccessWithStatus:@"未安装银联支付APP"];
        
    
    }

    

    

}
//#pragma mark UPPayPluginResult
//- (void)UPPayPluginResult:(NSString *)result
//{
//    NSString* msg = [NSString stringWithFormat:@"支付结果：%@", result];
//    [SVProgressHUD showSuccessWithStatus:msg];
//}

//#pragma mark UPPayPluginResult
//- (void)UPPayPluginResult:(NSString *)result
//{
//    
//    NSString* msg = [NSString stringWithFormat:@"支付结果：%@", result];
//    [SVProgressHUD showWithStatus:msg];
//}

//微信支付方式
-(void)weixinPay
{
    //点击了微信支付后清空数据库购物车数据
    [self removeAllCart];
    //创建订单号
    [ToolClass create_bill:^(NSDictionary *dict)
     {
         self.orderID = dict[@"data"][@"id"];
         //根据订单信息，获取到支付的参数
         [ToolClass getPayParameter:^(NSDictionary *dic) {
             NSLog(@"支付参数为%@",dic);
             //获取支付参数后调用微信或银联支付（此处微信）
             if (dic[@"prepayid"] == NULL)
             {
                 [SVProgressHUD showErrorWithStatus:@"获取订单失败，请重新提交"];
                 [NSThread sleepForTimeInterval:1];
             }
             else
             {
                 [SVProgressHUD showSuccessWithStatus:@"获取订单成功"];
                 //调用微信Sdk支付
                 //获取通知中心单例对象
                 NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                 //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
                 [center addObserver:self selector:@selector(weixinPaySuccessNotice:) name:@"weixinPaySuccessNotice" object:nil];
                 [self jumpToBizPay:dic];
             }

         } orderID:self.orderID payType:@"0"];
         
     } order:self.json addressID:self.defaultAddressID is_discount:self.is_discount payID:@"2" payType:@"0" rechargeMoney:nil app:@"1"];
}
-(void)moreAddress
{
    AddAddressController * add = [[AddAddressController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)changeTotalPrice:(void (^)())b
{
    NSLog(@"底部减掉总价");
    if ([self.discountMoney floatValue] > [self.view2.bonus.text integerValue])
    {
        [SVProgressHUD showErrorWithStatus:@"您的奖金不足"];
        b();
        self.is_discount = @"0";
    }
    else
    {
        self.view6.totalPrice.text = [NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue] - [self.discountMoney floatValue]];
        self.is_discount = @"1";
    }
}
-(void)resetTotalPrice
{
    self.view6.totalPrice.text = self.totalPrice;
    self.is_discount = @"0";
}
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.hidden = YES;
    }];
}
- (void)viewDidLoad
{
    self.is_discount = @"0";
    [super viewDidLoad];
    self.title = @"确定订单";
    [self getOrders];
    [self getData];
    [self getPayInfo];
    [self getDefaultAddress];
    [self createTableView];
    
    
}

//我们可以在回调的函数中取到userInfo内容，如下：
-(void)unionPaySuccessNotice:(id)sender{
    
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    parameters[@"id"] = self.orderID;
    parameters[@"type"] = @"0";
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:@"https://m.zouyun8.com/api/pay_status" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * str=dict[@"code"];//code	int	必须	0表示到账，1表示未到帐

         if (str.integerValue==0) {
             
             [SVProgressHUD showSuccessWithStatus:@"支付成功"];
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否分享奖金红包" preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
             
             [self.navigationController popViewControllerAnimated:YES];
             
             
             
             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
                 
                 [self getData1];
                 
             }];
             
             
             
             
             
             [alertController addAction:okAction];
             [alertController addAction:cancelAction];
             
             //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
             if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
                 
             {
                 
                 
                 [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
                 
                 
             }

             
         }else{
             
              [SVProgressHUD showSuccessWithStatus:@"支付失败"];
         
         
         }
         
         
     
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];

    
    
    
    NSLog(@"%@",sender);
}

-(void)weixinPaySuccessNotice:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否分享奖金红包" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self getData1];
        
    }];
    
    
    
    
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
        
    {
        
        
        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
        
        
    }

    
}

-(void)getDefaultAddress
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    [manager GET:ADDRESS_LISTURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSArray * array = dict[@"data"];
         NSDictionary * dic;
         if (array.count != 0) {
             dic = array[0];
         }
         else
         {
             //跳转到添加收货地址页面
             NSLog(@"跳转页面添加收货地址");
         }
         self.defaultAddress = [NSString stringWithFormat:@"%@%@%@%@",dic[@"province"],dic[@"city"],dic[@"town"],dic[@"detail"]];
         self.defaultAddressID = dic[@"id"];
         //
         [self createUI];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}
-(void)getOrders
{
    self.orders = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
    // 从结果集里面往下找
    while ([result next])
    {
        shoppingcartModel * model = [[shoppingcartModel alloc]init];
        model.lucky_id = [result stringForColumn:@"lucky_id"];
        model.bid_id = [result stringForColumn:@"bid_id"];
        model.type = [result stringForColumn:@"type"];
        model.num = [result stringForColumn:@"num"];
        model.price_level = [result stringForColumn:@"price_level"];
        //将model的商品信息，token,uid封装为json数据
        NSDictionary * dic;
        if (model.lucky_id) {
           dic= @{@"id":model.lucky_id,@"type":model.type,@"num":model.num};
        }
        if (model.bid_id) {
            model.type=@"2";
            dic= @{@"id":model.bid_id,@"type":model.type,@"num":model.num,@"price_level":model.price_level};
        }
        [self.orders addObject:dic];
    }
}
-(void)getData
{
    [self.dataSource removeAllObjects];
    //订单json信息
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:self.orders
                                                        options:kNilOptions
                                                          error:nil];
    self.json = [[NSString alloc] initWithData:JSONData
                                            encoding:NSUTF8StringEncoding];
    if (self.json != NULL && ![self.json isEqualToString:@"[]"])
    {
        NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
        parameters[@"uid"] = UID;
        parameters[@"token"] = TOKEN;
        parameters[@"data"] = self.json;
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        
        [manager POST:ORDER_INFO parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             NSArray * array = dict[@"data"];
             NSLog(@"错误码%@",dict[@"errcode"]);
             NSLog(@"错误码%@",dict[@"errmsg"]);
             NSLog(@"请求的json是%@",self.json);
             NSLog(@"返回的订单信息%@",dict[@"data"]);
             float price = 0;
             for (NSDictionary * dic in array)
             {
                 price += [dic[@"sum_money"] floatValue];
                 SettleModel * model = [[SettleModel alloc]init];
                 model.name = dic[@"name"];
                 model.num = dic[@"num"];
                 [self.dataSource addObject:model];
             }
             self.totalPrice = [NSString stringWithFormat:@"%.2f",price];
             NSLog(@"总价为%@",self.totalPrice);
             [self getPayInfo];
             [self.tableView reloadData];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
         }];
    }
}
-(void)getPayInfo
{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:PAY_INFO parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         self.score = [NSString stringWithFormat:@"%@",dict[@"data"][@"score"]];
         self.discount = [NSString stringWithFormat:@"%@",dict[@"data"][@"discount"]];
         self.discountMoney = [NSString stringWithFormat:@"%.2f",[self.discount floatValue] * [self.totalPrice floatValue]/100.0];
         [self getDefaultAddress];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}
-(void)createUI
{
    self.view1 = [[NSBundle mainBundle]loadNibNamed:@"SettleView1" owner:self options:nil].firstObject;
    self.view1.frame = CGRectMake(0, 64, WIDTH, 44);
    self.view1.GoodsCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count];
    
    [self.view addSubview:self.view1];
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view1 addGestureRecognizer:tap];
    
    self.view2 = [[NSBundle mainBundle]loadNibNamed:@"SettleView2" owner:self options:nil].firstObject;
    self.view2.bonus.text = [NSString stringWithFormat:@"%.2f",[self.score floatValue]/10.0];
    self.view2.deduction.text = self.discount;
    self.view2.frame = CGRectMake(0, CGRectGetMaxY(self.view1.frame), WIDTH, 44);
    [self.view addSubview:self.view2];
    
    self.view3 = [[NSBundle mainBundle]loadNibNamed:@"SettleView3" owner:self options:nil].firstObject;
    self.view3.money.text = self.totalPrice;
    self.view3.frame = CGRectMake(0, CGRectGetMaxY(self.view2.frame), WIDTH, 44);
    [self.view addSubview:self.view3];
    
    self.view4 = [[NSBundle mainBundle]loadNibNamed:@"SettleView4" owner:self options:nil].firstObject;
    self.view4.delegate = self;
    self.view4.discountMoney.text = self.discountMoney;
    self.view4.frame = CGRectMake(0, CGRectGetMaxY(self.view3.frame), WIDTH, 44);
    [self.view addSubview:self.view4];
    
    self.view5 = [[NSBundle mainBundle]loadNibNamed:@"SettleView5" owner:self options:nil].firstObject;
    self.view5.delegate = self;
    self.view5.defaultAddress.text = self.defaultAddress;
    self.view5.frame = CGRectMake(0, CGRectGetMaxY(self.view4.frame), WIDTH, 44);
    [self.view addSubview:self.view5];
    
    self.view6 = [[NSBundle mainBundle]loadNibNamed:@"SettleView6" owner:self options:nil].firstObject;
    self.view6.delegate = self;
    self.view6.totalPrice.text = self.totalPrice;
    self.view6.frame = CGRectMake(0, HEIGHT - 49, WIDTH, 49);
    [self.view addSubview:self.view6];
}
-(void)tap:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"点击了");
    if (self.is_expaned == NO) {
        //箭头向下
        [self.view1.arrowBtn setImage:[UIImage imageNamed:@"indicator_new向下"] forState:UIControlStateNormal];
        //点击操作
        [UIView animateWithDuration:0.5 animations:^{
            if (self.dataSource.count > 3) {
                self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.view1.frame), WIDTH, 3 * 44);
            }
            else
            {
                self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.view1.frame), WIDTH, self.dataSource.count * 44);
            }
            self.view2.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), WIDTH, 44);
            self.view3.frame = CGRectMake(0, CGRectGetMaxY(self.view2.frame), WIDTH, 44);
            self.view4.frame = CGRectMake(0, CGRectGetMaxY(self.view3.frame), WIDTH, 44);
            self.view5.frame = CGRectMake(0, CGRectGetMaxY(self.view4.frame), WIDTH, 44);
            [self.view addSubview:self.tableView];
        }];
        self.is_expaned = YES;
    }
    else
    {
        //箭头向上
        [self.view1.arrowBtn setImage:[UIImage imageNamed:@"Indicator"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.view1.frame), WIDTH, 0);
            self.view2.frame = CGRectMake(0, CGRectGetMaxY(self.view1.frame), WIDTH, 44);
            self.view3.frame = CGRectMake(0, CGRectGetMaxY(self.view2.frame), WIDTH, 44);
            self.view4.frame = CGRectMake(0, CGRectGetMaxY(self.view3.frame), WIDTH, 44);
            self.view5.frame = CGRectMake(0, CGRectGetMaxY(self.view4.frame), WIDTH, 44);
        }];
        self.is_expaned = NO;
    }
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view1.frame), WIDTH, 0) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    SettleModel * model = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor greenColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.num];
    return cell;
}




#pragma mark - 分享红包前的请求
-(void)getData1
{
    
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"category"] = @"";//int	可选	分类id
  
        params[@"type"] = @"11";
    
 
        params[@"uid"] = UID;
        params[@"token"] = TOKEN;
  
    
   
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:@"https://m.zouyun8.com/api/share_data" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         NSLog(@"%@",dict);
         NSDictionary *dic1 = dict[@"data"];
         
         
         NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
         [dic setValue:dic1[@"imgurl"] forKey:@"image"];
         [dic setValue:dic1[@"desc"]   forKey:@"desc"];
         [dic setValue:dic1[@"link" ]  forKey:@"url"];
         [dic setValue:dic1[@"title"]  forKey:@"title"];
         [dic setValue:@"3" forKey:@"share_action"];//action	int	必须	分享类型	1商品详情，2二维码，3活动页
         
         [self share:dic];
         
         
         
         //[self.navigationController popViewControllerAnimated:YES];

         
         //[self.collectionView.infiniteScrollingView stopAnimating];
         //[self.collectionView.pullToRefreshView stopAnimating];
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
         
         
     }];
}




//二维码，商品详情分享
-(void)share:(NSDictionary *)dict
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSString * image = [[NSString alloc]init];
    NSString * desc = [[NSString alloc]init];
    NSString * url = [[NSString alloc]init];
    NSString * title = [[NSString alloc]init];
    
    image = dict[@"image"];
    desc = dict[@"desc"];
    url = dict[@"url"];
    title = dict[@"title"];
    
    NSLog(@"分享的图片链接为%@",image);
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:@[image]
                                        url:[NSURL URLWithString:url]
     
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:desc title:title image:@[image] url:[NSURL URLWithString:url] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
     {
         
         switch (state)
         {
             case SSDKResponseStateSuccess:
             {
                 NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
                 
                 
                 parameters[@"uid"] = UID;
                 parameters[@"token"] = TOKEN;
                 NSString *type=@"";
                 if (platformType==SSDKPlatformTypeWechat) {
                     type=@"1";
                     
                 }
                 if (platformType==SSDKPlatformTypeQQ) {
                     type=@"2";
                     
                 }
                 if (platformType==SSDKPlatformTypeSinaWeibo) {
                     type=@"3";
                     
                 }
                 
                 parameters[@"type"] = type;//分享方式 1微信，2QQ，3新浪
                 parameters[@"action"] = dict[@"share_action"];
                 AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                 manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                 
                 AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
                 securityPolicy.validatesDomainName = NO;
                 securityPolicy.allowInvalidCertificates = YES;
                 manager.securityPolicy = securityPolicy;
                 
                 [manager GET:Share_successURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                  {
                      
                      [self.navigationController popViewControllerAnimated:YES];
                    
                  }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
                  {
                      
                      
                  }];
                 
                 
                 
                 
                 [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 
                 break;
             }
             default:
                 break;
         }
     }
     ];
}

@end
