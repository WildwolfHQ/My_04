#import "YongJinViewController.h"
#import "YongJinCell.h"
#import "TixianVC.h"
#import "DuihuanzouyunbiView.h"
#import "JKAlertDialog.h"
@interface YongJinViewController (){

    DuihuanzouyunbiView *duihuanzouyunbiView;
    JKAlertDialog *alert;
}

@end

@implementation YongJinViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (IBAction)duihuanzouyunbiBt:(UIButton *)sender {
    
    
    duihuanzouyunbiView = [[NSBundle mainBundle]loadNibNamed:@"DuihuanzouyunbiView" owner:self options:nil].firstObject;
    duihuanzouyunbiView.jineF.delegate=duihuanzouyunbiView;
    
    if (iPhone4||iPhone5) {
        duihuanzouyunbiView.frame=CGRectMake(0, 0, 264, 176);

        
    }else if(iPhone6){
        duihuanzouyunbiView.frame=CGRectMake(0, 0, 264, 176);
    }else{
        
        duihuanzouyunbiView.frame=CGRectMake(0, 0, 264, 176);
        
    }
    //[alertDialogSubView setdata:array addPrice:self.model.money addArray1:array1];
    
    
    alert = [[JKAlertDialog alloc]init];
    [self.view addSubview:alert];
    alert.contentView =  duihuanzouyunbiView;
    alert.contentViewSize=duihuanzouyunbiView.frame.size;
    
    
    [alert show];
    
    [duihuanzouyunbiView.quedingduihuanBt addTarget:self action:@selector(quedingduihuanBt1) forControlEvents:UIControlEventTouchUpInside ];
//
//
    
    [duihuanzouyunbiView.dismissBt addTarget:self action:@selector(dismissAlertBt1) forControlEvents:UIControlEventTouchUpInside ];
    
    
    
    
}

-(void)quedingduihuanBt1{
    [alert dismiss];
    
    if (duihuanzouyunbiView.jineF.text.length==0) {
//        [SVProgressHUD showErrorWithStatus:@"请输入兑换金额！"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入兑换金额！" preferredStyle:UIAlertControllerStyleAlert];
        //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
            
        {
            
            
            [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alertController repeats:NO];
            
            
        }

        return;
    }
    
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
   
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    
    parameters[@"comm"] = duihuanzouyunbiView.jineF.text;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Comm_to_money parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSNumber * errcode = dict[@"errcode"];
         NSString *str;
         if ([errcode integerValue]==0)
         {
             //[SVProgressHUD showSuccessWithStatus:@"兑换成功"];
             str=@"兑换成功";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rusah_y" object:nil];

         }
         else
         {
             str=dict[@"errmsg"];
//            [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
         //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
         if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
             
         {
             
             
             [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
             
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alertController repeats:NO];
             
             
         }

         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    
    
}
-(void)dismissAlertBt1{
    [alert dismiss];
    
}

- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alertController = [timer userInfo];
    [alertController dismissViewControllerAnimated:YES completion:nil];
     alertController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"佣金明细";
    self.duihuanzouyunbiBt.layer.cornerRadius=4;
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem=barbtn;
    [ToolClass getUserInfoSuccess:^(NSDictionary *dic) {
        NSString *str=dic[@"data"][@"comm"];
       self.yongjin.text = [NSString stringWithFormat:@"%.2f元",str.floatValue ];
        NSLog(@"账户信息%@",dic);
        [self getData:NO andPage:1];
    }];
    self.tableView.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YongJinCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updata1) name:@"rusah_y" object:nil];
   

}
//提现
-(void)share{
    TixianVC *VC=[[TixianVC alloc]init];
    VC.yongjing=self.yongjin.text;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
    
    
    

}

-(void)updata1{
     page=1;
    [ToolClass getUserInfoSuccess:^(NSDictionary *dic) {
        NSString *str=dic[@"data"][@"comm"];
        self.yongjin.text = [NSString stringWithFormat:@"%.2f元",str.floatValue ];
        NSLog(@"账户信息%@",dic);
        [self getData:YES andPage:1];
    }];
    
    
}

-(void)getData:(BOOL)updata andPage:(int)page
{
    [ToolClass getComm_log:^(NSDictionary *dic) {
        NSLog(@"佣金明细%@",dic);
         //array = [[NSArray alloc]init];
        NSArray *array = dic[@"data"];
        if (updata) {
            
            [self.dataSource removeAllObjects];
        }
        
        for (NSDictionary * dict in array) {
            NSDictionary * d = @{@"create_time":dict[@"create_time"],@"comm":dict[@"comm"],@"msg":dict[@"msg"],@"type":dict[@"type"]};
            [self.dataSource addObject:d];
        }
        self.totalMoney.text =[NSString stringWithFormat:@"%.2f元",[dic[@"total_comm"] floatValue]] ;
        self.rechargeMoney.text = [NSString stringWithFormat:@"%.2f元",[dic[@"cash_comm"] floatValue]];
        [self.tableView reloadData];
    } page:[NSString stringWithFormat:@"%d",page]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]init];
        cell.frame=CGRectMake(0, 0, WIDTH, 44);
        UIView * view = [[NSBundle mainBundle]loadNibNamed:@"tips2" owner:self options:nil].firstObject;
        view.frame=CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        [cell addSubview:view];
        
        return cell;
    }
    else
    {
    YongJinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.frame=CGRectMake(0, 0, WIDTH, 44);
    NSDictionary * dic = self.dataSource[indexPath.row - 1];
    cell.time.text = dic[@"create_time"];
    cell.desc.text = dic[@"msg"];
        
        
        
        if ([dic[@"type"] integerValue] > 10) {
             cell.money.textColor=[UIColor greenColor];
             cell.money.text = [NSString stringWithFormat:@"-%@",dic[@"comm"]];
        }else{
            cell.money.textColor=[UIColor redColor];
             cell.money.text = [NSString stringWithFormat:@"+%@",dic[@"comm"]];
        }
   

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }
}

static int page=1;
- (void)viewDidLayoutSubviews
{
    
    __weak YongJinViewController *weakSelf = self;
   
    //下拉操作
    [self.tableView addPullToRefreshWithActionHandler:^{
        
          page=1;
         [weakSelf getData:YES andPage:1];
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            
        });

        
        
    }];
    
    //上拉操作
    [self.tableView addInfiniteScrollingWithActionHandler:^{
       
             page += 1;
            [weakSelf getData:NO andPage:page];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
       
       
    }];
}

@end
