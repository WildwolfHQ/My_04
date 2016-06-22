#import "InviteViewController.h"

@interface InviteViewController ()<UIWebViewDelegate>

@end

@implementation InviteViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem=barbtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"二维码";
    [ToolClass getQrcode:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"url"]]];
        self.shareDict = [[NSMutableDictionary alloc]init];
        self.shareDict[@"image"] = dic[@"url"];
        [self.barcodeImageView sd_setImageWithURL:url completed:nil];
        
    }];
    
    
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zy8.jf-q.com/a/article/2045901913/?no_title=1"]]];
    //self.webView.scalesPageToFit=YES;
    self.webview.delegate=self;

}

-(void)share
{
    [ToolClass share:self.shareDict];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

 [webView stringByEvaluatingJavaScriptFromString:@"hide_something()"];
    
 JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"zywShare"] = ^() {};
}
@end
