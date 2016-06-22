#import "MoneyDetailViewController.h"
#import "RechargeViewController.h"

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
    static NSString * ID = @"cell";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSDictionary * dict = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"订单:%@ %@",dict[@"id"],dict[@"pay_type"]];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",dict[@"money"]];
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
    RechargeViewController * recharge = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:recharge animated:YES];
}
@end
