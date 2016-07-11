#import "ShoppingcartViewController.h"
#import "shoppingcartModel.h"
#import "MyTableView.h"
#import "GoodsWebViewController.h"
#import "OTPageScrollView.h"
#import "OTPageView.h"
#import "BuyTogetherModel.h"
@interface ShoppingcartViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,tableViewCellDelegate,OTPageScrollViewDataSource,OTPageScrollViewDelegate>{

 
}

@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)MyTableView * tableView;
@property(nonatomic,strong)accountView * accountview;
@property(nonatomic,assign)NSInteger totalPrice;
@property(nonatomic,strong)NSMutableArray * orders;
@property(nonatomic,strong)NSMutableArray * otdataSource;
@property(nonatomic,strong)OTPageView *PScrollView;
@property(nonatomic,strong)OTPageView *myview;
@end

@implementation ShoppingcartViewController

#pragma mark - 视图即将显示时 从数据库重新获取数据 刷新购物车
-(void)viewWillAppear:(BOOL)animated
{
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10)
        {
            [view removeFromSuperview];
        }
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    
//    self.tabBarController.tabBar.hidden = NO;
    //从数据库获取商品订单信息
    [self getOrders];
    //从服务器获取到最新订单信息
    [self getCartData];
    //发送通知改变商品件数
    if (self.dataSource.count!=0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAccount" object:nil userInfo:@{@"key":@(self.dataSource.count)}];

    }
       //接受结算按钮点击事件的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(settleAccounts:) name:@"settleAccounts" object:nil];
    //接受清空购物车的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAllCart:) name:@"removeAllCart" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushtoroot) name:@"pushtoroot" object:nil];

    
}
-(void)pushtoroot{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    NSLog(@"点击了");
}
-(void)viewDidDisappear:(BOOL)animated
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"settleAccounts" object:nil];
}

//去结算
-(void)settleAccounts:(NSNotification *)info
{
    
    [self ios_web_pay];
    
    
}

-(void)ios_web_pay{
    
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:@"https://m.zouyun8.com/api/ios_web_pay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSNumber *errcode=dict[@"errcode"];
         if (errcode.integerValue==0) {
             NSNumber *code=dict[@"code"];
             if (code.integerValue==0) {
                 
                 shoppingcartModel  * model = self.dataSource[0];
                 if (self.is_tuhao) {
                     SettleAccountsViewController * settle = [[SettleAccountsViewController alloc]init];
                     settle.model=model;
                     self.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:settle animated:YES];
                     
                 }else{
                     SettleAccountsViewController * settle = [[SettleAccountsViewController alloc]init];
                     settle.model=model;
                     self.hidesBottomBarWhenPushed = YES;
                     [self.navigationController pushViewController:settle animated:YES];
                     self.hidesBottomBarWhenPushed = NO;
                 }

             }else{
                 [self removeAllCart:nil];
                 
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.zouyun8.com/pay/orderinfo/?uid=%@&token=%@",UID,TOKEN ]]];
             }
          
             
         }else{
             
             
         }
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    
    
    
    
    
}

-(void)removeAllCart:(NSNotification *)info
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    BOOL success =  [db executeUpdate:@"DELETE FROM t_contact"];
    if (success) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        //清空角标
        UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
        item.badgeValue = nil;

    }
}

