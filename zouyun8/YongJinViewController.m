#import "YongJinViewController.h"
#import "YongJinCell.h"
@interface YongJinViewController ()

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"佣金";
    [ToolClass getUserInfoSuccess:^(NSDictionary *dic) {
        self.totalMoney.text = [NSString stringWithFormat:@"%@元",dic[@"data"][@"comm"]];
        NSLog(@"账户信息%@",dic);
        [self getData];
    }];
    self.tableView.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YongJinCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(void)getData
{
    [ToolClass getComm_log:^(NSDictionary *dic) {
        NSLog(@"佣金明细%@",dic);
        NSArray * array = [[NSArray alloc]init];
        array = dic[@"data"];
        for (NSDictionary * dict in array) {
            NSDictionary * d = @{@"create_time":dict[@"create_time"],@"comm":dict[@"comm"],@"msg":dict[@"msg"]};
            [self.dataSource addObject:d];
        }
        self.rechargeMoney.text = [NSString stringWithFormat:@"%@元",dic[@"cash_comm"]];
        self.yongjin.text = [NSString stringWithFormat:@"%.2f元",[self.totalMoney.text floatValue] - [self.rechargeMoney.text floatValue]];
        
        [self.tableView reloadData];
    } page:@"1"];
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
@end
