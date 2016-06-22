//
//  GraphicDetailsViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/5/30.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "GraphicDetailsViewController.h"

@interface GraphicDetailsViewController ()

@end

@implementation GraphicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    //self.webView.frame=CGRectMake(0, 0, WIDTH, self.view.bounds.size.height);
    NSString *str;
    if (self.hg_XiangGingmodel.content!=nil) {
        str=self.hg_XiangGingmodel.content;
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
        //去掉返回按钮后面的文字
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
        
    }else if(self.pgXiangGingmodel.content!=nil){
        str=self.pgXiangGingmodel.content;
        //左边buttonBarItem
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_fanhuo"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToSort)];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    }
 
    //[self.webView loadRequest:nil];
    [self.webView loadHTMLString:str baseURL:nil];
    self.webView.scalesPageToFit=YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushToSort{
    
    [self.navigationController popViewControllerAnimated:YES];
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
