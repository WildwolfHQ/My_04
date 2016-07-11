#import "AppDelegate.h"
#import "UPPaymentControl.h"
#import "BuyTogetherController.h"
@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>

@property(nonatomic,strong)UITabBarController * tabBar;
@property(nonatomic,strong)PGViewController *PGvc;
@property(nonatomic,strong)FirstViewController *Fvc;
@property(nonatomic,strong)UINavigationController *NFvc;
@property(nonatomic,strong)AnnounceViewController *Avc;
@property(nonatomic,strong)UINavigationController *NAvc;
@property(nonatomic,strong)FindViewController *Findvc;
@property(nonatomic,strong)UINavigationController *NFindvc;
@property(nonatomic,strong)ShoppingcartViewController *Svc;
@property(nonatomic,strong)UINavigationController *NSvc;
@property(nonatomic,strong)MyViewController *Mvc;
@property(nonatomic,strong)UINavigationController *NMvc;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)BuyTogetherController *Buyvc;
@property(nonatomic,strong)UINavigationController *NBuyvc;

@property(nonatomic,strong)NSArray * viewControllers;

@end

@implementation AppDelegate

-(void)changeTabBar
{
    NSLog(@"接受到通知");

    self.tabBar.selectedIndex = 0;
    self.tabBar.viewControllers = self.viewControllers;
    self.window.rootViewController = self.tabBar;
    
   
//    [self initTabBarController];
}
-(void)directLogin
{
  
    LoginViewController * login = [[LoginViewController alloc]init];
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController = nvc;
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"改动测试");
    
    self.tabBar = [[UITabBarController alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTabBar) name:@"changeTabBar" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(directLogin) name:@"directLogin" object:nil];
    
    //接受登录成功或者取消登录后的通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(changeRootViewController) name:@"changeRootViewController" object:nil];
    
    // 创建一个数据库的实例,仅仅在创建一个实例，并会打开数据库
    [self createDataBase];

    //创建标签栏
    [self initTabBarController];
    
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]delegate:self];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1587287296"
                                           appSecret:@"8a675d2f7f5c0b4161603cebecd42cee"
                                         redirectUri:@"http://m.zouyun8.com/"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx984e14a9cba9dd63"
                                       appSecret:@"fbd2cabf8df20454e3e186fe7ca569e3"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105162516"
                                      appKey:@"XuXErNhVXKYYlogg"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    //向微信注册
    [WXApi registerApp:@"wx984e14a9cba9dd63" withDescription:@"demo 2.0"];
    
    return YES;
}
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                //创建通知回调后台支付成功方法
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixinPaySuccessNotice" object:self];
                break;
                
            case WXErrCodeUserCancel:
                strMsg = @"取消交易";
               
                 [SVProgressHUD showErrorWithStatus:strMsg];
                break;
            case WXErrCodeSentFail:
                strMsg = @"发送失败";
               
                [SVProgressHUD showErrorWithStatus:strMsg];
                break;
            case WXErrCodeAuthDeny:
                strMsg = @"授权失败";
                
                [SVProgressHUD showErrorWithStatus:strMsg];
                break;
            case WXErrCodeUnsupport:
                strMsg = @"微信不支持";
                
                [SVProgressHUD showErrorWithStatus:strMsg];
                break;
            case WXErrCodeCommon:
                strMsg = @"普通错误类型";
                
                [SVProgressHUD showErrorWithStatus:strMsg];
                break;
            default:

                break;
        }
    }
}
//当用户通过其他应用启动本应用时，回调这个方法，url参数是其他应用调用openurl方法传递过来的
- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options

{
    
    //银联回调
    if ([url.host rangeOfString:@"uppayresult"].location != NSNotFound) {
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //            //判断签名数据是否存在
                //            if(data == nil){
                //                //如果没有签名数据，建议商户app后台查询交易结果
                //                return;
                //            }
                
                //发个请求看后台是否收到钱
                [[NSNotificationCenter defaultCenter] postNotificationName:@"unionPaySuccess" object:self];
                
                
                
                
                //            //数据从NSDictionary转换为NSString
                //            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                //                                                               options:0
                //                                                                 error:nil];
                //            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                //
                //
                //
                //            //验签证书同后台验签证书
                //            //此处的verify，商户需送去商户后台做验签
                //            if([self verify:sign]) {
                //                //支付成功且验签成功，展示支付成功提示
                //            }
                //            else {
                //                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                //            }
            }
            else if([code isEqualToString:@"fail"]) {
                
                //交易失败
                [SVProgressHUD showErrorWithStatus:@"交易失败"];
                
                
                
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                [SVProgressHUD showErrorWithStatus:@"交易取消"];
            }
        }];
        
        return YES;

        
    }else{
     return [WXApi handleOpenURL:url delegate:self];
    
    }
    
    
}





