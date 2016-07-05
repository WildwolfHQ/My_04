#import "MyMessageViewController.h"

@interface MyMessageViewController ()<UIWebViewDelegate>

@end

@implementation MyMessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉返回按钮后面的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
   
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.zouyun8.com/a/cate/1139700195/"]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
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

    
    //    //获取当前网页的上下文
    //    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    //@"settle_account"即为传给html端的方法名称，由后台判断是否接受到了方法，接收到后就返回json数据
    //    context[@"zywShare"] = ^()
    //    {
    //    };
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    webView.hidden=YES;
    
    
    
    
    
}
-(void)delayMethod:(UIWebView *)webView{
    
    webView.hidden=NO;
}

@end
