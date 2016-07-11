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
//        self.shareDict = [[NSMutableDictionary alloc]init];
//        self.shareDict[@"image"] = dic[@"url"];
//        self.shareDict[@"url"] = dic[@"url"];
        [self.barcodeImageView sd_setImageWithURL:url completed:nil];
        
    }];
    
    
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.zouyun8.com/a/article/2045901913/?no_title=1"]]];
    //self.webView.scalesPageToFit=YES;
    self.webview.delegate=self;

}

-(void)share
{
    [self getData1];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

 [webView stringByEvaluatingJavaScriptFromString:@"hide_something()"];
    
 JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"zywShare"] = ^() {};
}

#pragma mark - 分享红包前的请求
-(void)getData1
{
    
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"category"] = @"";//int	可选	分类id
    
    params[@"type"] = @"12";
    
    
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
                 [SVProgressHUD showSuccessWithStatus:@"分享失败"];
                 
                 break;
             }
             default:
                 break;
         }
     }
     ];
}


@end
