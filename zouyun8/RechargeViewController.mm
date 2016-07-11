#import "RechargeViewController.h"
#import "RechargeCell.h"
#import "UPPaymentControl.h"
#import "KKWebViewController.h"
@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource,RechargeCellDelegate>{
    NSMutableArray *_payType;

}
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSString * rechargeNum;
@property(nonatomic,copy)NSString * orderID;
@end

@implementation RechargeViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    [self paytype];
   
}


-(void)paytype{
    
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:@"https://m.zouyun8.com/api/paytype" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSNumber *errcode=dict[@"errcode"];
         if (errcode.integerValue==0) {
             
             
             
             _payType=[dict[@"data"] mutableCopy];
             
             
             [self createTableView];
             
         }else{
             
             
         }
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    
    
    
    
    
}
-(void)createTableView
{
    if (self.chongzhi.integerValue==1) {
          self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    }else{
        
     self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.origin.y+ self.navigationController.navigationBar.frame.size.height, WIDTH, HEIGHT-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    }
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
}

-(void)changeRechargeNum:(NSString *)num
{
    self.rechargeNum = num;
    NSLog(@"%@",self.rechargeNum);
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"选择充值金额(元)";
    }
    else
        return @"选择充值方式";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return _payType.count-1;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RechargeCell * cell = [[NSBundle mainBundle]loadNibNamed:@"RechargeCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
         NSDictionary *dic=_payType[indexPath.row+1];
      
           
            if ([dic[@"id"] integerValue]==1) {
                
               
            }else if([dic[@"id"] integerValue]==2){
               
                cell.imageView.image = [UIImage imageNamed:@"weixinkk"];
                cell.textLabel.text = @"   微信支付";
            
            }else if([dic[@"id"] integerValue]==3){
            
                cell.imageView.image = [UIImage imageNamed:@"yinliankk"];
                cell.textLabel.text = @"银联支付";
            }
        
            
     
       
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 91;
    }
    else
        return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        if (self.rechargeNum.integerValue==0) {
            
            [SVProgressHUD showErrorWithStatus:@"你还没选择金额"];
            
            return;
        }

       
        [ToolClass create_bill:^(NSDictionary *dict)
         {
             self.orderID = dict[@"data"][@"id"];
             //根据订单信息，获取到支付的参数
             [ToolClass getPayParameter:^(NSDictionary *dic) {
                // NSLog(@"支付参数为%@",dic);
                 //获取支付参数后调用微信或银联支付（此处微信）
                 if (dic[@"prepayid"] == NULL)
                 {
                     [SVProgressHUD showErrorWithStatus:@"获取订单失败，请重新提交"];
                     [NSThread sleepForTimeInterval:1];
                 }
                 else
                 {
                     //[SVProgressHUD showSuccessWithStatus:@"获取订单成功"];
                     //调用微信Sdk支付
                     //获取通知中心单例对象
                     NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                     //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
                     [center addObserver:self selector:@selector(weixinPaySuccessNotice:) name:@"weixinPaySuccessNotice" object:nil];

                     [self jumpToBizPay:dic];
                 }
             } orderID:self.orderID payType:@"1" andApp:@"1"];
             
         } order:nil addressID:nil is_discount:nil payID:@"2" payType:@"1" rechargeMoney:self.rechargeNum app:@"1"];
    }
    
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        [self unionPay];
        
    }
}


-(void)weixinPaySuccessNotice:(id)sender{
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    
}

