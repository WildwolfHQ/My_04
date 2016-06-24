//
//  GoodsWebViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/8.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "GoodsWebViewController.h"
#import "DirectSettleViewController.h"
@interface GoodsWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GoodsWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    
    for (UIImageView * view in self.navigationController.navigationBar.subviews) {
        
        
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.shareDict!=nil) {
        UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        self.navigationItem.rightBarButtonItem=barbtn;

    }
    
//    if (self.titleName!=nil) {
//        self.title=self.titleName;
//        
//    }else{
//    
//   
//        self.navigationItem.title=@"商品详情";
//    }
    
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName: [UIColor redColor],
                                                        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    UIBarButtonItem *fixBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar.width = -20;
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_fanhuo"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    //self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.navigationItem.leftBarButtonItems = @[fixBar,leftButtonItem];

     NSString *urlStr;
    if (self.lucky_id!=nil) {
        urlStr=[NSString stringWithFormat:@"http://m.zouyun8.com/l/v/%@",self.lucky_id];
        
         //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    }
    
    if (self.bid_id!=nil) {
        urlStr=[NSString stringWithFormat:@"http://m.zouyun8.com/b/v/%@",self.bid_id];
        //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    }
    
    if (self.urlStr!=nil) {
        urlStr=self.urlStr;
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    //self.webView.scalesPageToFit=YES;
    self.webView.delegate=self;
  
    // Do any additional setup after loading the view from its nib.
}

-(void)share
{
    if (self.shareDict!=nil) {
        [ToolClass share:self.shareDict];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//   
//
//    return YES;
//
//}
-(void)goback{
    
    if ([_webView canGoBack]) {
        
        [_webView goBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }


}




- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//
//    if ([self.guanggao isEqualToString:@"1"]) {
//        NSString *str= [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        self.title=str;
//        
//        
//    }
    NSString *str= [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title=str;
    
    //@"settle_account"即为传给html端的方法名称，由后台判断是否接受到了方法，接收到后就返回json数据
    
    
    [webView stringByEvaluatingJavaScriptFromString:@"hide_something()"];
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //是否隐藏网页的导航栏或好友邀请
    context[@"zywShare"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        //创建要分享的参数
        NSString * desc = [[NSString alloc]init];
        NSString * image = [[NSString alloc]init];
        NSString * url = [[NSString alloc]init];
        NSString * title = [[NSString alloc]init];
        for (int i = 0; i < 4; i++)
        {
            JSValue * jsval = args[i];
            if (i == 0) {
                url = jsval.toString;
            }
            else if (i == 1)
            {
                desc = jsval.toString;
            }
            else if (i == 2)
            {
                title = jsval.toString;
            }
            else if (i == 3)
            {
                image = jsval.toString;
            }
        }
        NSString * weiboDesc = [desc stringByAppendingString:url];
        
        //调用shareSdk分享
        //1、创建分享参数
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (1)
        {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            
            [shareParams SSDKSetupShareParamsByText:desc
                                             images:@[image]
                                                url:[NSURL URLWithString:url]
                                              title:title
                                               type:SSDKContentTypeAuto];
            
            [shareParams SSDKSetupSinaWeiboShareParamsByText:weiboDesc title:title image:@[image] url:[NSURL URLWithString:url] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
            
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
                         //主线程调用js返回alert，且不等待
//                         [self performSelectorOnMainThread:@selector(share_success) withObject:nil waitUntilDone:0];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         //主线程调用js返回alert，且不等待
//                         [self performSelectorOnMainThread:@selector(share_error) withObject:nil waitUntilDone:0];
                         break;
                     }
                     default:
                         break;
                 }
             }
             ];
        }
        
        
        
        
    };
    
    
    
    
    //我是土豪
    context[@"zyw_lucky_buy"] = ^() {
        
        
        
        NSString * type = TYPE;
        if ([type integerValue] == 2) {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"尊敬的试购员，您只能发起合购并邀请好友参与，不能参与他人的合购！" preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                
                
            }];
            
            
            
            
            
            [alertController addAction:okAction];
            
            
            //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
            if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
                
            {
                
                
                [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
                
                
            }
            
            
            
            
        }else{
        
        //获取后台返回的数据
        NSArray *args = [JSContext currentArguments];
        JSValue * json = args[0];
        NSLog(@"----------%@",json.toString);
        if(json.toDictionary)
        {
            
            if (TOKEN) {
                
                DirectSettleViewController * direct = [[DirectSettleViewController alloc]init];
                
                direct.dic =json.toDictionary;
                
                //direct.is_tabBarHidden=YES;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:direct animated:YES];
              
                
            }else{
            
                if (TOKEN==nil) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
                    
                }

            }
           
            
            
            
            
            
            
        }
        }
    };
    
    //网友合购
    context[@"zyw_getUserInfo"] = ^() {
        
       
        
        
        NSArray *args = [JSContext currentArguments];
        JSValue * json = args[0];
        
        NSString *str;
        if (TOKEN) {
            
            str=[NSString stringWithFormat:@"%@,%@",UID,TOKEN];
            
            
            

            
        }else{
        
            
            if ([json.toString isEqualToString:@""]) {
                
                if (TOKEN==nil) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
                    
                }

            }else{
                
                
            }
            
           
        
        }
        return str;
        
    };
    
    //选择价格
    
    
    
    

    
    
    //立即购买
    context[@"zyw_bid_buy"] = ^() {
        //获取后台返回的数据
        NSArray *args = [JSContext currentArguments];
        JSValue * json = args[0];
        NSLog(@"----------%@",json.toString);
        if(json.toDictionary)
        {
            
            
            
            NSDictionary * dict1 = json.toDictionary;
            
            PGXiangGing *pgXiangGing_model= [[PGXiangGing alloc]initWithDictionary:dict1 error:nil];
            
            pgXiangGing_model.buy_num=@"1";
            FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
            // 打开数据库
            [db open];
            //当前程序数据库是否有数据
            NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
            //插入购物车所需的cell数据到数据库
            NSLog(@"当前的token%@",TOKEN);
            if(TOKEN)
            {
                
                
                if(count == 0)
                {
                    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
                    
                    item.badgeValue = [NSString stringWithFormat:@"%d",1];
                    
                    NSLog(@"增加当前cell数据");
                    [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",pgXiangGing_model.buy_num,pgXiangGing_model.goods_id,nil,pgXiangGing_model.money,pgXiangGing_model.name,pgXiangGing_model.select_price,pgXiangGing_model.thumb,pgXiangGing_model.times,pgXiangGing_model.total_num,pgXiangGing_model.type,pgXiangGing_model.user_id,pgXiangGing_model.buy_num,pgXiangGing_model.bid_id,pgXiangGing_model.buy_user_num,pgXiangGing_model.start_time,pgXiangGing_model.end_time,pgXiangGing_model.price_level];
                }
                else
                {
                    //            FMResultSet *result =  [db executeQuery:@"select * from t_contact where goods_id=? and bid_id＝?;",self.pgXiangGing_model.goods_id,self.pgXiangGing_model.bid_id];
                    
                    FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
                    BOOL flag = NO;
                    
                    while ([result next])
                    {
                        
                        
                        
                        
                        if([[result stringForColumn:@"bid_id"] isEqualToString:pgXiangGing_model.bid_id] && [[result stringForColumn:@"goods_id"] isEqualToString:pgXiangGing_model.goods_id ])
                        {
                            NSLog(@"商品重复了");
                            NSString * num = [result stringForColumn:@"num"];
                            
                            NSInteger count = [num integerValue];
                            
                            
                            count = count + pgXiangGing_model.buy_num.integerValue;
                            
                            
                            [db executeUpdate:@"UPDATE t_contact SET num = ? where goods_id = ? and bid_id = ?;", [NSString stringWithFormat:@"%ld",(long)count], pgXiangGing_model.goods_id,pgXiangGing_model.bid_id];
                            
                            
                            
                            
                            
                            flag = YES;
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    if(flag == NO)
                        
                    {
                        UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
                        item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
                        NSLog(@"还没有");
                        [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",pgXiangGing_model.buy_num,pgXiangGing_model.goods_id,nil,pgXiangGing_model.money,pgXiangGing_model.name,pgXiangGing_model.select_price,pgXiangGing_model.thumb,pgXiangGing_model.times,pgXiangGing_model.total_num,pgXiangGing_model.type,pgXiangGing_model.user_id,pgXiangGing_model.buy_num,pgXiangGing_model.bid_id,pgXiangGing_model.buy_user_num,pgXiangGing_model.start_time,pgXiangGing_model.end_time,pgXiangGing_model.price_level];
                        
                    }
                }
                
                //停止加载不然跳转时可能会线程死掉
                self.webView.delegate = nil;
                [self.webView stopLoading];

                
                
                ShoppingcartViewController *vc=[[ShoppingcartViewController alloc]init];
                
                vc.is_tabBarHidden=YES;
                 self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
                
                
            }else{
                
                //TIPS;
                if (TOKEN==nil) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
                }
            }
            
            
            
            
            
            
        }
    };
    
    
    
    
   


}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//
//    //获取当前网页的上下文
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    
//    context[@"zywShare"] = ^() {
//        
//        
//        
//        
//        
//        
//    };
    

  
        

   
    

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{



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
