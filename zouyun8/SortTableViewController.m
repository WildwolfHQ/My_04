#import "SortTableViewController.h"
#import "SortTableViewCell.h"
#import "SortModel.h"
#import "SortDetailViewController.h"
@interface SortTableViewController ()<UISearchBarDelegate,SortTableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)UISearchBar * searchBar;
@end

@implementation SortTableViewController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(void)SelectSection:(SortModel *)model
{
    NSLog(@"弹出价格区间");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择价格区间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"1~99元" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushToSortDetail:@"1" andMax:@"100" andModel:model andName:@"1~99元" searchName:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"100~999元" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushToSortDetail:@"100" andMax:@"1000" andModel:model andName:@"100~999元" searchName:nil];

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"1000~4999元" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushToSortDetail:@"1000" andMax:@"5000" andModel:model andName:@"1000~4999元"searchName:nil];

    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"5000元以上" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushToSortDetail:@"5000" andMax:@"100000" andModel:model andName:@"5000元以上"searchName:nil];

    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            NSLog(@"取消了选择价格区间");
        }];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action6];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)pushToSortDetail:(NSString *)min andMax:(NSString *)max andModel:(SortModel *)model andName:(NSString * )name searchName:(NSString *)sName
{
    if (self.pgFenlei!=nil) {
        SortDetailViewController * sortDetail = [[SortDetailViewController alloc]init];
        sortDetail.min_price = min;
        sortDetail.max_price = max;
        sortDetail.categoryID = model.ID;
        sortDetail.name =sName;
        sortDetail.name1 =name;
        
        sortDetail.urlStr =PGFirstPageURL;
         sortDetail.isPG=@"1";
         [self.searchBar endEditing:YES];
        [self.navigationController pushViewController:sortDetail animated:YES];
        
    }else{
        SortDetailViewController * sortDetail = [[SortDetailViewController alloc]init];
        sortDetail.min_price = min;
        sortDetail.max_price = max;
        sortDetail.categoryID = model.ID;
        sortDetail.name = sName;
        sortDetail.name1 =name;
        
        sortDetail.urlStr =LUCKY_LIST;
         [self.searchBar endEditing:YES];
         [self.navigationController pushViewController:sortDetail animated:YES];
    }
   
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createSearchBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SortTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self getdata];
}
-(void)getdata
{
    
    
    NSString *urlStr=@"https://zy8.jf-q.com/api/category_list/?type=1";
    if (self.pgFenlei!=nil) {
        urlStr=self.pgFenlei;
    }
   

    
    
    [ToolClass getSort:^(NSDictionary *dic) {
        
        NSLog(@"分类信息是：%@",dic);
        NSArray * array = dic[@"data"];
        for (NSDictionary * dict in array)
        {
            SortModel * model = [[SortModel alloc]initWithDictionary:dict error:nil];
            [self.dataSource addObject:model];
            
        }
        [self.tableView reloadData];
        
    }  :urlStr] ;
}
-(void)createSearchBar
{
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
    //加上搜索栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH*0.6, 35)];
    UIColor *color =  self.navigationController.navigationBar.backgroundColor;
    
    [titleView setBackgroundColor:color];
    
    self.searchBar = [[UISearchBar alloc] init];
    
    self.searchBar.delegate = self;
    self.searchBar.frame = CGRectMake(0, 0, WIDTH*0.6, 35);
    self.searchBar.backgroundColor = color;
    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.layer.masksToBounds = YES;
    [self.searchBar.layer setBorderWidth:8];
    [self.searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    
    self.searchBar.placeholder = @"搜索宝贝";
    [titleView addSubview:self.searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.imageView.image = [UIImage imageNamed:@"IOS-晒单.jpg"];
//    cell.textLabel.text = @"手机平板";
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SortTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    SortModel * model = self.dataSource[indexPath.row];
    if (self.pgFenlei!=nil) {
        
        cell.pricequjian.hidden=YES;
        
    }
    cell.model = model;
    cell.name.text = model.name;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SortModel * model = self.dataSource[indexPath.row];
    [self pushToSortDetail:nil andMax:nil andModel:model andName:model.name searchName:nil];
}

#pragma mark - searchBar代理方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar endEditing:YES];
    [self pushToSortDetail:nil andMax:nil andModel:nil andName:self.searchBar.text searchName:self.searchBar.text];
}

@end
