#import "ADViewController.h"
@interface ADViewController ()<UIWebViewDelegate>

@end

@implementation ADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.tip;
    
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.url]]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    webView.hidden=YES;
    
    
    
    
    
}

#pragma mark - webview代理（网页加载完后调用）
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    BOOL success  =[webView stringByEvaluatingJavaScriptFromString:@"hide_something()"];
    
    if(success){
        
        [self performSelector:@selector(delayMethod:) withObject:webView afterDelay:0.1f];
        
    }

    
    
    NSString *str= [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title=str;
    
    //加载完毕，隐藏HUB
    [SVProgressHUD dismiss];
    //获取当前网页的上下文
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //@"settle_account"即为传给html端的方法名称，由后台判断是否接受到了方法，接收到后就返回json数据
    context[@"zywShare"] = ^()
    {
        
    };
    
    
    context[@"zyw_getUserInfo"] = ^() {
        
        
        
        
        NSArray *args = [JSContext currentArguments];
        JSValue * json = args[0];
        
        NSString *str;
        if (TOKEN) {
            
            str=[NSString stringWithFormat:@"%@,%@",UID,TOKEN];
            
            
            
            
            
        }else{
            
            
            if ([json.toString isEqualToString:@""]) {
                
                if (TOKEN==nil) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
                    
                }
                
            }else{
                
                
            }
            
            
            
        }
        return str;
        
    };
    
    
   
    context[@"zywShare"] = ^() {
        
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
                         //                         [self performSelectorOnMainThread:@selector(share_success) withObject:nil waitUntilDone:0];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         //主线程调用js返回alert，且不等待
                         //                         [self performSelectorOnMainThread:@selector(share_error) withObject:nil waitUntilDone:0];
                         break;
                     }
                     default:
                         break;
                 }
             }
             ];
        }
        
        
        
        
    };

    

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
    UIBarButtonItem *leftButtonItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_fanhuo"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToback)];
    UIBarButtonItem *fixBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar.width = -20;
    self.navigationItem.leftBarButtonItems = @[fixBar,leftButtonItem1];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    leftButtonItem1.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10)
        {
            [view removeFromSuperview];
        }
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
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

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    return NO;
}

-(void)delayMethod:(UIWebView *)webView{
    
    webView.hidden=NO;
}
@end
