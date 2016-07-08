//
//  KKWebViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/7/7.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "KKWebViewController.h"

@interface KKWebViewController ()<UIWebViewDelegate>

@end

@implementation KKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    self.webView.delegate=self;

    // Do any additional setup after loading the view from its nib.
}
-(void)goback{
    
    if ([_webView canGoBack]) {
        
        [_webView goBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *str= [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title=str;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
