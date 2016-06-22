//
//  GraphicDetailsViewController.h
//  zouyun8
//
//  Created by 端正赵 on 16/5/30.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGXiangGing.h"
#import "HG_XiangGing.h"
@interface GraphicDetailsViewController : UIViewController
@property (strong,nonatomic) PGXiangGing *pgXiangGingmodel;
@property (strong,nonatomic) HG_XiangGing *hg_XiangGingmodel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
