//
//  PastAnnouncedTableViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/6.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "PastAnnouncedTableViewController.h"
#import "History_lucky.h"
@interface PastAnnouncedTableViewController ()
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation PastAnnouncedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource=[NSMutableArray array];
    [self getData:self.goods_id page:nil :NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PastAnnouncedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        
        [self.tableView registerNib:[UINib nibWithNibName:@"PastAnnouncedTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    }
    
    History_lucky *model=self.dataSource[indexPath.row];
    
    
    [cell setProperty:model];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    History_lucky * model =self.dataSource[indexPath.row];
    GoodsDetailController *VC=[[GoodsDetailController alloc]init];
    [VC setValue:model.lucky_id forKey:@"lucky_id"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

/*
 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 获取商品数据
-(void)getData:(NSString *)goods_id page:(NSString *)page :(BOOL)isrash
{
    
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if (goods_id!=nil) {
        params[@"goods_id"] = goods_id;//
    }
    if (page!=nil) {
        params[@"page"] = page;//string	可选	商品名称，可模糊搜索
    }
    
    //    params[@"page"] = @"";//int	可选	分页页码，默认为第一页
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:History_lucky_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         NSLog(@"%@",dict);
         NSArray * array = dict[@"data"];
         //请求成功,将图片下载完保存到数组中
         if (isrash) {
             [self.dataSource removeAllObjects];
         }

         for (NSDictionary * dic in array)
         {
             
             
             
             History_lucky * model = [[History_lucky alloc]initWithDictionary:dic error:nil];
             
             if (model!=nil) {
                 
                 
                 
                 [self.dataSource addObject:model];
             }
             
         }
         [self.tableView reloadData];
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}


static int page;
- (void)viewDidLayoutSubviews
{
    __weak PastAnnouncedTableViewController *weakSelf = self;
    //下拉操作
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            
            
            [weakSelf getData:weakSelf.goods_id page:nil :YES];
            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        });
    }];
    
    //上拉操作
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
             page=page+1;
            [weakSelf getData:weakSelf.goods_id page:[NSString stringWithFormat:@"%@",@(page)] :NO];
            
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
        
        
    }];
}


@end