-(void)createDataBase
{
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    NSLog(@"数据库%@",DBFATH);
    // 打开数据库
    BOOL flag = [db open];
    if (flag) {
        NSLog(@"打开成功");
    }
    else
    {
        NSLog(@"打开失败");
    }
    
    // 创建数据库表
    // 数据库操作：插入，更新，删除都属于update
    // 参数：sqlite语句
    BOOL flag1 = [db executeUpdate:@"create table if not exists t_contact (id integer primary key autoincrement,bid_id text,buy_user_num text,start_time text,end_time text,buy_num text,goods_id text,lucky_id text,money text,name text,price text,thumb text,times text,total_num text,type text,user_id text,num text,price_level text);"];
    if (flag1) {
        NSLog(@"创建成功");
    }else{
        NSLog(@"创建失败lelele");
    }
    
    NSLog(@"改变角标");
    NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
    self.count = count;
}

-(void)initTabBarController{
    
    
    [UINavigationBar appearance].tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    //去掉返回按钮后面的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].titleTextAttributes= @{NSForegroundColorAttributeName: [UIColor redColor],
                                                        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    
    self.PGvc = [[PGViewController alloc]init];
    self.Fvc = [[FirstViewController alloc]init];
    self.NFvc = [[UINavigationController alloc]initWithRootViewController:self.Fvc];
    self.NFvc.tabBarItem.title=@"首页";
   
   
    
    
    
    
    self.NFvc.tabBarItem.image = [[UIImage imageNamed:@"首页-灰色.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.NFvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页-主色.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    self.Avc = [[AnnounceViewController alloc]init];
//    self.NAvc = [[UINavigationController alloc]initWithRootViewController:self.Avc];
//    self.NAvc.tabBarItem.title = @"揭晓";
//    self.NAvc.tabBarItem.image = [[UIImage imageNamed:@"揭晓-灰色.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.NAvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"揭晓-主色.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.Findvc= [[FindViewController alloc]init];
    self.NFindvc = [[UINavigationController alloc]initWithRootViewController:self.Findvc];
    self.NFindvc.tabBarItem.title = @"发现";
    

    
    
    self.NFindvc.tabBarItem.image = [[UIImage imageNamed:@"发现-灰色.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.NFindvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"发现-主色.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    self.Buyvc = [[BuyTogetherController alloc]init];
    self.Buyvc.is_gongkai=YES;
    
    self.NBuyvc = [[UINavigationController alloc]initWithRootViewController:self.Buyvc];
    self.NBuyvc.tabBarItem.title=@"公开区";

    self.NBuyvc.tabBarItem.image = [[UIImage imageNamed:@"_60x60_gray"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.NBuyvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"_60x60_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    
    
    self.Svc = [[ShoppingcartViewController alloc]init];
    self.NSvc = [[UINavigationController alloc]initWithRootViewController:self.Svc];
    self.NSvc.tabBarItem.title = @"购物车";
   
    
    
   
    self.NSvc.tabBarItem.image = [[UIImage imageNamed:@"购物车-灰色.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.NSvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"购物车-主色.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.Mvc = [[MyViewController alloc]init];
    self.NMvc = [[UINavigationController alloc]initWithRootViewController:self.Mvc];
    self.NMvc.tabBarItem.title=@"我的";
   

    
    self.NMvc.tabBarItem.image = [[UIImage imageNamed:@"我-灰色.jpg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.NMvc.tabBarItem.selectedImage = [[UIImage imageNamed:@"我-主色.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  
    
    self.viewControllers = [NSArray arrayWithObjects:self.NFvc,self.NFindvc,self.NBuyvc,self.NSvc,self.NMvc,nil];
    self.tabBar.viewControllers = self.viewControllers;
    self.tabBar.tabBar.tintColor = [UIColor redColor];
    self.tabBar.tabBar.translucent = NO;
    self.tabBar.delegate = self;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBar;
    [self.window makeKeyWindow];
    
    UITabBarItem * item = [self.tabBar.tabBar.items objectAtIndex:3];
    //改变购物车角标
    if (self.count == 0)
    {
        item.badgeValue = nil;
    }
    else
    {
        item.badgeValue = [NSString stringWithFormat:@"%ld",self.count];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"--tabbaritem.title--%@",viewController.tabBarItem.title);
    if ([viewController.tabBarItem.title isEqualToString:@"我的"])
    {
        if ([ToolClass isUserLogined])//如果用户token存在的话，说明之前登录过，不跳转
        {
            
        }
        else//跳转到登录界面
        {
            LoginViewController * login = [[LoginViewController alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:login];
            self.window.rootViewController = nvc;
        }
    }
    return YES;
}

#pragma mark - 更换rootViewController
-(void)changeRootViewController
{
    self.window.rootViewController = self.tabBar;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
