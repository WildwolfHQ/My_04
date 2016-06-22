#import "MyMessageViewController.h"

@interface MyMessageViewController ()<UIWebViewDelegate>

@end

@implementation MyMessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    self.title = @"系统消息";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉返回按钮后面的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zy8.jf-q.com/a/cate/1139700195/"]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
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
    };
}

@end
