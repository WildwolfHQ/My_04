//
//  JointPurchaseViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/18.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "JointPurchaseViewController.h"
#import "JointPurchaseCell1.h"
#import "Myoriginate.h"
#import "GoodsWebViewController.h"
@interface JointPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
   
    
}
@property(nonatomic,strong)NSMutableArray * dataSource;         //数据源

@end

@implementation JointPurchaseViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"发起的合购";
    self.dataSource=[NSMutableArray array];
    [self getDataForMyoriginate_URL:nil andPage:nil isRefresh:NO];
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
    
    Myoriginate *  model=self.dataSource[row];
    
    if (model.buy_type!=nil&&model.buy_type.integerValue == 11) {
        //self.statas.text=@"已失效";
        
        JointPurchaseCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"JointPurchaseCell2"];
        if (cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"JointPurchaseCell1" bundle:nil] forCellReuseIdentifier:@"JointPurchaseCell2"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"JointPurchaseCell2"];
           
        }
        cell.huojiangshijian.hidden=YES;
        cell.dianjigongkai.hidden=YES;
        
        [cell setProperty:model];
        
        return cell;
        
        
    } else if (model.lucky_userid.integerValue!= 0) {
        //self.statas.text=@"已结束";
        
        JointPurchaseCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"JointPurchaseCell3"];
        if (cell==nil) {
            
            
            [tableView registerNib:[UINib nibWithNibName:@"JointPurchaseCell1" bundle:nil] forCellReuseIdentifier:@"JointPurchaseCell3"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"JointPurchaseCell3"];
            
            
            
            
        }
        cell.huojiangshijian.hidden=NO;
        cell.dianjigongkai.hidden=YES;
        
        [cell setProperty:model];
         return cell;

    } else if (model.lucky_userid.integerValue == 0
               && model.buy_type.integerValue != 11) {
        //self.statas.text=@"进行中";
        
        JointPurchaseCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"JointPurchaseCell1"];
        if (cell==nil) {
            
            
            [tableView registerNib:[UINib nibWithNibName:@"JointPurchaseCell1" bundle:nil] forCellReuseIdentifier:@"JointPurchaseCell1"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"JointPurchaseCell1"];
            
            
            
            
        }
        cell.huojiangshijian.hidden=YES;
        cell.dianjigongkai.hidden=NO;
        cell.dianjigongkai.tag=row;
        [cell.dianjigongkai addTarget:self action:@selector(dianjigongkai:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setProperty:model];
         return cell;

    }else{
    
     return nil;
    
    }

    
    
    
 
    
    
    

    
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 141;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
                Myoriginate   *model=self.dataSource[indexPath.row];
                GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
                VC.lucky_id=model.ID;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
}

-(void)getDataForMyoriginate_URL:(NSMutableDictionary*)dic andPage:(NSString *)page isRefresh:(BOOL)refresh
{
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Myoriginate_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"订单详情%@",dict);
         NSArray *array=dict[@"data"];
         
         if (refresh) {
             [self.dataSource removeAllObjects];
         }

         for (NSDictionary *dic in array) {
             Myoriginate   *model = [[Myoriginate alloc]initWithDictionary:dic error:nil];
             
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dianjigongkai:(UIButton *)seder{
    
        Myoriginate *model=self.dataSource[seder.tag];
 
        GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
        VC.lucky_id=model.ID;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];

   

}

static int page=0;
- (void)viewDidLayoutSubviews
{
    __weak JointPurchaseViewController *weakSelf = self;
    __weak UITableView *weak_tableView = _tableView;
    //下拉操作
    [_tableView addPullToRefreshWithActionHandler:^{
        
        
        [weakSelf getDataForMyoriginate_URL:nil andPage:nil isRefresh:YES];
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            [weak_tableView.pullToRefreshView stopAnimating];
        });
    }];
    
    //上拉操作
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf getDataForMyoriginate_URL:nil andPage:[NSString stringWithFormat:@"%d",++page] isRefresh:NO];
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            
            [weak_tableView.infiniteScrollingView stopAnimating];
        });
        
        
    }];
}

@end