//银联支付－创建订单 并 根据订单获取请求参数
-(void)unionPay
{
    //[self removeAllCart];
    //[ToolClass removeAllCart];
    
    if (self.rechargeNum.integerValue==0) {
        
        [SVProgressHUD showErrorWithStatus:@"你还没选择金额"];
        
        return;
    }
    
    [ToolClass create_bill:^(NSDictionary *dict)
     {
         self.orderID = dict[@"data"][@"id"];
         //根据订单信息，获取到支付的参数
         [ToolClass getPayParameter:^(NSDictionary *dic) {
             //NSLog(@"支付参数为%@",dic);
             
             
             if (dic[@"strHtml"] == NULL)
             {
                 [SVProgressHUD showErrorWithStatus:@"获取订单失败，请重新提交"];
                 [NSThread sleepForTimeInterval:1];
             }
             else
             {
                 //[SVProgressHUD showSuccessWithStatus:@"获取订单成功"];
                 
                 
                 
                 NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                 //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
                 [center addObserver:self selector:@selector(unionPaySuccessNotice:) name:@"yinliansuccess"object:nil];
                 
                 KKWebViewController *VC=[[KKWebViewController alloc]init];
                 VC.htmlStr=dic[@"strHtml"];
                 self.hidesBottomBarWhenPushed=YES;
                 [self.navigationController pushViewController:VC animated:YES];
                 //[self UnionPay:dic[@"tn"]];
                 //[self jumpToBizPay:dic];
             }
             

             
             
//             if (dic[@"tn"] == NULL)
//             {
//                 [SVProgressHUD showErrorWithStatus:@"获取订单失败，请重新提交"];
//                 [NSThread sleepForTimeInterval:1];
//             }
//             else
//             {
//                 //[SVProgressHUD showSuccessWithStatus:@"获取订单成功"];
//                 
//                 //调用银联支付助手
//                 [self UnionPay:dic[@"tn"]];
//                 
//             }
             
             
             
             
         } orderID:self.orderID payType:@"1" andApp:@"0"];
         
     } order:nil addressID:nil is_discount:nil payID:@"3" payType:@"1" rechargeMoney:self.rechargeNum  app:@"0"];  // payID 1走运币 2微信 3银联
    
    
    
}
//银联支付－调起支付控键
-(void)UnionPay:(NSString *)tn{
    
    if ([[UPPaymentControl defaultControl] isPaymentAppInstalled]) {
        
        if ([[UPPaymentControl defaultControl] startPay:tn fromScheme:@"zouyun8" mode:@"00" viewController:self])
        {
            
            //获取通知中心单例对象
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
            [center addObserver:self selector:@selector(unionPaySuccessNotice:) name:@"unionPaySuccess" object:nil];
            
        }else{
            
            [SVProgressHUD showSuccessWithStatus:@"调起银联支付控件失败"];
            
        }
        
    }else{
        [SVProgressHUD showSuccessWithStatus:@"未安装银联支付APP"];
        
        
    }
    
    
    
    
    
}




//银联支付成功后回调向商户后台请求是否收到资金
-(void)unionPaySuccessNotice:(id)sender{
    
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    parameters[@"id"] = self.orderID;
    parameters[@"type"] = @"0";
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:@"https://m.zouyun8.com/api/pay_status" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * str=dict[@"code"];//code	int	必须	0表示到账，1表示未到帐
         
         if (str.integerValue==0) {
             
             [SVProgressHUD showSuccessWithStatus:@"支付成功"];
             // [self.navigationController popViewControllerAnimated:YES];
             
         }else{
             
             [SVProgressHUD showSuccessWithStatus:@"支付失败"];
             
             
         }
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    
    
    
    
    NSLog(@"%@",sender);
}










//微信支付方法
-(NSString *)jumpToBizPay:(NSDictionary *)dict
{
    NSLog(@"进来了%@",dict);
    [SVProgressHUD showWithStatus:@"正在加载微信支付"];
    //判断当前设备是否安装了微信
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装微信");
        [SVProgressHUD showErrorWithStatus:@"没有安装微信"];
        return nil;
    }
    else if (![WXApi isWXAppSupportApi])
    {
        NSLog(@"不支持微信支付");
        return nil;
    }
    NSLog(@"安装了微信，且支持微信支付");
    
    if (dict != nil)
    {
        if(dict != nil)
        {
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            NSLog(@"微信支付啊%d",retcode.intValue);
            if (retcode.intValue == 0)
            {
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                [SVProgressHUD dismiss];
                return @"";
            }
            else
            {
                [SVProgressHUD dismiss];
                return [dict objectForKey:@"retmsg"];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            return @"服务器返回错误，未获取到json对象";
        }
    }
    else
    {
        [SVProgressHUD dismiss];
        return @"服务器返回错误";
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.tableView endEditing:YES];
    
}


- (void)commentTableViewTouchInSide{
    
    [self.tableView endEditing:YES];
}
@end
