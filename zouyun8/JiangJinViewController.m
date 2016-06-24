#import "JiangJinViewController.h"
#import "JiangJinCell.h"


@interface JiangJinViewController ()

@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation JiangJinViewController

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
    self.title=@"奖金";
    [self getData];
    [self.tableView registerNib:[UINib nibWithNibName:@"JiangJinCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    
}

-(void)getData
{
    [ToolClass getScore_log:^(NSDictionary *dic) {
        NSLog(@"奖金明细%@",dic);
        NSArray * array = [[NSArray alloc]init];
        array = dic[@"data"];
        for (NSDictionary * dict in array) {
            NSDictionary * d = @{@"create_time":dict[@"create_time"],@"score":dict[@"score"],@"msg":dict[@"msg"],@"type":dict[@"type"]};
            [self.dataSource addObject:d];
        }
        [self.tableView reloadData];

    } page:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]init];
        UIView * view = [[NSBundle mainBundle]loadNibNamed:@"tips" owner:self options:nil].firstObject;
        [cell addSubview:view];
        return cell;
    }
    else
    {
    JiangJinCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dic = self.dataSource[indexPath.row - 1];
    cell.time.text = dic[@"create_time"];
    cell.desc.text = dic[@"msg"];
    if ([dic[@"type"] integerValue] > 10) {
        cell.getOrPay.textColor = [UIColor greenColor];
        cell.getOrPay.text = [NSString stringWithFormat:@"-%@",dic[@"score"]];
    }
    else
    {
        cell.getOrPay.textColor = [UIColor redColor];
        cell.getOrPay.text = [NSString stringWithFormat:@"+%@",dic[@"score"]];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

@end