-(void)getOrders
{
    self.orders = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
    // 从结果集里面往下找
    
    while ([result next])
    {
        shoppingcartModel * model = [[shoppingcartModel alloc]init];
        model.lucky_id = [result stringForColumn:@"lucky_id"];
        model.bid_id = [result stringForColumn:@"bid_id"];
        model.type = [result stringForColumn:@"type"];
        model.num = [result stringForColumn:@"num"];
         model.price_level = [result stringForColumn:@"price_level"];
        //将model的商品信息，token,uid封装为json数据
        NSDictionary * dic;
        if (model.lucky_id.length!=0&&model.type!=nil)
        {
             dic = @{@"id":model.lucky_id,@"type":model.type,@"num":model.num};
        }
        
        if (model.bid_id.length!=0)
        {
            model.type=@"2";
//            model.price_level=@"1";
             dic = @{@"id":model.bid_id,@"type":model.type,@"num":model.num,@"price_level":model.price_level};
        }
        if (dic!=nil) {
            [self.orders addObject:dic];
            
        }else{
        
//            FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
//            // 打开数据库
//            [db open];
//           [db executeUpdate:@"DELETE FROM t_contact"];
        }
        
    }
}
#pragma mark - 懒加载dataSource
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(NSMutableArray *)otdataSource
{
    if (_otdataSource == nil) {
        _otdataSource = [[NSMutableArray alloc]init];
    }
    return _otdataSource;
}

