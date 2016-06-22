//
//  InviteViewController.h
//  zouyun8
//
//  Created by 郑浩 on 16/5/28.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (nonatomic,strong)NSMutableDictionary * shareDict;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end
