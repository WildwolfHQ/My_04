#import "AllOrderViewController.h"
#import "AllOrderCell.h"
#import "AllOrderModel.h"
#import "AllOrderDetailsViewController.h"
@interface AllOrderViewController ()

@end

@implementation AllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部订单";
    [self.tableView registerNib:[UINib nibWithNibName:@"AllOrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(void)getdata
{
//    [ToolClass getEvaluate_all_list:^(NSDictionary *dic) {
//        NSLog(@"获取到的晒单%@",dic);
//        NSArray * array = [[NSArray alloc]init];
//        array = dic[@"data"];
//        for (NSDictionary * dict in array) {
//            NetShareModel * model = [[NetShareModel alloc]initWithDictionary:dict error:nil];
//            
//            //根据文字和图片约束的高度设置model.height的值
//            CGFloat height = [self heightForString:model.name fontSize:12 andWidth:WIDTH - 89] + [self heightForString:model.title fontSize:12 andWidth:WIDTH - 89];
//            model.height = height;
//            [self.dataSource addObject:model];
//            
//            NSData * data = [model.images dataUsingEncoding:NSASCIIStringEncoding];
//            NSMutableArray * array = [self toArrayOrNSDictionary:data];
//            [self.counts addObject:[NSNumber numberWithInteger:array.count]];
//        }
//        //        NetShareModel * model = self.dataSource[6];
//        //        NSLog(@"第六个%@",model.images);
//        [self.tableView reloadData];
//    } page:[NSString stringWithFormat:@"%ld",self.page]];
    [ToolClass getMyBill:^(NSDictionary *dic) {
        NSLog(@"获取到的我的订单%@",dic);
        NSArray * array = [[NSArray alloc]init];
        array = dic[@"data"];
        for (NSDictionary * dict in array)
        {
            AllOrderModel * model = [[AllOrderModel alloc]initWithDictionary:dict error:nil];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } page:[NSString stringWithFormat:@"%ld",self.page]];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      AllOrderModel * model = self.dataSource[indexPath.row];
    //跳转到订单详情页面
    
    
    
    AllOrderDetailsViewController *VC=[[AllOrderDetailsViewController alloc]init];

    VC.orderID=model.ID;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    AllOrderModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithModel:model];
    return cell;
}

@end