- (void)viewDidLoad {
        [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
        self.tableView = [[MyTableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-50) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        /* STEP5:去掉TableView中的默认横线 */
        self.tableView.tableFooterView = [UIView new];

    
        [self loadOT];
        [self.view addSubview:self.tableView];
    
    
        _myview = [[NSBundle mainBundle]loadNibNamed:@"ShoppingcartViewNull" owner:self options:nil].firstObject;
        _myview.frame = CGRectMake(0, 0, WIDTH, HEIGHT-(44+200));
    
        [self.view addSubview:_myview];
    
    


//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    self.title = @"购物车";
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"shoppingcarCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
}

-(void)loadOT{
    [self getData:nil andTop:nil];
    
    
    if (self.is_tabBarHidden == YES){
        
        self.PScrollView = [[OTPageView alloc] initWithFrame:CGRectMake(0, HEIGHT-(155), WIDTH, 155)];
    
    }else{
    
        self.PScrollView = [[OTPageView alloc] initWithFrame:CGRectMake(0, HEIGHT-(155+44), WIDTH, 155)];
    }
    
    UILabel *titlelable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    
    titlelable.text=@"猜你喜欢";
    [self.PScrollView addSubview:titlelable];
    
    self.PScrollView.pageScrollView.dataSource = self;
    self.PScrollView.pageScrollView.delegate = self;
    self.PScrollView.pageScrollView.padding =0;
    self.PScrollView.pageScrollView.leftRightOffset = 0;
    self.PScrollView.pageScrollView.frame = CGRectMake(0, titlelable.frame.origin.y+titlelable.frame.size.height-55, 100, 100);
    self.PScrollView.backgroundColor = [UIColor whiteColor];
  
    [self.view addSubview:self.PScrollView];
    
   

}

#pragma mark - 猜你喜欢view的代理
- (NSInteger)numberOfPageInPageScrollView:(OTPageScrollView*)pageScrollView{
    return [self.otdataSource count];
}

- (UIView*)pageScrollView:(OTPageScrollView*)pageScrollView viewForRowAtIndex:(int)index{
    
    BuyTogetherModel * model=self.otdataSource[index];
    UIImageView *cell = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [cell sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    return cell;
}

- (CGSize)sizeCellForPageScrollView:(OTPageScrollView*)pageScrollView
{
    return CGSizeMake(100, 100);
}

- (void)pageScrollView:(OTPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    
    BuyTogetherModel * model=self.otdataSource[index];
    NSString * url = [NSString stringWithFormat:@"http://m.zouyun8.com/l/v/%@/?uid=%@&token=%@",model.ID,UID,TOKEN];
    
    GoodsWebViewController * VC = [[GoodsWebViewController alloc]init];
    
    VC.urlStr = url;
    
    
    if (self.is_tuhao) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
      
    }else{
    
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
   
    
    
   
}

#pragma mark - 获取并设置当前购物车商品总价
-(void)getTotalprice
{
    self.totalPrice = 0;
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
    
    // 从结果集里面往下找
    while ([result next]) {
        shoppingcartModel * model = [[shoppingcartModel alloc]init];
        model.price = [result stringForColumn:@"price"];
        model.num = [result stringForColumn:@"num"];
        model.money = [result stringForColumn:@"money"];
        //获取到全部商品的总价,并改变价格显示
        if (self.is_tuhao) {
            self.totalPrice = self.totalPrice + [model.num integerValue] * [model.money integerValue];
        }else{
        
            self.totalPrice = self.totalPrice + [model.num integerValue] * [model.price integerValue];
        }
        
    }
    //重新设置底部视图的总价
    self.accountview.totalPrice.text = [NSString stringWithFormat:@"%ld",(long)self.totalPrice];
}

#pragma mark - 同步后台的购物车数据
-(void)getOrderInfo
{
    if (self.orders.count != 0) {
        [SVProgressHUD show];
    }
    [self.dataSource removeAllObjects];
    self.totalPrice = 0;
    //订单json信息
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:self.orders
                                                        options:kNilOptions
                                                          error:nil];
    NSString * json = [[NSString alloc] initWithData:JSONData
                                            encoding:NSUTF8StringEncoding];
    if (json != NULL && ![json isEqualToString:@"[]"])
    {
        NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
        parameters[@"uid"] = UID;
        parameters[@"token"] = TOKEN;
        parameters[@"data"] = json;
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        
        [manager POST:ORDER_INFO parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             NSLog(@"同步购物车删除%@",dict);
             NSArray * array = dict[@"data"];
             NSLog(@"错误码%@",dict[@"errcode"]);
             NSLog(@"错误码%@",dict[@"errmsg"]);
             NSLog(@"请求的json是%@",json);
             NSLog(@"返回的订单信息%@",dict[@"data"]);
             for (NSDictionary * dic in array)
             {
                 shoppingcartModel * model = [[shoppingcartModel alloc]initWithDictionary:dic error:nil];
                 [self.dataSource addObject:model];
                 //获取到全部商品的总价,并改变价格显示
                 self.totalPrice = self.totalPrice + [model.num integerValue] * [model.price integerValue];
             }
             [SVProgressHUD dismiss];
             
//             self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.dataSource.count * 120) style:UITableViewStyleGrouped];
             [self.tableView reloadData];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
         }];
    }
}

#pragma mark - 获取商品数据
-(void)getCartData
{
//    if (self.orders.count != 0) {
//        [SVProgressHUD show];
//    }
    [self.dataSource removeAllObjects];
    self.totalPrice = 0;
    //订单json信息
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:self.orders
                                                        options:kNilOptions
                                                          error:nil];
    NSString * json = [[NSString alloc] initWithData:JSONData
                                                 encoding:NSUTF8StringEncoding];
    if (json != NULL && ![json isEqualToString:@"[]"])
    {
        NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
        parameters[@"uid"] = UID;
        parameters[@"token"] = TOKEN;
        parameters[@"data"] = json;
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        
        [manager POST:ORDER_INFO parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             NSArray * array = dict[@"data"];
             NSLog(@"错误码%@",dict[@"errcode"]);
             NSLog(@"错误码%@",dict[@"errmsg"]);
             NSLog(@"请求的json是%@",json);
             NSLog(@"返回的订单信息%@",dict[@"data"]);
                 for (NSDictionary * dic in array)
                 {
                     shoppingcartModel * model = [[shoppingcartModel alloc]initWithDictionary:dic error:nil];
                     [self.dataSource addObject:model];
                     //获取到全部商品的总价,并改变价格显示
                     
                     if (model.lucky_type.integerValue==1) {
                      self.totalPrice = self.totalPrice + [model.num integerValue] * [model.money integerValue];
                     
                     }else{
                       self.totalPrice = self.totalPrice + [model.num integerValue] * [model.price integerValue];
                     }
                    
                     
                 }
             if (array.count==0) {
                 UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
                 item.badgeValue = nil;
             }else{
                 
               
                 UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
                 item.badgeValue =@"1" ;
             }
            
             [self.tableView reloadData];
             [SVProgressHUD dismiss];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
         }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count!=0) {
        self.tableView.hidden=NO;
        _myview.hidden=YES;
        //[_myview removeFromSuperview];
        self.PScrollView .hidden=YES;
    }else{
        
    }
    
    
    return self.dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 

    shoppingcarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    shoppingcartModel * model;
    if (self.dataSource.count != 0) {
        model = self.dataSource[indexPath.row];
    }
    cell.model = model;
    [cell setCellWithModel:self.is_tuhao];
    cell.delegate = self;
    cell.buyTextField.text = model.num;
    return cell;
}

