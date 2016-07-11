//
//  KKWebViewController.h
//  zouyun8
//
//  Created by 端正赵 on 16/7/7.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(strong,nonatomic)NSString *urlStr;
@property(strong,nonatomic)NSString *htmlStr;
@end
