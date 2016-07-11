#import "MoneyDetailViewController.h"
#import "RechargeViewController.h"
#import "YongJinCell.h"
@interface MoneyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation MoneyDetailViewController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"明细";
    self.imageView.backgroundColor = [UIColor redColor];
    self.money.text = self.zouyunbi;
    [self getData:@"0"];
    [self createTableView];
    self.quchongzhiBt.layer.cornerRadius=4;
}

-(void)getData:(NSString *)type
{
    [ToolClass getMoney_log:^(NSDictionary *dic)
    {
        NSLog(@"%@",dic);
        NSArray * array = dic[@"data"];
        [self.dataSource removeAllObjects];
        for (NSDictionary * dict in array)
        {
            [self.dataSource addObject:dict];
        }
        [self.tableView reloadData];
    } type:type];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170, WIDTH, HEIGHT - 49 - 132) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
   YongJinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YongJinCell"];
    
    if (cell == nil) {
       [tableView registerNib:[UINib nibWithNibName:@"YongJinCell" bundle:nil] forCellReuseIdentifier:@"YongJinCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"YongJinCell"];
    }
    NSDictionary * dict = self.dataSource[indexPath.row];
    
    cell.time.text =[NSString stringWithFormat:@"%@",dict[@"pay_time"]];
    //cell.time.font=[UIFont systemFontOfSize:8];
    cell.desc.text = [NSString stringWithFormat:@"%@",dict[@"pay_type"]];
    cell.money.text = [NSString stringWithFormat:@"%@元",dict[@"money"]];
//    cell.textLabel.text = [NSString stringWithFormat:@"时间:%@",dict[@"pay_time"]];
//    cell.textLabel.font = [UIFont systemFontOfSize:12];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",dict[@"money"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (IBAction)消费明细:(UIButton *)sender {
//    [self swipe:sender];
    [UIView animateWithDuration:0.5 animations:^{
    self.imageView.frame = CGRectMake(0, 165, WIDTH/2, 5);
    }];
    
    //刷新消费明细
    [self getData:@"0"];
}
- (IBAction)充值明细:(UIButton *)sender
{
    NSLog(@"点击了充值");
//    [self swipe:sender];
    [UIView animateWithDuration:0.5 animations:^{
    self.imageView.frame = CGRectMake(WIDTH/2, 165, WIDTH/2, 5);
    }];
    
    //刷新充值信息
    [self getData:@"1"];
}

-(void)swipe:(UIButton *)b
{
    for (int i=0; i<2; i++)
    {
        UIButton *btn = [self.view viewWithTag:10+i];
        btn.selected = NO;
    }
    b.selected = YES;
}
- (IBAction)去充值:(id)sender {
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
                 RechargeViewController * recharge = [[RechargeViewController alloc]init];
                 self.hidesBottomBarWhenPushed = YES;
                 
                 [self.navigationController pushViewController:recharge animated:YES];
             }else{
                 
                 
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.zouyun8.com/u/recharge/?uid=%@&token=%@",UID,TOKEN ]]];
             }
             
             
         }else{
             
             
         }
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
    
    
    
    
    
}

@end
