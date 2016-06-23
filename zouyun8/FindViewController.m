#import "FindViewController.h"
#import "ADViewController.h"
#import "NetShareViewController.h"

@interface FindViewController ()

@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation FindViewController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    self.title = @"发现";
}

-(void)getData
{
    [ToolClass getNewsList:^(NSDictionary *dic)
    {
        NSArray * array = dic[@"data"];
        for (NSDictionary * dict in array)
        {
            [self.dataSource addObject:dict];
        }
        [self.tableView reloadData];
    } ID:@"63785596"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count!=0) {
        return self.dataSource.count + 2;
    }else{
        
        return self.dataSource.count+1;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==self.dataSource.count + 2-1) {
        UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        FooterView * footerview1 = [[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:self
                                                              options:nil].firstObject;
        footerview1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        
        [cell addSubview:footerview1];
        cell.userInteractionEnabled=NO;
    
        return cell;

    }
    
    static NSString * ID = @"cell";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon_shaidan1"];
        cell.textLabel.text = @"网友晒单";
        cell.detailTextLabel.text = @"分享每一刻惊喜！一起来沾沾喜气吧！";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        NSDictionary * dict = self.dataSource[indexPath.row - 1];
        NSURL * url = [NSURL URLWithString:dict[@"thumb"]];
        NSData * data = [NSData dataWithContentsOfURL:url];
        cell.imageView.image = [UIImage imageWithData:data];
        cell.textLabel.text = dict[@"name"];
        cell.detailTextLabel.text = dict[@"description"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.dataSource.count+2-1) {
        return 40;
    }
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADViewController * ad = [[ADViewController alloc]init];
    if (indexPath.row == 0) {
        //跳转到网友晒单界面
        NetShareViewController * net = [[NetShareViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:net animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else
    {
        NSString * title;
        if (indexPath.row == 1) {
            title = @"申请试购员";
        }
        if (indexPath.row == 2) {
            title = @"申请代理";
        }
        if (indexPath.row == 3) {
            title = @"邀请必奖";
        }
        ad.url = self.dataSource[indexPath.row - 1][@"href"];
        ad.tip = title;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ad animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
