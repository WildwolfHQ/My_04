#import "ServiceViewController.h"

@interface ServiceViewController ()<UIWebViewDelegate>

@end

@implementation ServiceViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    self.title = @"走运客服";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zy8.jf-q.com/a/article/3753283592"]];
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
