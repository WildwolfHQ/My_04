#import "ToolClass.h"

@implementation ToolClass

+(BOOL)isUserLogined
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]) {
        return YES;
    }
    else
        return NO;
}

+(void)savePersonalImageUrl:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults]setObject:url forKey:@"icon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)saveUserInfo:(NSDictionary *)dict
{
    //保存用户token等用户信息,并同步
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"comm"] forKey:@"comm"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"exp"] forKey:@"exp"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"icon"] forKey:@"icon"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"token"] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"last_login"] forKey:@"last_login"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"level"] forKey:@"level"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"money"] forKey:@"money"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"nick"] forKey:@"nick"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"score"] forKey:@"score"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"type"] forKey:@"type"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"uid"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"username"] forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestClerk" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadData" object:nil];
}

+(void)saveUserInfo1:(NSDictionary *)dict
{
    //保存用户token等用户信息,并同步
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"comm"] forKey:@"comm"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"exp"] forKey:@"exp"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"icon"] forKey:@"icon"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"token"] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"last_login"] forKey:@"last_login"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"level"] forKey:@"level"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"money"] forKey:@"money"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"nick"] forKey:@"nick"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"score"] forKey:@"score"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"type"] forKey:@"type"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"uid"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"][@"username"] forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestClerk" object:nil];
    
}
+(BOOL)isNetConnect
{
    __block BOOL state;
    //AFNetworkReachabilityManager判断当前网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //告诉AFNetworkReachabilityManager对象,当网络状态发生变化时,如何操作
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusNotReachable)
         {
             //无网络时隐藏HUB,显示提示窗口
             [SVProgressHUD dismiss];
             
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无网络连接" message:@"请检查网络设置" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
             [alert show];
             
             //返回网络状态
             state = NO;
         }
         else if (status == AFNetworkReachabilityStatusReachableViaWWAN ||
                  status == AFNetworkReachabilityStatusReachableViaWiFi)
         {
             //返回网络状态
             state = YES;
             
             //有网络时刷新页面
         }
         else
         {
             NSLog(@"其他网络状态");
             state = NO;
         }
     }];
    //启动网络监听
    [manager startMonitoring];
    return state;
}

//获取用户资金和奖励信息
+(NSDictionary *)getPayInfo:(void (^)(NSDictionary * dic))cb
{
    __block NSDictionary * dict;
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
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             //获取用户账户成功
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//二次登录获取用户信息
+(NSDictionary *)getUserInfoSuccess:(void (^)(NSDictionary *))cb
{
    __block NSDictionary *dict;
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    [HttpRequest postWithURLString:TOKEN_LOGIN parameters:params success:^(id responseObject)
    {
        dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSNumber * errcode = dict[@"errcode"];
        if ([errcode integerValue]==0)
        {
            
            [ToolClass saveUserInfo1:dict];
            //[SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
        }else
        {
            //跳到登录界面
            [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
        }
        cb(dict);
    } failure:^(NSError *error) {
    }];
    return dict;
}

//上传购物车订单信息
+(NSDictionary *)create_bill:(void (^)(NSDictionary *))cb order:(NSString *)json addressID:(NSString *)address is_discount:(NSString * )discount payID:(NSString *)payID payType:(NSString *)pay_type rechargeMoney:(NSString *)money app:(NSString *)is_app{
    __block NSDictionary *dict;
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    params[@"data"]= json;
    params[@"address_id"] = address;
    params[@"pay_id"] = payID;
    params[@"discount"] = discount;
    params[@"pay_type"] = pay_type;
    params[@"recharge_money"] = money;
    
    NSLog(@"折扣订单%@",params);
    
    [HttpRequest postWithURLString:CREATE_BILL parameters:params success:^(id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
//             [SVProgressHUD showSuccessWithStatus:@"创建订单信息成功"];
         }
         cb(dict);
     } failure:^(NSError *error) {
     }];
    return dict;
}

//获取到（微信，银联）支付所需参数
+(NSDictionary *)getPayParameter:(void (^)(NSDictionary *))cb orderID:(NSString *)orderID payType:(NSString *)pay_type
{
    __block NSDictionary *dict;
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    params[@"id"] = orderID;
    params[@"pay_type"] = pay_type;
    params[@"app"]=@"1";
    [HttpRequest postWithURLString:START_PAY parameters:params success:^(id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             //[SVProgressHUD showSuccessWithStatus:@"支付成功"];
         }
         cb(dict);
     } failure:^(NSError *error) {
         
         
         
     }];
    return dict;
}

//获取最新中奖信息
+(NSDictionary *)getLucky_notice:(void (^)(NSDictionary *dic))cb
{
    __block NSDictionary *dict;
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    params[@"time"] = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] + 180];
    NSLog(@"当前时间戳为%@",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]);
    NSLog(@"获取最新中奖消息的参数为%@",params);
    [HttpRequest postWithURLString:LUCKY_NOTICE parameters:params success:^(id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         NSArray* array = dict[@"data"];
         for (NSDictionary * dict in array) {
             NSLog(@"中奖时间为-------%@",dict[@"run_time"]);
         }
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
//             [SVProgressHUD showSuccessWithStatus:@"获取中奖消息成功"];
         }
         cb(dict);
     } failure:^(NSError *error) {
     }];
    return dict;
}