-(void)changeBuyNumber:(NSIndexPath *)index
{
    [self getOrders];
    [self getCartData];
}

-(void)removeGoods:(NSIndexPath *)index
{
    
    
    
    NSLog(@"改变角标");
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    BOOL success =  [db executeUpdate:@"DELETE FROM t_contact"];
   // NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
    if (success)
    {
        UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
        item.badgeValue = nil;
        //移除商品
        //重新从数据库获取数据 并 单独刷新这一行
        [self.dataSource removeObjectAtIndex:index.row];
        [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
        //从数据库获取商品订单信息
        [self getOrders];
        //从服务器获取到最新订单信息
        [self getCartData];
        
        if (self.dataSource.count != 0)
        {
            //只刷新所有cell数据
            for (int i = 0; i < self.dataSource.count; i++)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            }
        }
        else
        {
            [self.tableView reloadData];
        }
        
        if (self.dataSource.count!=0) {
            //发送通知改变商品件数
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeAccount" object:nil userInfo:@{@"key":@(self.dataSource.count)}];

        }
        
    
    }
    
   
    
   
    //重新加载底部总价
   // [self getTotalprice];
}
-(void)refreshTotalPrice
{
    [self getOrders];
    [self getCartData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    return WIDTH * 0.375;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (self.dataSource.count == 0 || self.orders.count == 0) {
        for (UIView * view in self.view.subviews) {
            if (view.tag == 10) {
                [view removeFromSuperview];
            }
        }
        return YES;
    }
    else
    {
        //底部结算view
        self.accountview = [[NSBundle mainBundle]loadNibNamed:@"accountView" owner:self options:nil].firstObject;
        self.accountview.qujiesuanBt.layer.cornerRadius=4;
        if (self.is_tabBarHidden == YES)
        {
            self.accountview.frame = CGRectMake(0, HEIGHT-60, WIDTH, 60);
        }
        else
        {
        self.accountview.frame = CGRectMake(0, HEIGHT-60-44, WIDTH, 60);
        }
        
        self.accountview.tag = 10;
        //设置底部结算view的商品件数
        self.accountview.totalNumber.text = [NSString stringWithFormat:@"%d",self.dataSource.count];
        //设置底部结算view的总价
        //[self getTotalprice];
        //[self getCartData];
         self.accountview.totalPrice.text = [NSString stringWithFormat:@"%ld",(long)self.totalPrice];
        [self.view addSubview:self.accountview];
        return NO;
    }
}
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    //加入你自定义的view
    self.tableView.hidden=YES;
     _myview.hidden=NO;
    self.PScrollView.hidden=NO;
    
    
    //myview.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
   
    return nil;
}





-(void)getData:(NSString *)page andTop:(NSString *)top
{
     page=@"1";
     top=@"1";
    [ToolClass getPub_lucky:^(NSDictionary *dic) {
        

        
        NSArray *  array = dic[@"data"];
        
        for (NSDictionary * dict in array) {
            BuyTogetherModel * model = [[BuyTogetherModel alloc]initWithDictionary:dict error:nil];
           
            [self.otdataSource addObject:model];
        }
        [self.PScrollView.pageScrollView reloadData];
    } page:page andTop:top];
}

@end
