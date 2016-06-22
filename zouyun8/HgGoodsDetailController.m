#import "HgGoodsDetailController.h"
#import "DirectSettleViewController.h"
@interface HgGoodsDetailController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSMutableArray * orders;
@property(nonatomic,copy)NSString * json;
@end

@implementation HgGoodsDetailController

//手势方法
-(void)swipe:(UISwipeGestureRecognizer *)g{
    if (g.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右滑了");
        [self.webView goBack];
    } else {
        [self.webView goForward];
        NSLog(@"向左滑了");
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *leftButtonItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_fanhuo"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToback)];
    UIBarButtonItem *fixBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar.width = -20;
    self.navigationItem.leftBarButtonItems = @[fixBar,leftButtonItem1];
    
    //self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    //leftButtonItem1.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10)
        {
            [view removeFromSuperview];
        }
    }
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
}

-(void)pushToback
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商品详情";
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.url]]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    //添加手势
    UISwipeGestureRecognizer  *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.delegate = self;
    [self.webView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.delegate = self;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.webView addGestureRecognizer:swipeLeft];
    
    self.webView.delegate = self; //可以获取网页是否加载完毕,是否准备跳转
    self.webView.scrollView.bounces = NO;
}
#pragma mark - webview代理（网页加载完后调用）
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //加载完毕，隐藏HUB
    [SVProgressHUD dismiss];
    //获取当前网页的上下文
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //@"settle_account"即为传给html端的方法名称，由后台判断是否接受到了方法，接收到后就返回json数据
    context[@"zywShare"] = ^()
    {
        NSArray *args = [JSContext currentArguments];
        //创建要分享的参数
        NSString * desc = [[NSString alloc]init];
        NSString * image = [[NSString alloc]init];
        NSString * url = [[NSString alloc]init];
        NSString * title = [[NSString alloc]init];
        for (int i = 0; i < 4; i++)
        {
            JSValue * jsval = args[i];
            if (i == 0) {
                url = jsval.toString;
            }
            else if (i == 1)
            {
                desc = jsval.toString;
            }
            else if (i == 2)
            {
                title = jsval.toString;
            }
            else if (i == 3)
            {
                image = jsval.toString;
            }
        }
        NSString * weiboDesc = [desc stringByAppendingString:url];
        
        //调用shareSdk分享
        //1、创建分享参数
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (1)
        {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            
            [shareParams SSDKSetupShareParamsByText:desc
                                             images:@[image]
                                                url:[NSURL URLWithString:url]
                                              title:title
                                               type:SSDKContentTypeAuto];
            
            [shareParams SSDKSetupSinaWeiboShareParamsByText:weiboDesc title:title image:@[image] url:[NSURL URLWithString:url] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
            
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
                         //主线程调用js返回alert，且不等待
                         [self performSelectorOnMainThread:@selector(share_success) withObject:nil waitUntilDone:0];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         //主线程调用js返回alert，且不等待
                         [self performSelectorOnMainThread:@selector(share_error) withObject:nil waitUntilDone:0];
                         break;
                     }
                     default:
                         break;
                 }
             }
             ];
        }
    };
    context[@"zyw_lucky_buy"] = ^()
    {
        NSArray *args = [JSContext currentArguments];
        JSValue * json = args[0];
        NSLog(@"----------%@",json.toDictionary);
        if(json.toDictionary)
        {
            if (!TOKEN)
            {
                LoginViewController * login = [[LoginViewController alloc]init];
                UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:login];
                [self presentViewController:nvc animated:YES completion:nil];
            }
            else
            {
                [self getData:json.toDictionary];
            }
        }
    };
}

-(void)getData:(NSDictionary *)order
{
    self.orders = [[NSMutableArray alloc]init];
    [self.orders addObject:order];
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
             if (dict[@"data"] == NULL)
             {
                 [SVProgressHUD showErrorWithStatus:@"您已购买过此商品"];
             }
             else
             {
                 DirectSettleViewController * direct = [[DirectSettleViewController alloc]init];
                 direct.dic =order;
                 self.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:direct animated:YES];
                 self.hidesBottomBarWhenPushed = YES;
             }
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
         }];
    }
}


#pragma mark - 分享后回调js方法
-(void)share_success
{
    NSLog(@"分享成功");
    [_webView stringByEvaluatingJavaScriptFromString:@"share_success()"];
}
-(void)share_error
{
    NSLog(@"分享失败");
    [_webView stringByEvaluatingJavaScriptFromString:@"share_error()"];
}
-(void)pay_success
{
    NSLog(@"支付成功");
    [_webView stringByEvaluatingJavaScriptFromString:@"pay_success()"];
}
-(void)pay_Failed
{
    NSLog(@"支付失败");
    [_webView stringByEvaluatingJavaScriptFromString:@"pay_error()"];
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    return NO;
}

@end
