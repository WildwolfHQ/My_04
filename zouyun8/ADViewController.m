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
#pragma mark - webview代理（网页加载完后调用）
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str= [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title=str;
    
    //加载完毕，隐藏HUB
    [SVProgressHUD dismiss];
    //获取当前网页的上下文
     [webView stringByEvaluatingJavaScriptFromString:@"hide_something()"];
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //@"settle_account"即为传给html端的方法名称，由后台判断是否接受到了方法，接收到后就返回json数据
    context[@"zywShare"] = ^()
    {
        
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

@end