//获取已经开奖消息
+(NSDictionary *)getAlreadyNotice:(void (^)(NSDictionary *dic))cb
{
    __block NSDictionary *dict;
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    params[@"time"] = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSLog(@"当前时间戳为%@",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]);
    NSLog(@"获取最新中奖消息的参数为%@",params);
    [HttpRequest postWithURLString:LUCKY_NOTICE parameters:params success:^(id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
         }
         else
         {
//             [SVProgressHUD showSuccessWithStatus:@"获取已开奖成功"];
         }
         cb(dict);
     } failure:^(NSError *error) {
     }];
    return dict;
}

//获取二维码图片
+(NSDictionary *)getQrcode:(void (^)(NSDictionary *dic))cb
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:QRCODE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取二维码地址成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//清空购物车
+(void)removeAllCart
{
    //1.从数据库中删除所有购物车数据
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
     BOOL success =  [db executeUpdate:@"DELETE FROM t_contact"];
    if (success) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeAllCart" object:nil];
    }else{
    
    }
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
    //2.通知购物车界面tableView清空
    
}

//二维码，商品详情分享
+(void)share:(NSDictionary *)dict
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

//商品搜索和分类界面数据
+(NSDictionary *)getSort:(void (^)(NSDictionary *dic))cb :(NSString *)strUrl
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"page"] = @"1";
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取分类信息成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

+(NSDictionary *)getSortDetail:(void (^)(NSDictionary *dic))cb minPrice:(NSString *)min maxPrice:(NSString *)max page:(NSString *)page name:(NSString *)name category:(NSString *)categoryID  urlStr:(NSString *)urlStr
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"category"] = categoryID;
    parameters[@"name"] = name;
    parameters[@"page"] = page;
    parameters[@"max_price"] = max;
    parameters[@"min_price"] = min;
    
    NSLog(@"------%@",parameters);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取分类详情信息成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

+(NSDictionary *)getRank:(void (^)(NSDictionary *dic))cb minPrice:(NSString *)min maxPrice:(NSString *)max page:(NSString *)page name:(NSString *)name category:(NSString *)category top:(NSString *)top type:(NSString *)type
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"category"] = category;
    parameters[@"name"] = name;
    parameters[@"page"] = page;
    parameters[@"max_price"] = max;
    parameters[@"min_price"] = min;
    parameters[@"top"] = top;
    parameters[@"type"] = type;
    NSLog(@"请求参数的排序商品为%@",parameters);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:LUCKY_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取商品排序成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

+(NSDictionary *)getNewsList:(void (^)(NSDictionary *dic))cb ID:(NSString *)category_id
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"category_id"] = category_id;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:@"https://m.zouyun8.com/api/news_list" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取信息成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

+(NSDictionary *)getMoney_log:(void (^)(NSDictionary *dic))cb type:(NSString *)type
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    parameters[@"type"] = type;

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:MONEY_LOG parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取明细信息成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//获取公开的合购
+(NSDictionary *)getPub_lucky:(void (^)(NSDictionary *dic))cb page:(NSString *)page
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"page"] = page;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:PUB_LUCKY parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取合购公开商品成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//获取网友晒单
+(NSDictionary *)getEvaluate_all_list:(void (^)(NSDictionary *dic))cb page:(NSString *)page
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"page"] = page;
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:EVALUATE_ALL_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取网友晒单成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//获取佣金明细
+(NSDictionary *)getComm_log:(void (^)(NSDictionary *dic))cb page:(NSString *)page
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"page"] = page;
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:COMM_LOG parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取佣金明细成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//获取奖金明细
+(NSDictionary *)getScore_log:(void (^)(NSDictionary *dic))cb page:(NSString *)page
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"page"] = page;
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:SCORE_LOG parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取奖金明细成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//获取我的订单
+(NSDictionary *)getMyBill:(void (^)(NSDictionary *dic))cb page:(NSString *)page
{
    __block NSDictionary * dict;
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"page"] = page;
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:MYBILL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取我的订单成功");
         }
         cb(dict);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    return dict;
}

//删除收货地址
+(NSDictionary *)DelegateAddress_del:(void (^)(NSDictionary *dic))cb ID:(NSString *)addressID
{
    __block NSDictionary *dict;
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    params[@"id"] = addressID;
    
    [HttpRequest postWithURLString:@"https://m.zouyun8.com/api/address_del/" parameters:params success:^(id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             //            [SVProgressHUD showSuccessWithStatus:@"获取用户信息成功"];
             //保存用户token等用户信息,并同步
             //            [ToolClass saveUserInfo:dict];
             //跳转到根视图,并加载个人信息
         }
         cb(dict);
     } failure:^(NSError *error) {
     }];
    return dict;
}
//编辑收货地址（将选中的地址设置为默认）
+(NSDictionary *)SetDefaultAddress:(void (^)(NSDictionary *dic))cb addressModel:(AddrDataModel *)model
{
    __block NSDictionary *dict;
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
//    params[@"mobile"] = model.phone;
//    params[@"name"] = model.name;
//    params[@"province"] = model.province;
//    params[@"city"] = model.city;
//    params[@"town"] = model.town;
//    params[@"detail"] = model.detail;
    params[@"default"] = @"1";
    params[@"id"] = model.ID;
    
    [HttpRequest postWithURLString:@"https://m.zouyun8.com/api/address_edit" parameters:params success:^(id responseObject)
     {
         dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         cb(dict);
         
     } failure:^(NSError *error) {
         //cb(dict);
     }];
    return dict;
}
@end
