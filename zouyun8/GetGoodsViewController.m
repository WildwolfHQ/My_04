//
//  GetGoodsViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "GetGoodsViewController.h"
#import "GetGoodsViewCell.h"
#import "Mylucky.h"
#import "GoodsWebViewController.h"
#import "GetGoodsViewCell1.h"
@interface GetGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    int page;
    
}
@property(nonatomic,strong)NSMutableArray * dataSource;         //数据源

@end

@implementation GetGoodsViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我获得的商品";
    self.dataSource=[NSMutableArray array];
     page=1;
    [self getDataForMylucky_URL:nil andPage:@"1" isRefresh:NO];
    [self drawTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    Mylucky  *  model=self.dataSource[row];
    if ([model.status isEqualToString:@"待发货"]) {
        
        GetGoodsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GetGoodsViewCell"];
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"GetGoodsViewCell" bundle:nil] forCellReuseIdentifier:@"GetGoodsViewCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GetGoodsViewCell"];
            
        }
        
        
        [cell setProperty:model];
         return cell;
    }else{
    
        GetGoodsViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"GetGoodsViewCell1"];
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"GetGoodsViewCell1" bundle:nil] forCellReuseIdentifier:@"GetGoodsViewCell1"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GetGoodsViewCell1"];
            
        }
        
        
        [cell setProperty:model and:self];
        return cell;

    }
    
//    if ([model.status isEqualToString:@"已发货"]) {
//       
//    }
//    //已完成
//    GetGoodsViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"GetGoodsViewCell1"];
//    if (cell==nil) {
//        [tableView registerNib:[UINib nibWithNibName:@"GetGoodsViewCell1" bundle:nil] forCellReuseIdentifier:@"GetGoodsViewCell1"];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"GetGoodsViewCell1"];
//        
//    }
//    
//     [cell setProperty:model and:self andData:self.dataSource];
//   
//
//    
//    return cell;
    

    
    
    
    
    
    
    
   
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     Mylucky  *  model=self.dataSource[indexPath.row];
    if ([model.status isEqualToString:@"待发货"]) {
    return 100;
    }else{
    return 160;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Mylucky   *model=self.dataSource[indexPath.row];
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    
    if (model.lucky_id.integerValue!=0) {
        VC.lucky_id=model.lucky_id;
    }else{
    
        VC.bid_id=model.bid_id;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)getDataForMylucky_URL:(NSMutableDictionary*)dic andPage:(NSString *)page isRefresh:(BOOL)refresh
{
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    if (page!=nil) {
        parameters[@"page"] = page;
    }
    
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Mylucky_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"订单详情%@",dict);
         NSArray *array=dict[@"data"];
         if (refresh) {
             [self.dataSource removeAllObjects];
         }
         
         for (NSDictionary *dic in array) {
             Mylucky   *model = [[Mylucky alloc]initWithDictionary:dic error:nil];
             
             if (model!=nil) {
                 
                 [self.dataSource addObject:model];
                 
                 
             }else{
                 
                 
                 
             }
             
             
         }
         
         [_tableView reloadData];
         
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
     }];
}



- (void)viewDidLayoutSubviews
{
    __weak  GetGoodsViewController *weakSelf = self;
    __weak UITableView *weak_tableView = _tableView;
    //下拉操作
    [_tableView addPullToRefreshWithActionHandler:^{
        
        page=1;
        [weakSelf getDataForMylucky_URL:nil andPage:@"1" isRefresh:YES];
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            [weak_tableView.pullToRefreshView stopAnimating];
        });
    }];
    
    //上拉操作
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf getDataForMylucky_URL:nil andPage:[NSString stringWithFormat:@"%d",++page] isRefresh:NO];
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            
            [weak_tableView.infiniteScrollingView stopAnimating];
        });
        
        
    }];
}


@end
